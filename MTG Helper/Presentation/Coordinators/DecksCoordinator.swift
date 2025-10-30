//
//  DecksCoordinator.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 15/09/2025.
//

import SwiftUI

final class DecksCoordinator: ObservableObject {
    private let cardRepository: CardRepository
    private let deckRepository: DeckRepository
    
    enum Destination: Hashable {
        case deckDetail(deck: Deck)
        case cardDetail(id: String)
        case deckSettings(deck: Deck)
    }
    
    init(cardRepository: CardRepository, deckRepository: DeckRepository) {
        self.cardRepository = cardRepository
        self.deckRepository = deckRepository
    }

    func makeView() -> some View {
        DecksCoordinatorView(
            cardRepository: cardRepository,
            deckRepository: deckRepository
        )
    }
}

struct DecksCoordinatorView: View {
    @State private var path = NavigationPath()
    private let cardRepository: CardRepository
    private let deckRepository: DeckRepository
    
    init(cardRepository: CardRepository, deckRepository: DeckRepository) {
        self.cardRepository = cardRepository
        self.deckRepository = deckRepository
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            DecksView()
                .navigationDestination(for: DecksCoordinator.Destination.self) { destination in
                    switch destination {
                    case .deckDetail(let deck):
                        let vm = DeckCardsViewModel(
                            deckRepository: deckRepository,
                            removeCardFromDeck: RemoveCardFromDeckUseCase(deckRepository: deckRepository)
                        )
                        DeckDetailView(
                            viewModel: vm,
                            deck: deck,
                            onNavigateToCard: { cardId in
                                path.append(DecksCoordinator.Destination.cardDetail(id: cardId))
                            },
                            onNavigateToSettings: {
                                path.append(DecksCoordinator.Destination.deckSettings(deck: deck))
                            }
                        )
                    case .cardDetail(let id):
                        let vm = CardDetailViewModel(
                            getCardDetail: GetCardDetailUseCase(repository: cardRepository),
                            deckRepository: deckRepository,
                            addCardToDeck: AddCardToDeckUseCase(deckRepository: deckRepository),
                            getDecksContainingCard: GetDecksContainingCardUseCase(deckRepository: deckRepository)
                        )
                        CardDetailView(viewModel: vm, cardId: id)
                    case .deckSettings(let deck):
                        let vm = DeckSettingsViewModel(
                            deck: deck,
                            updateDeckUseCase: UpdateDeckUseCase(repository: deckRepository)
                        )
                        DeckSettingsView(viewModel: vm)
                    }
                }
        }
    }
}
