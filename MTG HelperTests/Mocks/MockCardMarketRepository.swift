//
//  MockCardMarketRepository.swift
//  MTG HelperTests
//
//  Created by Dan PEROCHEAU on 04/11/2025.
//

import Foundation
@testable import MTG_Helper

/// Mock implementation of CardMarketRepository for testing
class MockCardMarketRepository: CardMarketRepository {
    var shouldThrowError = false
    var errorToThrow: Error = NSError(domain: "TestError", code: -1, userInfo: nil)
    var mockPrices: [CardMarketPrice] = []
    
    func searchProducts(query: String) async throws -> [CardMarketPrice] {
        if shouldThrowError {
            throw errorToThrow
        }
        return mockPrices.filter { price in
            price.cardName.lowercased().contains(query.lowercased())
        }
    }
    
    func getPrice(for cardName: String) async throws -> CardMarketPrice? {
        if shouldThrowError {
            throw errorToThrow
        }
        return mockPrices.first { $0.cardName == cardName }
    }
    
    func getPrices(for cardNames: [String]) async throws -> [CardMarketPrice] {
        if shouldThrowError {
            throw errorToThrow
        }
        return mockPrices.filter { price in
            cardNames.contains(price.cardName)
        }
    }
}
