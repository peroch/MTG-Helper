//
//  DecksView.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 22/07/2025.
//

import SwiftUI
import SwiftData

struct DecksView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Deck.updatedAt, order: .reverse) private var decks: [Deck]
    
    @State private var showingAddDeck = false
    @State private var displayMode: DeckListDisplayMode
    
    init() {
        _displayMode = State(initialValue: UserPreferencesService.shared.deckListDisplayMode)
    }
    
    var body: some View {
        Group {
            switch displayMode {
            case .list:
                listView
            case .grid:
                gridView
            }
        }
        .navigationTitle("Decks")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: toggleDisplayMode) {
                    Image(systemName: displayMode == .list ? "square.grid.2x2" : "list.bullet")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddDeck = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddDeck) {
            DeckFormView()
        }
        .overlay {
            if decks.isEmpty {
                ContentUnavailableView(
                    "Aucun deck",
                    systemImage: "star.slash",
                    description: Text("Appuyez sur + pour créer votre premier deck")
                )
            }
        }
    }
    
    // MARK: - List View
    
    private var listView: some View {
        List {
            ForEach(decks) { deck in
                NavigationLink(value: DecksCoordinator.Destination.deckDetail(deck: deck)) {
                    DeckRow(deck: deck)
                }
            }
            .onDelete(perform: deleteDecks)
        }
    }
    
    // MARK: - Grid View
    
    private var gridView: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(decks) { deck in
                    NavigationLink(value: DecksCoordinator.Destination.deckDetail(deck: deck)) {
                        DeckGridCard(deck: deck)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
    
    // MARK: - Actions
    
    private func deleteDecks(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(decks[index])
        }
    }
    
    private func toggleDisplayMode() {
        displayMode = displayMode == .list ? .grid : .list
        UserPreferencesService.shared.deckListDisplayMode = displayMode
    }
}

// MARK: - Deck Row (List Mode)

struct DeckRow: View {
    let deck: Deck
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(deck.name)
                .font(.headline)
            
            HStack {
                Text(deck.format.displayName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(deck.cards.count) cards")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Deck Grid Card (Grid Mode)

struct DeckGridCard: View {
    let deck: Deck
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header avec icône du format
            HStack {
                Image(systemName: "square.stack.3d.up")
                    .font(.title2)
                    .foregroundColor(.accentColor)
                
                Spacer()
            }
            
            Spacer()
            
            // Nom du deck
            Text(deck.name)
                .font(.headline)
                .lineLimit(2)
                .foregroundColor(.primary)
            
            // Format et nombre de cartes
            HStack {
                Text(deck.format.displayName)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(deck.cards.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(height: 150)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    DecksView()
}
