//
//  CardMarketCoordinator.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 04/11/2025.
//

import SwiftUI

/// Coordinator for the CardMarket feature
class CardMarketCoordinator: ObservableObject {
    private let cardRepository: CardRepository
    private let cardMarketRepository: CardMarketRepository
    
    init(
        cardRepository: CardRepository,
        cardMarketRepository: CardMarketRepository
    ) {
        self.cardRepository = cardRepository
        self.cardMarketRepository = cardMarketRepository
    }
    
    /// Creates the main CardMarket view
    /// - Returns: The CardMarket view
    @MainActor
    func makeView() -> some View {
        let spoilersViewModel = CardMarketSpoilersViewModel(
            getSpoilersUseCase: GetNewSpoilersWithPricesUseCase(
                cardRepository: cardRepository,
                cardMarketRepository: cardMarketRepository
            )
        )
        
        let searchViewModel = CardMarketSearchViewModel(
            searchCardsWithPricesUseCase: SearchCardsWithPricesUseCase(
                cardRepository: cardRepository,
                cardMarketRepository: cardMarketRepository
            )
        )
        
        return CardMarketView(
            spoilersViewModel: spoilersViewModel,
            searchViewModel: searchViewModel
        )
    }
}
