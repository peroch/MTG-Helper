//
//  SearchCardsWithPricesUseCase.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 04/11/2025.
//

import Foundation

/// Use case to search for cards and fetch their CardMarket prices
class SearchCardsWithPricesUseCase {
    private let cardRepository: CardRepository
    private let cardMarketRepository: CardMarketRepository
    
    init(
        cardRepository: CardRepository,
        cardMarketRepository: CardMarketRepository
    ) {
        self.cardRepository = cardRepository
        self.cardMarketRepository = cardMarketRepository
    }
    
    /// Searches for cards with their prices
    /// - Parameter query: Search term
    /// - Returns: Array of cards with their CardMarket prices
    func execute(query: String) async throws -> [CardWithPrice] {
        // Search for cards using Scryfall
        let cards = try await cardRepository.search(query: query)
        
        // Limit to 30 cards to avoid overwhelming the API
        let limitedCards = Array(cards.prefix(30))
        
        // Fetch prices for each card
        var cardsWithPrices: [CardWithPrice] = []
        
        for card in limitedCards {
            let price = try? await cardMarketRepository.getPrice(for: card.name)
            cardsWithPrices.append(CardWithPrice(card: card, price: price))
        }
        
        return cardsWithPrices
    }
}
