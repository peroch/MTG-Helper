//
//  PlayerCardView.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 30/10/2025.
//

import SwiftUI

/// Vue représentant la carte d'un joueur avec ses compteurs
struct PlayerCardView: View {
    let player: Player
    let isRotated: Bool
    let onLifeChange: (Int) -> Void
    let onPoisonChange: (Int) -> Void
    let onNameEdit: () -> Void
    
    @State private var showPoisonControls = false
    
    var body: some View {
        contentView
            .rotationEffect(.degrees(isRotated ? 180 : 0))
            .opacity(player.hasLost ? 0.5 : 1.0)
    }
    
    private var contentView: some View {
        VStack(spacing: 0) {
            headerView
            
            lifeCounterView
            
            if showPoisonControls {
                poisonCounterView
            }
        }
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(player.hasLost ? Color.gray : headerColor, lineWidth: 2)
        )
    }
    
    private var headerView: some View {
        HStack {
            Text(player.name)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            Spacer()
            
            if showPoisonControls && player.poisonCounters > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "drop.fill")
                        .font(.caption)
                    Text("\(player.poisonCounters)")
                        .font(.system(size: 14, weight: .bold))
                }
                .foregroundColor(player.poisonCounters >= 10 ? .red : .white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.black.opacity(0.3))
                .clipShape(Capsule())
            }
            
            Button(action: onNameEdit) {
                Image(systemName: "pencil.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white.opacity(0.9))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(headerColor)
    }
    
    private var lifeCounterView: some View {
        HStack(spacing: 0) {
            Button(action: { onLifeChange(-1) }) {
                VStack(spacing: 4) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 32))
                    Text("-1")
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.red.opacity(0.9))
            }
            
            VStack(spacing: 4) {
                Text("\(player.life)")
                    .font(.system(size: 64, weight: .bold))
                    .foregroundColor(lifeColor)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                
                if player.hasLost {
                    Text("Eliminated")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                }
                
                Button(action: { showPoisonControls.toggle() }) {
                    HStack(spacing: 4) {
                        Image(systemName: showPoisonControls ? "drop.fill" : "drop")
                        Text("Poison")
                    }
                    .font(.system(size: 12))
                    .foregroundColor(showPoisonControls ? .purple : .secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(.systemGray6))
                    .clipShape(Capsule())
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            
            Button(action: { onLifeChange(1) }) {
                VStack(spacing: 4) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 32))
                    Text("+1")
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.green.opacity(0.9))
            }
        }
        .frame(height: 160)
    }
    
    private var poisonCounterView: some View {
        HStack(spacing: 0) {
            Button(action: { onPoisonChange(-1) }) {
                Image(systemName: "minus.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.purple.opacity(0.3))
            }
            .disabled(player.poisonCounters == 0)
            
            VStack(spacing: 2) {
                Text("\(player.poisonCounters)")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(player.poisonCounters >= 10 ? .red : .purple)
                Text("counters")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            
            Button(action: { onPoisonChange(1) }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.purple.opacity(0.3))
            }
        }
        .background(Color(.systemGray6))
    }
    
    private var backgroundColor: Color {
        Color(.systemBackground)
    }
    
    private var headerColor: Color {
        player.hasLost ? Color.gray : Color.blue
    }
    
    private var lifeColor: Color {
        if player.life <= 0 {
            return .red
        } else if player.life <= 5 {
            return .orange
        } else {
            return .primary
        }
    }
}

#Preview {
    VStack(spacing: 8) {
        PlayerCardView(
            player: Player(name: "Player 1", life: 20),
            isRotated: true,
            onLifeChange: { _ in },
            onPoisonChange: { _ in },
            onNameEdit: {}
        )
        
        PlayerCardView(
            player: Player(name: "Player 2", life: 15, poisonCounters: 3),
            isRotated: false,
            onLifeChange: { _ in },
            onPoisonChange: { _ in },
            onNameEdit: {}
        )
    }
    .padding()
}
