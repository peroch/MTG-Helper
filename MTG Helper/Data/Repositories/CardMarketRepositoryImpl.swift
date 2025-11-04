//
//  CardMarketRepositoryImpl.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 04/11/2025.
//

import Foundation

/// Implementation of CardMarketRepository using CardMarketAPIClient
class CardMarketRepositoryImpl: CardMarketRepository {
    private let apiClient: CardMarketAPIClient
    
    init(apiClient: CardMarketAPIClient) {
        self.apiClient = apiClient
    }
    
    func searchProducts(query: String) async throws -> [CardMarketPrice] {
        let response = try await apiClient.searchProducts(query: query)
        return response.product.compactMap { mapToPrice($0) }
    }
    
    func getPrice(for cardName: String) async throws -> CardMarketPrice? {
        let results = try await searchProducts(query: cardName)
        return results.first { $0.cardName.lowercased() == cardName.lowercased() }
    }
    
    func getPrices(for cardNames: [String]) async throws -> [CardMarketPrice] {
        var prices: [CardMarketPrice] = []
        
        for cardName in cardNames {
            if let price = try await getPrice(for: cardName) {
                prices.append(price)
            }
        }
        
        return prices
    }
    
    // MARK: - Private Helpers
    
    private func mapToPrice(_ product: CardMarketProductDTO.ProductData) -> CardMarketPrice? {
        CardMarketPrice(
            cardName: product.name,
            cardId: String(product.idProduct),
            lowestPrice: product.priceGuide?.LOW,
            trendPrice: product.priceGuide?.TREND,
            averagePrice: product.priceGuide?.AVG,
            currency: "EUR"
        )
    }
}
