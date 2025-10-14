//
//  SearchResultView.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 22/07/2025.
//

import SwiftUI

struct CardSearchView: View {
    @StateObject var viewModel: CardSearchViewModel
    
    var onClick: (String) -> Void

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Searching...")
            } else {
                List(viewModel.cards) { card in
                    Text(card.name)
                        .onTapGesture {
                            onClick(card.id)
                        }
                }
            }
        }
        .task {
            await viewModel.search(query: "dragon")
        }
    }
}

#Preview {
    CardSearchView(viewModel: CardSearchViewModel(searchCards: SearchCardsUseCase(repository: CardRepositoryImpl(api: ScryfallAPIClient()))), onClick: { query in
            return print(query)
    })
}
