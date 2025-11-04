//
//  GetNewSpoilersWithPricesUseCase.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 04/11/2025.
//

import Foundation

/// Use case to fetch the latest spoiled cards with their CardMarket prices
class GetNewSpoilersWithPricesUseCase {
    private let cardRepository: CardRepository
    private let cardMarketRepository: CardMarketRepository
    
    init(
        cardRepository: CardRepository,
        cardMarketRepository: CardMarketRepository
    ) {
        self.cardRepository = cardRepository
        self.cardMarketRepository = cardMarketRepository
    }
    
    /// Fetches the latest spoiled/newly released cards with their prices
    /// - Returns: Array of cards with their CardMarket prices
    func execute() async throws -> [CardWithPrice] {
        // Search for cards from recent sets using Scryfall's 'is:new' filter
        // This returns cards from the most recent set
        let cards = try await cardRepository.search(query: "is:new")
        
        // Take only the first 50 cards to avoid overwhelming the API
        let limitedCards = Array(cards.prefix(50))
        
        // Fetch prices for each card
        var cardsWithPrices: [CardWithPrice] = []
        
        for card in limitedCards {
            let price = try? await cardMarketRepository.getPrice(for: card.name)
            cardsWithPrices.append(CardWithPrice(card: card, price: price))
        }
        
        return cardsWithPrices
    }
}
