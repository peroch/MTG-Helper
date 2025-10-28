//
//  GetCardDetailUseCaseTests.swift
//  MTG HelperTests
//
//  Created by Dan PEROCHEAU on 28/10/2025.
//

import XCTest
@testable import MTG_Helper

/// Tests unitaires pour GetCardDetailUseCase.
final class GetCardDetailUseCaseTests: XCTestCase {
    private var useCase: GetCardDetailUseCase!
    private var mockRepository: MockCardRepository!
    
    override func setUp() {
        mockRepository = MockCardRepository()
        useCase = GetCardDetailUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        useCase = nil
        mockRepository = nil
    }
    
    // MARK: - Tests de récupération réussie
    
    func testExecute_WithValidId_ShouldReturnCard() async throws {
        // Given
        let expectedCard = TestDataFactory.createCard()
        mockRepository.getCardResult = expectedCard
        let cardId = expectedCard.id
        
        // When
        let result = try await useCase.execute(id: cardId)
        
        // Then
        XCTAssertEqual(result.id, expectedCard.id, "Card ID should match")
        XCTAssertEqual(result.name, expectedCard.name, "Card name should match")
        XCTAssertEqual(result.manaCost, expectedCard.manaCost, "Mana cost should match")
        XCTAssertEqual(mockRepository.getCardCallCount, 1, "Repository should be called once")
        XCTAssertEqual(mockRepository.lastGetCardId, cardId, "Card ID should be passed to repository")
    }
    
    func testExecute_MultipleRequests_ShouldReturnDifferentCards() async throws {
        // Given
        let cards = TestDataFactory.createCards(count: 3)
        
        // When/Then
        for card in cards {
            mockRepository.getCardResult = card
            let result = try await useCase.execute(id: card.id)
            XCTAssertEqual(result.id, card.id, "Each request should return the correct card")
        }
        
        XCTAssertEqual(mockRepository.getCardCallCount, 3, "Repository should be called three times")
    }
    
    // MARK: - Tests de gestion d'erreur
    
    func testExecute_WithInvalidId_ShouldThrowError() async {
        // Given
        let expectedError = NSError(
            domain: "TestError",
            code: 404,
            userInfo: [NSLocalizedDescriptionKey: "Card not found"]
        )
        mockRepository.getCardError = expectedError
        
        // When/Then
        do {
            _ = try await useCase.execute(id: "invalid-id")
            XCTFail("Should throw an error")
        } catch {
            XCTAssertEqual((error as NSError).code, expectedError.code, "Error code should match")
            XCTAssertEqual(mockRepository.getCardCallCount, 1, "Repository should be called")
        }
    }
    
    func testExecute_WithNetworkError_ShouldThrowError() async {
        // Given
        let expectedError = NSError(
            domain: "TestError",
            code: 500,
            userInfo: [NSLocalizedDescriptionKey: "Network error"]
        )
        mockRepository.getCardError = expectedError
        
        // When/Then
        do {
            _ = try await useCase.execute(id: "some-id")
            XCTFail("Should throw an error")
        } catch {
            XCTAssertEqual((error as NSError).code, expectedError.code, "Error code should match")
        }
    }
    
    // MARK: - Tests de délégation
    
    func testExecute_ShouldDelegateToRepository() async throws {
        // Given
        let card = TestDataFactory.createCard()
        mockRepository.getCardResult = card
        let testId = "test-card-id"
        
        // When
        _ = try await useCase.execute(id: testId)
        
        // Then
        XCTAssertEqual(mockRepository.getCardCallCount, 1, "Use case should delegate to repository")
        XCTAssertEqual(mockRepository.lastGetCardId, testId, "Card ID should be forwarded")
    }
}
