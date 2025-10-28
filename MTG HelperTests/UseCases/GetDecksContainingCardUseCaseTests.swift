//
//  GetDecksContainingCardUseCaseTests.swift
//  MTG HelperTests
//
//  Created by Dan PEROCHEAU on 28/10/2025.
//

import XCTest
@testable import MTG_Helper

/// Tests unitaires pour GetDecksContainingCardUseCase.
final class GetDecksContainingCardUseCaseTests: XCTestCase {
    private var useCase: GetDecksContainingCardUseCase!
    private var mockRepository: MockDeckRepository!
    
    override func setUp() {
        mockRepository = MockDeckRepository()
        useCase = GetDecksContainingCardUseCase(deckRepository: mockRepository)
    }
    
    override func tearDown() {
        useCase = nil
        mockRepository = nil
    }
    
    // MARK: - Tests de récupération réussie
    
    func testExecute_WithCardInMultipleDecks_ShouldReturnAllDecks() async throws {
        // Given
        let expectedDecks = TestDataFactory.createDecks(count: 3)
        mockRepository.getDecksContainingCardResult = expectedDecks
        let cardId = "test-card-1"
        
        // When
        let result = try await useCase.execute(cardId: cardId)
        
        // Then
        XCTAssertEqual(result.count, 3, "Should return 3 decks")
        XCTAssertEqual(result, expectedDecks, "Decks should match expected")
        XCTAssertEqual(mockRepository.getDecksContainingCardCallCount, 1, "Repository should be called once")
        XCTAssertEqual(mockRepository.lastGetDecksContainingCardId, cardId, "Card ID should be passed to repository")
    }
    
    func testExecute_WithCardInNoDeck_ShouldReturnEmptyArray() async throws {
        // Given
        mockRepository.getDecksContainingCardResult = []
        let cardId = "unused-card"
        
        // When
        let result = try await useCase.execute(cardId: cardId)
        
        // Then
        XCTAssertTrue(result.isEmpty, "Should return empty array")
        XCTAssertEqual(mockRepository.getDecksContainingCardCallCount, 1, "Repository should be called")
    }
    
    func testExecute_WithCardInSingleDeck_ShouldReturnOneDeck() async throws {
        // Given
        let singleDeck = [TestDataFactory.createDeck()]
        mockRepository.getDecksContainingCardResult = singleDeck
        let cardId = "single-deck-card"
        
        // When
        let result = try await useCase.execute(cardId: cardId)
        
        // Then
        XCTAssertEqual(result.count, 1, "Should return 1 deck")
        XCTAssertEqual(result.first?.name, singleDeck.first?.name, "Deck name should match")
    }
    
    // MARK: - Tests de gestion d'erreur
    
    func testExecute_WithRepositoryError_ShouldThrowError() async {
        // Given
        let expectedError = NSError(
            domain: "TestError",
            code: 500,
            userInfo: [NSLocalizedDescriptionKey: "Database error"]
        )
        mockRepository.getDecksContainingCardError = expectedError
        
        // When/Then
        do {
            _ = try await useCase.execute(cardId: "test-card")
            XCTFail("Should throw an error")
        } catch {
            XCTAssertEqual((error as NSError).code, expectedError.code, "Error code should match")
            XCTAssertEqual(mockRepository.getDecksContainingCardCallCount, 1, "Repository should be called")
        }
    }
    
    // MARK: - Tests de délégation
    
    func testExecute_ShouldDelegateToRepository() async throws {
        // Given
        let decks = TestDataFactory.createDecks(count: 2)
        mockRepository.getDecksContainingCardResult = decks
        let testCardId = "delegation-test-card"
        
        // When
        _ = try await useCase.execute(cardId: testCardId)
        
        // Then
        XCTAssertEqual(mockRepository.getDecksContainingCardCallCount, 1, "Use case should delegate to repository")
        XCTAssertEqual(mockRepository.lastGetDecksContainingCardId, testCardId, "Card ID should be forwarded")
    }
    
    // MARK: - Tests de requêtes multiples
    
    func testExecute_MultipleRequests_ShouldHandleCorrectly() async throws {
        // Given
        let card1Decks = TestDataFactory.createDecks(count: 2)
        let card2Decks = TestDataFactory.createDecks(count: 1)
        
        // When - First request
        mockRepository.getDecksContainingCardResult = card1Decks
        let result1 = try await useCase.execute(cardId: "card-1")
        
        // Then
        XCTAssertEqual(result1.count, 2, "First request should return 2 decks")
        
        // When - Second request
        mockRepository.getDecksContainingCardResult = card2Decks
        let result2 = try await useCase.execute(cardId: "card-2")
        
        // Then
        XCTAssertEqual(result2.count, 1, "Second request should return 1 deck")
        XCTAssertEqual(mockRepository.getDecksContainingCardCallCount, 2, "Repository should be called twice")
    }
}
