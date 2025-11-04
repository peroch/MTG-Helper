//
//  GetNewSpoilersWithPricesUseCaseTests.swift
//  MTG HelperTests
//
//  Created by Dan PEROCHEAU on 04/11/2025.
//

import XCTest
@testable import MTG_Helper

final class GetNewSpoilersWithPricesUseCaseTests: XCTestCase {
    var useCase: GetNewSpoilersWithPricesUseCase!
    var mockCardRepository: MockCardRepository!
    var mockCardMarketRepository: MockCardMarketRepository!
    
    override func setUp() {
        super.setUp()
        mockCardRepository = MockCardRepository()
        mockCardMarketRepository = MockCardMarketRepository()
        useCase = GetNewSpoilersWithPricesUseCase(
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
        let testCard = TestDataFactory.createCard(name: "New Spoiler")
        mockCardRepository.mockCards = [testCard]
        
        let testPrice = TestDataFactory.createCardMarketPrice(
            cardName: "New Spoiler",
            cardId: testCard.id,
            lowestPrice: 4.0,
            trendPrice: 5.5,
            averagePrice: 5.0
        )
        mockCardMarketRepository.mockPrices = [testPrice]
        
        let result = try await useCase.execute()
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.card.name, "New Spoiler")
        XCTAssertEqual(result.first?.price?.averagePrice, 5.0)
        XCTAssertEqual(result.first?.price?.lowestPrice, 4.0)
    }
    
    func testExecute_MultipleSpoilers() async throws {
        let cards = [
            TestDataFactory.createCard(id: "spoiler-1", name: "Spoiler 1"),
            TestDataFactory.createCard(id: "spoiler-2", name: "Spoiler 2"),
            TestDataFactory.createCard(id: "spoiler-3", name: "Spoiler 3")
        ]
        mockCardRepository.mockCards = cards
        
        let prices = [
            TestDataFactory.createCardMarketPrice(
                cardName: "Spoiler 1",
                cardId: "spoiler-1",
                lowestPrice: 1.5,
                trendPrice: 2.2,
                averagePrice: 2.0
            ),
            TestDataFactory.createCardMarketPrice(
                cardName: "Spoiler 2",
                cardId: "spoiler-2",
                lowestPrice: 7.0,
                trendPrice: 8.5,
                averagePrice: 8.0
            )
        ]
        mockCardMarketRepository.mockPrices = prices
        
        let result = try await useCase.execute()
        
        XCTAssertEqual(result.count, 3)
        XCTAssertNotNil(result[0].price)
        XCTAssertNotNil(result[1].price)
        XCTAssertNil(result[2].price)
    }
    
    func testExecute_LimitsTo50Cards() async throws {
        let cards = (1...100).map { TestDataFactory.createCard(id: "spoiler-\($0)", name: "Spoiler \($0)") }
        mockCardRepository.mockCards = cards
        
        let result = try await useCase.execute()
        
        XCTAssertEqual(result.count, 50)
    }
    
    func testExecute_CardWithoutPrice() async throws {
        let testCard = TestDataFactory.createCard(name: "Rare Spoiler")
        mockCardRepository.mockCards = [testCard]
        mockCardMarketRepository.mockPrices = []
        
        let result = try await useCase.execute()
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.card.name, "Rare Spoiler")
        XCTAssertNil(result.first?.price)
    }
    
    func testExecute_PriceRepositoryError() async throws {
        let testCard = TestDataFactory.createCard(name: "Spoiler Card")
        mockCardRepository.mockCards = [testCard]
        mockCardMarketRepository.shouldThrowError = true
        
        let result = try await useCase.execute()
        
        XCTAssertEqual(result.count, 1)
        XCTAssertNil(result.first?.price)
    }
    
    // MARK: - Error Tests
    
    func testExecute_CardRepositoryError() async {
        mockCardRepository.shouldThrowError = true
        mockCardRepository.errorToThrow = NSError(domain: "SpoilerError", code: 500, userInfo: nil)
        
        do {
            _ = try await useCase.execute()
            XCTFail("Should throw error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testExecute_EmptyResults() async throws {
        mockCardRepository.mockCards = []
        
        let result = try await useCase.execute()
        
        XCTAssertTrue(result.isEmpty)
    }
    
    // MARK: - Edge Cases
    
    func testExecute_ExactlyFiftyCards() async throws {
        let cards = (1...50).map { TestDataFactory.createCard(id: "spoiler-\($0)", name: "Spoiler \($0)") }
        mockCardRepository.mockCards = cards
        
        let result = try await useCase.execute()
        
        XCTAssertEqual(result.count, 50)
    }
    
    func testExecute_FewerThanFiftyCards() async throws {
        let cards = (1...25).map { TestDataFactory.createCard(id: "spoiler-\($0)", name: "Spoiler \($0)") }
        mockCardRepository.mockCards = cards
        
        let result = try await useCase.execute()
        
        XCTAssertEqual(result.count, 25)
    }
    
    func testExecute_PricesForSomeCards() async throws {
        let cards = [
            TestDataFactory.createCard(id: "priced-1", name: "Priced Spoiler 1"),
            TestDataFactory.createCard(id: "unpriced", name: "Unpriced Spoiler"),
            TestDataFactory.createCard(id: "priced-2", name: "Priced Spoiler 2")
        ]
        mockCardRepository.mockCards = cards
        
        let prices = [
            TestDataFactory.createCardMarketPrice(
                cardName: "Priced Spoiler 1",
                cardId: "priced-1",
                lowestPrice: 2.5,
                trendPrice: 3.2,
                averagePrice: 3.0
            ),
            TestDataFactory.createCardMarketPrice(
                cardName: "Priced Spoiler 2",
                cardId: "priced-2",
                lowestPrice: 10.0,
                trendPrice: 13.0,
                averagePrice: 12.0
            )
        ]
        mockCardMarketRepository.mockPrices = prices
        
        let result = try await useCase.execute()
        
        XCTAssertEqual(result.count, 3)
        XCTAssertNotNil(result[0].price)
        XCTAssertNil(result[1].price)
        XCTAssertNotNil(result[2].price)
    }
}
