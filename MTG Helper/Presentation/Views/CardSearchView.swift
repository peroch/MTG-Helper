//
//  CardSearchView.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 22/07/2025.
//

import SwiftUI

/// Vue affichant les résultats de recherche de cartes.
/// Présente une liste de cartes avec leur nom et coût en mana.
struct CardSearchView: View {
    @StateObject var viewModel: CardSearchViewModel
    
    var onClick: (String) -> Void
    var initialQuery: String? = nil

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Searching...")
            } else {
                List(viewModel.cards) { card in
                    Button(action: {
                        onClick(card.id)
                    }) {
                        if viewModel.displayMode == .detailed {
                            SearchCardDetailedRow(card: card)
                        } else {
                            SearchCardCompactRow(card: card)
                        }
                    }
                }
            }
        }
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
            if let q = initialQuery, !q.isEmpty {
                await viewModel.search(query: q)
            }
        }
    }
}

// MARK: - Search Card Detailed Row

struct SearchCardDetailedRow: View {
    let card: Card
    
    var body: some View {
        HStack(spacing: 12) {
            if let imageUrlString = card.imageUrl,
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
                Text(card.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if let manaCost = card.manaCost, !manaCost.isEmpty {
                    ManaCostView(manaCost: manaCost, symbolSize: 14)
                }
                
                if let typeLine = card.typeLine {
                    Text(typeLine)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Search Card Compact Row

struct SearchCardCompactRow: View {
    let card: Card
    
    var body: some View {
        HStack(spacing: 8) {
            Text(card.name)
                .font(.body)
                .foregroundColor(.primary)
                .lineLimit(1)
                .truncationMode(.tail)
            
            Spacer()
            
            if let manaCost = card.manaCost, !manaCost.isEmpty {
                ManaCostView(manaCost: manaCost, symbolSize: 16)
            }
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    CardSearchView(
        viewModel: CardSearchViewModel(searchCards: SearchCardsUseCase(repository: CardRepositoryImpl(api: ScryfallAPIClient()))),
        onClick: { query in print(query) },
        initialQuery: "dragon"
    )
}
