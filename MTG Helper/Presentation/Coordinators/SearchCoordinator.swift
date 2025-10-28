//
//  SearchCoordinator.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 15/09/2025.
//

import SwiftUI

final class SearchCoordinator: ObservableObject {
    private let cardRepository: CardRepository
    private let deckRepository: DeckRepository
    
    enum Destination: Hashable {
        case cardSearch(query: String)
        case cardDetail(id: String)
    }
    
    init(cardRepository: CardRepository, deckRepository: DeckRepository) {
        self.cardRepository = cardRepository
        self.deckRepository = deckRepository
    }
    
    func makeView() -> some View {
        SearchCoordinatorView(
            cardRepository: cardRepository,
            deckRepository: deckRepository
        )
    }
}

struct SearchCoordinatorView: View {
    @State private var path = NavigationPath()
    private let cardRepository: CardRepository
    private let deckRepository: DeckRepository
    
    init(cardRepository: CardRepository, deckRepository: DeckRepository) {
        self.cardRepository = cardRepository
        self.deckRepository = deckRepository
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            SearchAndFilterView(onSearch: { searchEntry in
                path.append(SearchCoordinator.Destination.cardSearch(query: searchEntry))
            })
            .navigationDestination(for: SearchCoordinator.Destination.self) { destination in
                switch destination {
                case .cardSearch(let query):
                    let vm = CardSearchViewModel(searchCards: SearchCardsUseCase(repository: cardRepository))
                    CardSearchView(viewModel: vm, onClick: { id in
                        path.append(SearchCoordinator.Destination.cardDetail(id: id))
                    }, initialQuery: query)
                case .cardDetail(let id):
                    let vm = CardDetailViewModel(
                        getCardDetail: GetCardDetailUseCase(repository: cardRepository),
                        deckRepository: deckRepository,
                        addCardToDeck: AddCardToDeckUseCase(deckRepository: deckRepository),
                        getDecksContainingCard: GetDecksContainingCardUseCase(deckRepository: deckRepository)
                    )
                    CardDetailView(viewModel: vm, cardId: id)
                }
            }
        }
    }
    
    }
