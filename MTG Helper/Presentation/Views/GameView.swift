//
//  GameView.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 30/10/2025.
//

import SwiftUI

/// Vue principale pour le suivi de partie
struct GameView: View {
    @StateObject var viewModel: GameViewModel
    @State private var selectedPlayerId: UUID?
    @State private var showNameEditor = false
    @State private var editingPlayerName = ""
    
    var body: some View {
        ZStack {
            if let game = viewModel.game {
                activeGameView(game: game)
                
                VStack {
                    HStack {
                        Spacer()
                        
                        Menu {
                            Button(action: { viewModel.resetAllLife() }) {
                                Label("Reset", systemImage: "arrow.clockwise")
                            }
                            
                            Button(role: .destructive, action: { viewModel.endGame() }) {
                                Label("End Game", systemImage: "xmark.circle")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(12)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Circle())
                        }
                        .padding()
                    }
                    
                    Spacer()
                }
            } else {
                NavigationView {
                    emptyStateView
                        .navigationTitle("Game")
                }
            }
        }
        .sheet(isPresented: $viewModel.showNewGameSheet) {
            NewGameSheetView(onStart: { format, playerCount in
                viewModel.startNewGame(format: format, playerCount: playerCount)
            })
        }
        .sheet(isPresented: $showNameEditor) {
            if let playerId = selectedPlayerId {
                PlayerNameEditorView(
                    currentName: editingPlayerName,
                    onSave: { newName in
                        viewModel.updatePlayerName(for: playerId, to: newName)
                        showNameEditor = false
                    }
                )
            }
        }
        .alert("Game Over", isPresented: $viewModel.showWinnerAlert) {
            Button("New Game") {
                viewModel.showNewGameSheet = true
            }
            Button("End") {
                viewModel.endGame()
            }
        } message: {
            if let winner = viewModel.game?.winner {
                Text("\(winner.name) won the game!")
            }
        }
    }
    
    private func activeGameView(game: Game) -> some View {
        VStack(spacing: 0) {
            ForEach(Array(game.players.enumerated()), id: \.element.id) { index, player in
                PlayerCardView(
                    player: player,
                    isRotated: shouldRotate(playerIndex: index, totalPlayers: game.players.count),
                    onLifeChange: { amount in
                        viewModel.adjustLife(for: player.id, by: amount)
                    },
                    onPoisonChange: { amount in
                        viewModel.adjustPoison(for: player.id, by: amount)
                    },
                    onNameEdit: {
                        selectedPlayerId = player.id
                        editingPlayerName = player.name
                        showNameEditor = true
                    }
                )
                .frame(maxHeight: .infinity)
                
                if index < game.players.count - 1 {
                    Divider()
                        .background(Color.gray.opacity(0.3))
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    /// Determines if a player should be rotated 180°
    /// - Parameters:
    ///   - playerIndex: Player index
    ///   - totalPlayers: Total number of players
    /// - Returns: true if the player should be rotated
    private func shouldRotate(playerIndex: Int, totalPlayers: Int) -> Bool {
        switch totalPlayers {
        case 2:
            return playerIndex == 0
        case 3:
            return playerIndex == 0 || playerIndex == 1
        case 4:
            return playerIndex == 0 || playerIndex == 1
        default:
            return playerIndex % 2 == 0
        }
    }
    
    private func gameInfoView(game: Game) -> some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(formatName(game.format))
                        .font(.headline)
                    Text("\(game.players.count) players")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("In Progress")
                        .font(.caption)
                        .foregroundColor(.green)
                    Text(timeElapsed(since: game.startDate))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "dice")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No game in progress")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Create a new game to start tracking life points")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button(action: { viewModel.showNewGameSheet = true }) {
                Label("New Game", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
    
    private func formatName(_ format: GameFormat) -> String {
        switch format {
        case .standard:
            return "Standard (20 HP)"
        case .commander:
            return "Commander (40 HP)"
        case .custom(let life):
            return "Custom (\(life) HP)"
        }
    }
    
    private func timeElapsed(since date: Date) -> String {
        let elapsed = Date().timeIntervalSince(date)
        let minutes = Int(elapsed / 60)
        let seconds = Int(elapsed.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

/// View to create a new game
struct NewGameSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedFormat: GameFormat = .standard
    @State private var playerCount = 2
    @State private var customLife = 20
    
    let onStart: (GameFormat, Int) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section("Format") {
                    Picker("Format", selection: $selectedFormat) {
                        Text("Standard (20 HP)").tag(GameFormat.standard)
                        Text("Commander (40 HP)").tag(GameFormat.commander)
                        Text("Custom").tag(GameFormat.custom(startingLife: customLife))
                    }
                    .pickerStyle(.segmented)
                    
                    if case .custom = selectedFormat {
                        Stepper("Life points: \(customLife)", value: $customLife, in: 1...100)
                    }
                }
                
                Section("Players") {
                    Stepper("Number of players: \(playerCount)", value: $playerCount, in: 2...4)
                }
            }
            .navigationTitle("New Game")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Start") {
                        let format: GameFormat = {
                            if case .custom = selectedFormat {
                                return .custom(startingLife: customLife)
                            }
                            return selectedFormat
                        }()
                        onStart(format, playerCount)
                        dismiss()
                    }
                }
            }
        }
    }
}

/// View to edit a player's name
struct PlayerNameEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    let onSave: (String) -> Void
    
    init(currentName: String, onSave: @escaping (String) -> Void) {
        _name = State(initialValue: currentName)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Player name", text: $name)
            }
            .navigationTitle("Edit Name")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(name)
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

#Preview {
    GameView(viewModel: GameViewModel())
}
