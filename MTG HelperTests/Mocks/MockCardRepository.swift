//
//  MockCardRepository.swift
//  MTG HelperTests
//
//  Created by Dan PEROCHEAU on 28/10/2025.
//

import Foundation
@testable import MTG_Helper

/// Mock du CardRepository pour les tests unitaires.
final class MockCardRepository: CardRepository {
    var searchResult: [Card] = []
    var searchError: Error?
    var searchCallCount = 0
    var lastSearchQuery: String?
    
    var getCardResult: Card?
    var getCardError: Error?
    var getCardCallCount = 0
    var lastGetCardId: String?
    
    func search(query: String) async throws -> [Card] {
        searchCallCount += 1
        lastSearchQuery = query
        
        if let error = searchError {
            throw error
        }
        
        return searchResult
    }
    
    func getCard(id: String) async throws -> Card {
        getCardCallCount += 1
        lastGetCardId = id
        
        if let error = getCardError {
            throw error
        }
        
        guard let card = getCardResult else {
            throw NSError(domain: "MockCardRepository", code: 404, userInfo: [NSLocalizedDescriptionKey: "Card not found"])
        }
        
        return card
    }
}
