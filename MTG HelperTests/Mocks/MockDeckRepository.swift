//
//  MockDeckRepository.swift
//  MTG HelperTests
//
//  Created by Dan PEROCHEAU on 28/10/2025.
//

import Foundation
@testable import MTG_Helper

/// Mock du DeckRepository pour les tests unitaires.
final class MockDeckRepository: DeckRepository {
    var getAllDecksResult: [Deck] = []
    var getAllDecksError: Error?
    var getAllDecksCallCount = 0
    
    var getCardsResult: [DeckCard] = []
    var getCardsError: Error?
    var getCardsCallCount = 0
    var lastGetCardsDeck: Deck?
    
    var addCardCallCount = 0
    var lastAddedCard: Card?
    var lastAddedToDeck: Deck?
    var addCardError: Error?
    
    var removeCardCallCount = 0
    var lastRemovedDeckCard: DeckCard?
    var lastRemovedFromDeck: Deck?
    var removeCardError: Error?
    
    var getDecksContainingCardResult: [Deck] = []
    var getDecksContainingCardError: Error?
    var getDecksContainingCardCallCount = 0
    var lastGetDecksContainingCardId: String?
    
    var updateDeckCallCount = 0
    var lastUpdatedDeck: Deck?
    var lastUpdatedName: String?
    var lastUpdatedFormat: DeckFormat?
    var updateDeckError: Error?
    
    func getAllDecks() async throws -> [Deck] {
        getAllDecksCallCount += 1
        
        if let error = getAllDecksError {
            throw error
        }
        
        return getAllDecksResult
    }
    
    func getCards(for deck: Deck) async throws -> [DeckCard] {
        getCardsCallCount += 1
        lastGetCardsDeck = deck
        
        if let error = getCardsError {
            throw error
        }
        
        return getCardsResult
    }
    
    func addCard(_ card: Card, to deck: Deck) async throws {
        addCardCallCount += 1
        lastAddedCard = card
        lastAddedToDeck = deck
        
        if let error = addCardError {
            throw error
        }
    }
    
    func removeCard(_ deckCard: DeckCard, from deck: Deck) async throws {
        removeCardCallCount += 1
        lastRemovedDeckCard = deckCard
        lastRemovedFromDeck = deck
        
        if let error = removeCardError {
            throw error
        }
    }
    
    func getDecksContaining(cardId: String) async throws -> [Deck] {
        getDecksContainingCardCallCount += 1
        lastGetDecksContainingCardId = cardId
        
        if let error = getDecksContainingCardError {
            throw error
        }
        
        return getDecksContainingCardResult
    }
    
    func updateDeck(_ deck: Deck, name: String, format: DeckFormat) async throws {
        updateDeckCallCount += 1
        lastUpdatedDeck = deck
        lastUpdatedName = name
        lastUpdatedFormat = format
        
        if let error = updateDeckError {
            throw error
        }
        
        deck.name = name
        deck.format = format
        deck.updatedAt = Date()
    }
}
