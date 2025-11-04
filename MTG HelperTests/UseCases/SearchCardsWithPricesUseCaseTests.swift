//
//  SearchCardsWithPricesUseCaseTests.swift
//  MTG HelperTests
//
//  Created by Dan PEROCHEAU on 04/11/2025.
//

import XCTest
@testable import MTG_Helper

final class SearchCardsWithPricesUseCaseTests: XCTestCase {
    var useCase: SearchCardsWithPricesUseCase!
    var mockCardRepository: MockCardRepository!
    var mockCardMarketRepository: MockCardMarketRepository!
    
    override func setUp() {
        super.setUp()
        mockCardRepository = MockCardRepository()
        mockCardMarketRepository = MockCardMarketRepository()
        useCase = SearchCardsWithPricesUseCase(
            cardRepository: mockCardRepository,
            cardMarketRepository: mockCardMarketRepository
        )
    }
    
    override func tearDown() {
        useCase = nil
        mockCardMarketRepository = nil
        mockCardRepository = nil
        super.tearDown()
    }
    
    // MARK: - Success Tests
    
    func testExecute_Success() async throws {
        let testCard = TestDataFactory.createCard(name: "Lightning Bolt")
        mockCardRepository.mockCards = [testCard]
        
        let testPrice = TestDataFactory.createCardMarketPrice(
            cardName: "Lightning Bolt",
            cardId: testCard.id,
            lowestPrice: 1.0,
            trendPrice: 1.6,
            averagePrice: 1.5
        )
        mockCardMarketRepository.mockPrices = [testPrice]
        
        let result = try await useCase.execute(query: "Lightning Bolt")
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.card.name, "Lightning Bolt")
        XCTAssertEqual(result.first?.price?.averagePrice, 1.5)
        XCTAssertEqual(result.first?.price?.lowestPrice, 1.0)
    }
    
    func testExecute_MultipleCards() async throws {
        let cards = [
            TestDataFactory.createCard(id: "card-1", name: "Card 1"),
            TestDataFactory.createCard(id: "card-2", name: "Card 2"),
            TestDataFactory.createCard(id: "card-3", name: "Card 3")
        ]
        mockCardRepository.mockCards = cards
        
        let prices = [
            TestDataFactory.createCardMarketPrice(
                cardName: "Card 1",
                cardId: "card-1",
                lowestPrice: 0.8,
                trendPrice: 1.1,
                averagePrice: 1.0
            ),
            TestDataFactory.createCardMarketPrice(
                cardName: "Card 2",
                cardId: "card-2",
                lowestPrice: 1.8,
                trendPrice: 2.1,
                averagePrice: 2.0
            )
        ]
        mockCardMarketRepository.mockPrices = prices
        
        let result = try await useCase.execute(query: "Card")
        
        XCTAssertEqual(result.count, 3)
        XCTAssertNotNil(result[0].price)
        XCTAssertNotNil(result[1].price)
        XCTAssertNil(result[2].price)
    }
    
    func testExecute_LimitsTo30Cards() async throws {
        let cards = (1...50).map { TestDataFactory.createCard(id: "card-\($0)", name: "Card \($0)") }
        mockCardRepository.mockCards = cards
        
        let result = try await useCase.execute(query: "Card")
        
        XCTAssertEqual(result.count, 30)
    }
    
    func testExecute_CardWithoutPrice() async throws {
        let testCard = TestDataFactory.createCard(name: "Rare Card")
        mockCardRepository.mockCards = [testCard]
        mockCardMarketRepository.mockPrices = []
        
        let result = try await useCase.execute(query: "Rare Card")
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.card.name, "Rare Card")
        XCTAssertNil(result.first?.price)
    }
    
    func testExecute_PriceRepositoryError() async throws {
        let testCard = TestDataFactory.createCard(name: "Test Card")
        mockCardRepository.mockCards = [testCard]
        mockCardMarketRepository.shouldThrowError = true
        
        let result = try await useCase.execute(query: "Test Card")
        
        XCTAssertEqual(result.count, 1)
        XCTAssertNil(result.first?.price)
    }
    
    // MARK: - Error Tests
    
    func testExecute_CardRepositoryError() async {
        mockCardRepository.shouldThrowError = true
        mockCardRepository.errorToThrow = NSError(domain: "CardError", code: 404, userInfo: nil)
        
        do {
            _ = try await useCase.execute(query: "Test")
            XCTFail("Should throw error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testExecute_EmptyResults() async throws {
        mockCardRepository.mockCards = []
        
        let result = try await useCase.execute(query: "Nonexistent")
        
        XCTAssertTrue(result.isEmpty)
    }
    
    // MARK: - Edge Cases
    
    func testExecute_ExactlyThirtyCards() async throws {
        let cards = (1...30).map { TestDataFactory.createCard(id: "card-\($0)", name: "Card \($0)") }
        mockCardRepository.mockCards = cards
        
        let result = try await useCase.execute(query: "Card")
        
        XCTAssertEqual(result.count, 30)
    }
    
    func testExecute_FewerThanThirtyCards() async throws {
        let cards = (1...15).map { TestDataFactory.createCard(id: "card-\($0)", name: "Card \($0)") }
        mockCardRepository.mockCards = cards
        
        let result = try await useCase.execute(query: "Card")
        
        XCTAssertEqual(result.count, 15)
    }
    
    func testExecute_PricesForSomeCards() async throws {
        let cards = [
            TestDataFactory.createCard(id: "priced-1", name: "Priced Card 1"),
            TestDataFactory.createCard(id: "unpriced", name: "Unpriced Card"),
            TestDataFactory.createCard(id: "priced-2", name: "Priced Card 2")
        ]
        mockCardRepository.mockCards = cards
        
        let prices = [
            TestDataFactory.createCardMarketPrice(
                cardName: "Priced Card 1",
                cardId: "priced-1",
                lowestPrice: 0.8,
                trendPrice: 1.1,
                averagePrice: 1.0
            ),
            TestDataFactory.createCardMarketPrice(
                cardName: "Priced Card 2",
                cardId: "priced-2",
                lowestPrice: 1.8,
                trendPrice: 2.1,
                averagePrice: 2.0
            )
        ]
        mockCardMarketRepository.mockPrices = prices
        
        let result = try await useCase.execute(query: "Card")
        
        XCTAssertEqual(result.count, 3)
        XCTAssertNotNil(result[0].price)
        XCTAssertNil(result[1].price)
        XCTAssertNotNil(result[2].price)
    }
}
