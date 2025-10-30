//
//  SearchCardsUseCaseTests.swift
//  MTG HelperTests
//
//  Created by Dan PEROCHEAU on 28/10/2025.
//

import XCTest
@testable import MTG_Helper

/// Tests unitaires pour SearchCardsUseCase.
final class SearchCardsUseCaseTests: XCTestCase {
    private var useCase: SearchCardsUseCase!
    private var mockRepository: MockCardRepository!
    
    override func setUp() {
        mockRepository = MockCardRepository()
        useCase = SearchCardsUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        useCase = nil
        mockRepository = nil
    }
    
    // MARK: - Tests de recherche réussie
    
    func testExecute_WithValidQuery_ShouldReturnCards() async throws {
        // Given
        let expectedCards = TestDataFactory.createCards(count: 3)
        mockRepository.searchResult = expectedCards
        let query = "Lightning Bolt"
        
        // When
        let result = try await useCase.execute(query: query)
        
        // Then
        XCTAssertEqual(result.count, 3, "Should return 3 cards")
        XCTAssertEqual(result.map { $0.id }, expectedCards.map { $0.id }, "Results should match expected cards")
        XCTAssertEqual(mockRepository.searchCallCount, 1, "Repository should be called once")
        XCTAssertEqual(mockRepository.lastSearchQuery, query, "Query should be passed to repository")
    }
    
    func testExecute_WithEmptyQuery_ShouldCallRepository() async throws {
        // Given
        mockRepository.searchResult = []
        let emptyQuery = ""
        
        // When
        let result = try await useCase.execute(query: emptyQuery)
        
        // Then
        XCTAssertTrue(result.isEmpty, "Should return empty array")
        XCTAssertEqual(mockRepository.searchCallCount, 1, "Repository should be called")
    }
    
    // MARK: - Tests de gestion d'erreur
    
    func testExecute_WithRepositoryError_ShouldThrowError() async {
        // Given
        let expectedError = NSError(
            domain: "TestError",
            code: 500,
            userInfo: [NSLocalizedDescriptionKey: "Network error"]
        )
        mockRepository.searchError = expectedError
        
        // When/Then
        do {
            _ = try await useCase.execute(query: "Test")
            XCTFail("Should throw an error")
        } catch {
            XCTAssertEqual((error as NSError).code, expectedError.code, "Error code should match")
            XCTAssertEqual(mockRepository.searchCallCount, 1, "Repository should be called")
        }
    }
    
    // MARK: - Tests de délégation
    
    func testExecute_ShouldDelegateToRepository() async throws {
        // Given
        let cards = TestDataFactory.createCards(count: 5)
        mockRepository.searchResult = cards
        
        // When
        _ = try await useCase.execute(query: "Test Query")
        
        // Then
        XCTAssertEqual(mockRepository.searchCallCount, 1, "Use case should delegate to repository")
        XCTAssertEqual(mockRepository.lastSearchQuery, "Test Query", "Query should be forwarded")
    }
}
