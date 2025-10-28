//
//  AppCoordinator.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 22/07/2025.
//

import SwiftUI

final class AppCoordinator: ObservableObject {
    enum CurrentView {
        case searchEntry
        case cardSearch(query: String)
        case cardDetail(id: String)
    }

    @Published var currentView: CurrentView = .searchEntry
    let cardRepository: CardRepository
    let deckRepository: DeckRepository

    init(cardRepository: CardRepository, deckRepository: DeckRepository) {
        self.cardRepository = cardRepository
        self.deckRepository = deckRepository
    }

    func start() -> some View {
        CoordinatorRootView()
    }

    func showCardSearch(query: String) {
        currentView = .cardSearch(query: query)
    }

    func showCardDetail(id: String) {
        currentView = .cardDetail(id: id)
    }

    func backToSearch() {
        currentView = .searchEntry
    }
}
