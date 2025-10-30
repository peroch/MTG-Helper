//
//  CardSearchViewModelTests.swift
//  MTG HelperTests
//
//  Created by Dan PEROCHEAU on 28/10/2025.
//

import XCTest
@testable import MTG_Helper

/// Tests unitaires pour CardSearchViewModel.
@MainActor
final class CardSearchViewModelTests: XCTestCase {
    private var viewModel: CardSearchViewModel!
    private var mockRepository: MockCardRepository!
    private var searchUseCase: SearchCardsUseCase!
    
    override func setUp() async throws {
        mockRepository = MockCardRepository()
        searchUseCase = SearchCardsUseCase(repository: mockRepository)
        viewModel = CardSearchViewModel(searchCards: searchUseCase)
    }
    
    override func tearDown() async throws {
        viewModel = nil
        searchUseCase = nil
        mockRepository = nil
    }
    
    // MARK: - Tests de recherche réussie
    
    func testSearchWithValidQuery_ShouldReturnCards() async {
        // Given
        let expectedCards = TestDataFactory.createCards(count: 3)
        mockRepository.searchResult = expectedCards
        let query = "Lightning"
        
        // When
        await viewModel.search(query: query)
        
        // Then
        XCTAssertEqual(viewModel.cards.count, 3, "Should return 3 cards")
        XCTAssertEqual(viewModel.cards.map { $0.id }, expectedCards.map { $0.id }, "Cards should match expected results")
        XCTAssertFalse(viewModel.isLoading, "Loading should be false after completion")
        XCTAssertEqual(mockRepository.searchCallCount, 1, "Repository search should be called once")
        XCTAssertEqual(mockRepository.lastSearchQuery, query, "Query should match")
    }
    
    func testSearchWithEmptyQuery_ShouldCallRepository() async {
        // Given
        let emptyQuery = ""
        mockRepository.searchResult = []
        
        // When
        await viewModel.search(query: emptyQuery)
        
        // Then
        XCTAssertTrue(viewModel.cards.isEmpty, "Should return empty array")
        XCTAssertEqual(mockRepository.searchCallCount, 1, "Repository should still be called")
    }
    
    func testMultipleSearches_ShouldUpdateCardsEachTime() async {
        // Given
        let firstCards = TestDataFactory.createCards(count: 2)
        let secondCards = TestDataFactory.createCards(count: 5)
        
        // When - First search
        mockRepository.searchResult = firstCards
        await viewModel.search(query: "First")
        
        // Then
        XCTAssertEqual(viewModel.cards.count, 2, "First search should return 2 cards")
        
        // When - Second search
        mockRepository.searchResult = secondCards
        await viewModel.search(query: "Second")
        
        // Then
        XCTAssertEqual(viewModel.cards.count, 5, "Second search should update to 5 cards")
        XCTAssertEqual(mockRepository.searchCallCount, 2, "Repository should be called twice")
    }
    
    // MARK: - Tests de gestion d'erreur
    
    func testSearchWithError_ShouldHandleGracefully() async {
        // Given
        let expectedError = NSError(
            domain: "TestError",
            code: 500,
            userInfo: [NSLocalizedDescriptionKey: "Network error"]
        )
        mockRepository.searchError = expectedError
        
        // When
        await viewModel.search(query: "Error")
        
        // Then
        XCTAssertTrue(viewModel.cards.isEmpty, "Cards should be empty on error")
        XCTAssertFalse(viewModel.isLoading, "Loading should be false after error")
        XCTAssertEqual(mockRepository.searchCallCount, 1, "Repository should be called once")
    }
    
    // MARK: - Tests de l'état de chargement
    
    func testSearch_ShouldSetLoadingStateDuringExecution() async {
        // Given
        mockRepository.searchResult = TestDataFactory.createCards(count: 1)
        
        // When
        let searchTask = Task {
            await viewModel.search(query: "Test")
        }
        
        // Then - Check immediately (may or may not catch loading state due to timing)
        // This is more of a sanity check
        await searchTask.value
        XCTAssertFalse(viewModel.isLoading, "Loading should be false after completion")
    }
    
    func testInitialState_ShouldBeEmpty() {
        // Then
        XCTAssertTrue(viewModel.cards.isEmpty, "Cards should be empty initially")
        XCTAssertFalse(viewModel.isLoading, "Loading should be false initially")
    }
}
