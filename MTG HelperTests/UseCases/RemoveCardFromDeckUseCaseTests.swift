//
//  RemoveCardFromDeckUseCaseTests.swift
//  MTG HelperTests
//
//  Created by Dan PEROCHEAU on 28/10/2025.
//

import XCTest
@testable import MTG_Helper

/// Tests unitaires pour RemoveCardFromDeckUseCase.
final class RemoveCardFromDeckUseCaseTests: XCTestCase {
    private var useCase: RemoveCardFromDeckUseCase!
    private var mockRepository: MockDeckRepository!
    
    override func setUp() {
        mockRepository = MockDeckRepository()
        useCase = RemoveCardFromDeckUseCase(deckRepository: mockRepository)
    }
    
    override func tearDown() {
        useCase = nil
        mockRepository = nil
    }
    
    // MARK: - Tests de suppression réussie
    
    func testExecute_WithValidDeckCard_ShouldRemoveCard() async throws {
        // Given
        let deckCard = TestDataFactory.createDeckCard()
        let deck = TestDataFactory.createDeck()
        
        // When
        try await useCase.execute(deckCard: deckCard, from: deck)
        
        // Then
        XCTAssertEqual(mockRepository.removeCardCallCount, 1, "removeCard should be called once")
        XCTAssertEqual(mockRepository.lastRemovedDeckCard?.cardId, deckCard.cardId, "Removed card should match")
        XCTAssertEqual(mockRepository.lastRemovedDeckCard?.cardName, deckCard.cardName, "Card name should match")
        XCTAssertEqual(mockRepository.lastRemovedFromDeck?.name, deck.name, "Deck should match")
    }
    
    func testExecute_MultipleCards_ShouldRemoveAllCards() async throws {
        // Given
        let deckCards = [
            TestDataFactory.createDeckCard(),
            TestDataFactory.createDeckCard(),
            TestDataFactory.createDeckCard()
        ]
        let deck = TestDataFactory.createDeck()
        
        // When
        for deckCard in deckCards {
            try await useCase.execute(deckCard: deckCard, from: deck)
        }
        
        // Then
        XCTAssertEqual(mockRepository.removeCardCallCount, 3, "removeCard should be called three times")
        XCTAssertEqual(mockRepository.lastRemovedDeckCard?.cardId, deckCards[2].cardId, "Last removed card should be the third one")
    }
    
    // MARK: - Tests de gestion d'erreur
    
    func testExecute_WithRepositoryError_ShouldThrowError() async {
        // Given
        let deckCard = TestDataFactory.createDeckCard()
        let deck = TestDataFactory.createDeck()
        let expectedError = NSError(
            domain: "TestError",
            code: 500,
            userInfo: [NSLocalizedDescriptionKey: "Failed to remove card"]
        )
        mockRepository.removeCardError = expectedError
        
        // When/Then
        do {
            try await useCase.execute(deckCard: deckCard, from: deck)
            XCTFail("Should throw an error")
        } catch {
            XCTAssertEqual((error as NSError).code, expectedError.code, "Error code should match")
            XCTAssertEqual(mockRepository.removeCardCallCount, 1, "Repository should be called")
        }
    }
    
    // MARK: - Tests de délégation
    
    func testExecute_ShouldDelegateToRepository() async throws {
        // Given
        let deckCard = TestDataFactory.createDeckCard()
        let deck = TestDataFactory.createDeck()
        
        // When
        try await useCase.execute(deckCard: deckCard, from: deck)
        
        // Then
        XCTAssertEqual(mockRepository.removeCardCallCount, 1, "Use case should delegate to repository")
        XCTAssertNotNil(mockRepository.lastRemovedDeckCard, "DeckCard should be passed to repository")
        XCTAssertNotNil(mockRepository.lastRemovedFromDeck, "Deck should be passed to repository")
    }
}
