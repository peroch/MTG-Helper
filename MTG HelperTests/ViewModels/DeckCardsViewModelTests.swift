//
//  DeckCardsViewModelTests.swift
//  MTG HelperTests
//
//  Created by Dan PEROCHEAU on 28/10/2025.
//

import XCTest
@testable import MTG_Helper

/// Tests unitaires pour DeckCardsViewModel.
@MainActor
final class DeckCardsViewModelTests: XCTestCase {
    private var viewModel: DeckCardsViewModel!
    private var mockDeckRepository: MockDeckRepository!
    private var removeCardFromDeckUseCase: RemoveCardFromDeckUseCase!
    
    override func setUp() async throws {
        mockDeckRepository = MockDeckRepository()
        removeCardFromDeckUseCase = RemoveCardFromDeckUseCase(deckRepository: mockDeckRepository)
        viewModel = DeckCardsViewModel(
            deckRepository: mockDeckRepository,
            removeCardFromDeck: removeCardFromDeckUseCase
        )
    }
    
    override func tearDown() async throws {
        viewModel = nil
        removeCardFromDeckUseCase = nil
        mockDeckRepository = nil
    }
    
    // MARK: - Tests de chargement de cartes
    
    func testLoadCards_WithValidDeck_ShouldPopulateCards() async {
        // Given
        let deck = TestDataFactory.createDeck()
        let expectedCards = [
            TestDataFactory.createDeckCard(quantity: 2),
            TestDataFactory.createDeckCard(quantity: 4)
        ]
        mockDeckRepository.getCardsResult = expectedCards
        
        // When
        await viewModel.loadCards(for: deck)
        
        // Then
        XCTAssertEqual(viewModel.cards.count, 2, "Should load 2 cards")
        XCTAssertEqual(viewModel.cards, expectedCards, "Cards should match expected")
        XCTAssertFalse(viewModel.isLoading, "Loading should be false after completion")
        XCTAssertNil(viewModel.error, "Error should be nil on success")
        XCTAssertEqual(mockDeckRepository.getCardsCallCount, 1, "getCards should be called once")
    }
    
    func testLoadCards_WithEmptyDeck_ShouldReturnEmptyArray() async {
        // Given
        let deck = TestDataFactory.createDeck()
        mockDeckRepository.getCardsResult = []
        
        // When
        await viewModel.loadCards(for: deck)
        
        // Then
        XCTAssertTrue(viewModel.cards.isEmpty, "Cards should be empty")
        XCTAssertFalse(viewModel.isLoading, "Loading should be false")
        XCTAssertNil(viewModel.error, "Error should be nil")
    }
    
    func testLoadCards_WithError_ShouldSetError() async {
        // Given
        let deck = TestDataFactory.createDeck()
        let expectedError = NSError(
            domain: "TestError",
            code: 500,
            userInfo: [NSLocalizedDescriptionKey: "Database error"]
        )
        mockDeckRepository.getCardsError = expectedError
        
        // When
        await viewModel.loadCards(for: deck)
        
        // Then
        XCTAssertTrue(viewModel.cards.isEmpty, "Cards should be empty on error")
        XCTAssertNotNil(viewModel.error, "Error should be set")
        XCTAssertFalse(viewModel.isLoading, "Loading should be false after error")
    }
    
    // MARK: - Tests de suppression de carte
    
    func testRemoveCard_WithValidCard_ShouldRemoveAndRefresh() async {
        // Given
        let deck = TestDataFactory.createDeck()
        let deckCard = TestDataFactory.createDeckCard()
        let initialCards = [deckCard, TestDataFactory.createDeckCard()]
        let cardsAfterRemoval = [TestDataFactory.createDeckCard()]
        
        mockDeckRepository.getCardsResult = initialCards
        await viewModel.loadCards(for: deck)
        
        mockDeckRepository.getCardsResult = cardsAfterRemoval
        
        // When
        await viewModel.removeCard(deckCard, from: deck)
        
        // Then
        XCTAssertEqual(mockDeckRepository.removeCardCallCount, 1, "removeCard should be called once")
        XCTAssertEqual(mockDeckRepository.lastRemovedDeckCard?.cardId, deckCard.cardId, "Removed card should match")
        XCTAssertEqual(mockDeckRepository.lastRemovedFromDeck?.name, deck.name, "Deck should match")
        XCTAssertEqual(viewModel.cards.count, 1, "Cards should be refreshed after removal")
        XCTAssertEqual(mockDeckRepository.getCardsCallCount, 2, "getCards should be called twice (load + refresh)")
    }
    
    func testRemoveCard_WithError_ShouldSetError() async {
        // Given
        let deck = TestDataFactory.createDeck()
        let deckCard = TestDataFactory.createDeckCard()
        let expectedError = NSError(
            domain: "TestError",
            code: 500,
            userInfo: [NSLocalizedDescriptionKey: "Failed to remove card"]
        )
        mockDeckRepository.removeCardError = expectedError
        
        // When
        await viewModel.removeCard(deckCard, from: deck)
        
        // Then
        XCTAssertNotNil(viewModel.error, "Error should be set")
        XCTAssertEqual(mockDeckRepository.removeCardCallCount, 1, "removeCard should be called")
    }
    
    // MARK: - Tests du mode d'affichage
    
    func testDisplayMode_DefaultValue_ShouldBeDetailed() {
        // Then
        XCTAssertEqual(viewModel.displayMode, .detailed, "Default display mode should be detailed")
    }
    
    func testDisplayMode_CanBeChanged() {
        // When
        viewModel.displayMode = .compact
        
        // Then
        XCTAssertEqual(viewModel.displayMode, .compact, "Display mode should be updated to compact")
        
        // When
        viewModel.displayMode = .detailed
        
        // Then
        XCTAssertEqual(viewModel.displayMode, .detailed, "Display mode should be updated back to detailed")
    }
    
    // MARK: - Tests de l'état initial
    
    func testInitialState_ShouldBeCorrect() {
        // Then
        XCTAssertTrue(viewModel.cards.isEmpty, "Cards should be empty initially")
        XCTAssertFalse(viewModel.isLoading, "Loading should be false initially")
        XCTAssertNil(viewModel.error, "Error should be nil initially")
        XCTAssertEqual(viewModel.displayMode, .detailed, "Display mode should be detailed initially")
    }
}
