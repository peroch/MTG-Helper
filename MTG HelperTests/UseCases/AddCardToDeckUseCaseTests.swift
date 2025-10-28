//
//  AddCardToDeckUseCaseTests.swift
//  MTG HelperTests
//
//  Created by Dan PEROCHEAU on 28/10/2025.
//

import XCTest
@testable import MTG_Helper

/// Tests unitaires pour AddCardToDeckUseCase.
final class AddCardToDeckUseCaseTests: XCTestCase {
    private var useCase: AddCardToDeckUseCase!
    private var mockRepository: MockDeckRepository!
    
    override func setUp() {
        mockRepository = MockDeckRepository()
        useCase = AddCardToDeckUseCase(deckRepository: mockRepository)
    }
    
    override func tearDown() {
        useCase = nil
        mockRepository = nil
    }
    
    // MARK: - Tests d'ajout réussi
    
    func testExecute_WithValidCardAndDeck_ShouldAddCard() async throws {
        // Given
        let card = TestDataFactory.createCard()
        let deck = TestDataFactory.createDeck()
        
        // When
        try await useCase.execute(card: card, to: deck)
        
        // Then
        XCTAssertEqual(mockRepository.addCardCallCount, 1, "addCard should be called once")
        XCTAssertEqual(mockRepository.lastAddedCard?.id, card.id, "Added card should match")
        XCTAssertEqual(mockRepository.lastAddedCard?.name, card.name, "Card name should match")
        XCTAssertEqual(mockRepository.lastAddedToDeck?.name, deck.name, "Deck should match")
    }
    
    func testExecute_MultipleCards_ShouldAddAllCards() async throws {
        // Given
        let cards = TestDataFactory.createCards(count: 3)
        let deck = TestDataFactory.createDeck()
        
        // When
        for card in cards {
            try await useCase.execute(card: card, to: deck)
        }
        
        // Then
        XCTAssertEqual(mockRepository.addCardCallCount, 3, "addCard should be called three times")
        XCTAssertEqual(mockRepository.lastAddedCard?.id, cards[2].id, "Last added card should be the third one")
    }
    
    // MARK: - Tests de gestion d'erreur
    
    func testExecute_WithRepositoryError_ShouldThrowError() async {
        // Given
        let card = TestDataFactory.createCard()
        let deck = TestDataFactory.createDeck()
        let expectedError = NSError(
            domain: "TestError",
            code: 500,
            userInfo: [NSLocalizedDescriptionKey: "Failed to add card"]
        )
        mockRepository.addCardError = expectedError
        
        // When/Then
        do {
            try await useCase.execute(card: card, to: deck)
            XCTFail("Should throw an error")
        } catch {
            XCTAssertEqual((error as NSError).code, expectedError.code, "Error code should match")
            XCTAssertEqual(mockRepository.addCardCallCount, 1, "Repository should be called")
        }
    }
    
    // MARK: - Tests de délégation
    
    func testExecute_ShouldDelegateToRepository() async throws {
        // Given
        let card = TestDataFactory.createCard()
        let deck = TestDataFactory.createDeck()
        
        // When
        try await useCase.execute(card: card, to: deck)
        
        // Then
        XCTAssertEqual(mockRepository.addCardCallCount, 1, "Use case should delegate to repository")
        XCTAssertNotNil(mockRepository.lastAddedCard, "Card should be passed to repository")
        XCTAssertNotNil(mockRepository.lastAddedToDeck, "Deck should be passed to repository")
    }
}
