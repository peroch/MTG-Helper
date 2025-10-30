//
//  DeckDetailView.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 15/09/2025.
//

import SwiftUI

struct DeckDetailView: View {
    @StateObject private var viewModel: DeckCardsViewModel
    let deck: Deck
    let onNavigateToCard: (String) -> Void
    
    init(
        viewModel: DeckCardsViewModel,
        deck: Deck,
        onNavigateToCard: @escaping (String) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.deck = deck
        self.onNavigateToCard = onNavigateToCard
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading cards...")
            } else if viewModel.cards.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "rectangle.stack.badge.plus")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    Text("No cards in this deck")
                        .font(.headline)
                    Text("Add cards from the search view")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } else {
                List {
                    ForEach(viewModel.groupedCards, id: \.type) { group in
                        Section {
                            ForEach(group.cards) { deckCard in
                                Button(action: {
                                    onNavigateToCard(deckCard.cardId)
                                }) {
                                    if viewModel.displayMode == .detailed {
                                        DeckCardRow(deckCard: deckCard)
                                    } else {
                                        DeckCardCompactRow(deckCard: deckCard)
                                    }
                                }
                            }
                            .onDelete { indexSet in
                                Task {
                                    for index in indexSet {
                                        let deckCard = group.cards[index]
                                        await viewModel.removeCard(deckCard, from: deck)
                                    }
                                }
                            }
                        } header: {
                            HStack {
                                Text(group.type)
                                    .font(.headline)
                                Spacer()
                                Text("\(group.cards.count) card(s)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(deck.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.displayMode = viewModel.displayMode == .detailed ? .compact : .detailed
                }) {
                    Image(systemName: viewModel.displayMode == .detailed ? "list.bullet" : "list.bullet.rectangle")
                }
            }
        }
        .task {
            await viewModel.loadCards(for: deck)
        }
        .alert("Error", isPresented: .constant(viewModel.error != nil)) {
            Button("OK") {
                
            }
        } message: {
            if let error = viewModel.error {
                Text(error)
            }
        }
    }
}

struct DeckCardRow: View {
    let deckCard: DeckCard
    
    var body: some View {
        HStack(spacing: 12) {
            if let imageUrlString = deckCard.cardImageUrl,
               let imageUrl = URL(string: imageUrlString) {
                AsyncImage(url: imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 60, height: 84)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 84)
                            .cornerRadius(6)
                            .clipped()
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 60, height: 84)
                            .cornerRadius(6)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 60, height: 84)
                    .cornerRadius(6)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(deckCard.cardName)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if let manaCost = deckCard.cardManaCost, !manaCost.isEmpty {
                    ManaCostView(manaCost: manaCost, symbolSize: 14)
                }
                
                Text("Added \(formatDate(deckCard.addedAt))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct DeckCardCompactRow: View {
    let deckCard: DeckCard
    
    var body: some View {
        HStack(spacing: 8) {
            Text(deckCard.cardName)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            if let manaCost = deckCard.cardManaCost, !manaCost.isEmpty {
                ManaCostView(manaCost: manaCost, symbolSize: 16)
            }
        }
        .padding(.vertical, 6)
    }
}
