//
//  CardDetailViewModelTests.swift
//  MTG HelperTests
//
//  Created by Dan PEROCHEAU on 28/10/2025.
//

import XCTest
@testable import MTG_Helper

/// Tests unitaires pour CardDetailViewModel.
@MainActor
final class CardDetailViewModelTests: XCTestCase {
    private var viewModel: CardDetailViewModel!
    private var mockCardRepository: MockCardRepository!
    private var mockDeckRepository: MockDeckRepository!
    private var getCardDetailUseCase: GetCardDetailUseCase!
    private var addCardToDeckUseCase: AddCardToDeckUseCase!
    private var getDecksContainingCardUseCase: GetDecksContainingCardUseCase!
    
    override func setUp() async throws {
        mockCardRepository = MockCardRepository()
        mockDeckRepository = MockDeckRepository()
        
        getCardDetailUseCase = GetCardDetailUseCase(repository: mockCardRepository)
        addCardToDeckUseCase = AddCardToDeckUseCase(deckRepository: mockDeckRepository)
        getDecksContainingCardUseCase = GetDecksContainingCardUseCase(deckRepository: mockDeckRepository)
        
        viewModel = CardDetailViewModel(
            getCardDetail: getCardDetailUseCase,
            deckRepository: mockDeckRepository,
            addCardToDeck: addCardToDeckUseCase,
            getDecksContainingCard: getDecksContainingCardUseCase
        )
    }
    
    override func tearDown() async throws {
        viewModel = nil
        getCardDetailUseCase = nil
        addCardToDeckUseCase = nil
        getDecksContainingCardUseCase = nil
        mockCardRepository = nil
        mockDeckRepository = nil
    }
    
    // MARK: - Tests de chargement de carte
    
    func testLoadCard_WithValidId_ShouldSetCard() async {
        // Given
        let expectedCard = TestDataFactory.createCard()
        mockCardRepository.getCardResult = expectedCard
        
        // When
        await viewModel.load(id: expectedCard.id)
        
        // Then
        XCTAssertNotNil(viewModel.card, "Card should be set")
        XCTAssertEqual(viewModel.card?.id, expectedCard.id, "Card ID should match")
        XCTAssertEqual(viewModel.card?.name, expectedCard.name, "Card name should match")
        XCTAssertFalse(viewModel.isLoading, "Loading should be false after completion")
        XCTAssertNil(viewModel.error, "Error should be nil on success")
        XCTAssertEqual(mockCardRepository.getCardCallCount, 1, "getCard should be called once")
    }
    
    func testLoadCard_WithError_ShouldSetError() async {
        // Given
        let expectedError = NSError(
            domain: "TestError",
            code: 404,
            userInfo: [NSLocalizedDescriptionKey: "Card not found"]
        )
        mockCardRepository.getCardError = expectedError
        
        // When
        await viewModel.load(id: "invalid-id")
        
        // Then
        XCTAssertNil(viewModel.card, "Card should be nil on error")
        XCTAssertNotNil(viewModel.error, "Error should be set")
        XCTAssertFalse(viewModel.isLoading, "Loading should be false after error")
    }
    
    // MARK: - Tests de chargement des decks disponibles
    
    func testLoadAvailableDecks_ShouldPopulateDecks() async {
        // Given
        let expectedDecks = TestDataFactory.createDecks(count: 3)
        mockDeckRepository.getAllDecksResult = expectedDecks
        
        // When
        await viewModel.loadAvailableDecks()
        
        // Then
        XCTAssertEqual(viewModel.availableDecks.count, 3, "Should load 3 decks")
        XCTAssertEqual(viewModel.availableDecks, expectedDecks, "Decks should match")
        XCTAssertEqual(mockDeckRepository.getAllDecksCallCount, 1, "getAllDecks should be called once")
    }
    
    func testLoadAvailableDecks_WithError_ShouldSetError() async {
        // Given
        let expectedError = NSError(
            domain: "TestError",
            code: 500,
            userInfo: [NSLocalizedDescriptionKey: "Database error"]
        )
        mockDeckRepository.getAllDecksError = expectedError
        
        // When
        await viewModel.loadAvailableDecks()
        
        // Then
        XCTAssertTrue(viewModel.availableDecks.isEmpty, "Available decks should be empty on error")
        XCTAssertNotNil(viewModel.error, "Error should be set")
    }
    
    // MARK: - Tests de chargement des decks contenant la carte
    
    func testLoadDecksContainingCard_WithCardLoaded_ShouldPopulateDecks() async {
        // Given
        let card = TestDataFactory.createCard()
        let expectedDecks = TestDataFactory.createDecks(count: 2)
        mockCardRepository.getCardResult = card
        mockDeckRepository.getDecksContainingCardResult = expectedDecks
        
        await viewModel.load(id: card.id)
        
        // When
        await viewModel.loadDecksContainingCard()
        
        // Then
        XCTAssertEqual(viewModel.decksContainingCard.count, 2, "Should load 2 decks")
        XCTAssertEqual(viewModel.decksContainingCard, expectedDecks, "Decks should match")
        XCTAssertEqual(mockDeckRepository.getDecksContainingCardCallCount, 2, "Should be called during load and explicit call")
    }
    
    func testLoadDecksContainingCard_WithoutCard_ShouldNotCallRepository() async {
        // When
        await viewModel.loadDecksContainingCard()
        
        // Then
        XCTAssertEqual(mockDeckRepository.getDecksContainingCardCallCount, 0, "Should not call repository without card")
        XCTAssertTrue(viewModel.decksContainingCard.isEmpty, "Decks should be empty")
    }
    
    // MARK: - Tests d'ajout de carte à un deck
    
    func testAddToDeck_WithValidCard_ShouldAddAndRefresh() async {
        // Given
        let card = TestDataFactory.createCard()
        let deck = TestDataFactory.createDeck()
        mockCardRepository.getCardResult = card
        mockDeckRepository.getDecksContainingCardResult = [deck]
        
        await viewModel.load(id: card.id)
        
        // When
        await viewModel.addToDeck(deck)
        
        // Then
        XCTAssertEqual(mockDeckRepository.addCardCallCount, 1, "addCard should be called once")
        XCTAssertEqual(mockDeckRepository.lastAddedCard?.id, card.id, "Added card should match")
        XCTAssertEqual(mockDeckRepository.lastAddedToDeck?.name, deck.name, "Target deck should match")
        XCTAssertFalse(viewModel.showDeckPicker, "Deck picker should be hidden after adding")
        XCTAssertEqual(mockDeckRepository.getDecksContainingCardCallCount, 2, "Should refresh decks containing card")
    }
    
    func testAddToDeck_WithoutCard_ShouldNotAdd() async {
        // Given
        let deck = TestDataFactory.createDeck()
        
        // When
        await viewModel.addToDeck(deck)
        
        // Then
        XCTAssertEqual(mockDeckRepository.addCardCallCount, 0, "addCard should not be called without card")
    }
    
    func testAddToDeck_WithError_ShouldSetError() async {
        // Given
        let card = TestDataFactory.createCard()
        let deck = TestDataFactory.createDeck()
        let expectedError = NSError(
            domain: "TestError",
            code: 500,
            userInfo: [NSLocalizedDescriptionKey: "Failed to add card"]
        )
        mockCardRepository.getCardResult = card
        mockDeckRepository.addCardError = expectedError
        
        await viewModel.load(id: card.id)
        
        // When
        await viewModel.addToDeck(deck)
        
        // Then
        XCTAssertNotNil(viewModel.error, "Error should be set")
//        XCTAssertTrue(viewModel.showDeckPicker, "Deck picker should remain visible on error")
    }
    
    // MARK: - Tests de l'état initial
    
    func testInitialState_ShouldBeCorrect() {
        // Then
        XCTAssertNil(viewModel.card, "Card should be nil initially")
        XCTAssertFalse(viewModel.isLoading, "Loading should be false initially")
        XCTAssertNil(viewModel.error, "Error should be nil initially")
        XCTAssertTrue(viewModel.availableDecks.isEmpty, "Available decks should be empty initially")
        XCTAssertTrue(viewModel.decksContainingCard.isEmpty, "Decks containing card should be empty initially")
        XCTAssertFalse(viewModel.showDeckPicker, "Deck picker should be hidden initially")
    }
}
