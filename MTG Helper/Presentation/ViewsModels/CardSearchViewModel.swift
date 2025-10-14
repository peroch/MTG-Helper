//
//  SearchResultViewModel.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 25/07/2025.
//

import SwiftUI

@MainActor
final class CardSearchViewModel: ObservableObject {
    @Published var cards: [Card] = []
    @Published var isLoading = false

    private let searchCards: SearchCardsUseCase

    init(searchCards: SearchCardsUseCase) {
        self.searchCards = searchCards
    }

    func search(query: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            cards = try await searchCards.execute(query: query)
        } catch {
            print("Error: \(error)")
        }
    }
}
