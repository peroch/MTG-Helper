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
    
    var body: some View {
        List {
            ForEach(decks) { deck in
                NavigationLink(value: DecksCoordinator.Destination.deckDetail(deck: deck)) {
                    DeckRow(deck: deck)
                }
            }
            .onDelete(perform: deleteDecks)
        }
        .navigationTitle("Decks")
        .toolbar {
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
    
    private func deleteDecks(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(decks[index])
        }
    }
}

struct DeckRow: View {
    let deck: Deck
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(deck.name)
                .font(.headline)
            
            Text(deck.format.displayName)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    DecksView()
}
