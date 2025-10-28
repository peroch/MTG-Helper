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
                    HStack(spacing: 8) {
                        Text(card.name)
                            .font(.headline)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                        if let manaCost = card.manaCost, !manaCost.isEmpty {
                            ManaCostView(manaCost: manaCost, symbolSize: 16)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onClick(card.id)
                    }
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

#Preview {
    CardSearchView(
        viewModel: CardSearchViewModel(searchCards: SearchCardsUseCase(repository: CardRepositoryImpl(api: ScryfallAPIClient()))),
        onClick: { query in print(query) },
        initialQuery: "dragon"
    )
}
