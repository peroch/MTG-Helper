//
//  CardMarketSearchViewModelTests.swift
//  MTG HelperTests
//
//  Created by Dan PEROCHEAU on 04/11/2025.
//

import XCTest
@testable import MTG_Helper

@MainActor
final class CardMarketSearchViewModelTests: XCTestCase {
    var viewModel: CardMarketSearchViewModel!
    var mockCardRepository: MockCardRepository!
    var mockCardMarketRepository: MockCardMarketRepository!
    var searchUseCase: SearchCardsWithPricesUseCase!
    
    override func setUp() {
        super.setUp()
        mockCardRepository = MockCardRepository()
        mockCardMarketRepository = MockCardMarketRepository()
        searchUseCase = SearchCardsWithPricesUseCase(
            cardRepository: mockCardRepository,
            cardMarketRepository: mockCardMarketRepository
        )
        viewModel = CardMarketSearchViewModel(searchCardsWithPricesUseCase: searchUseCase)
    }
    
    override func tearDown() {
        viewModel = nil
        searchUseCase = nil
        mockCardMarketRepository = nil
        mockCardRepository = nil
        super.tearDown()
    }
    
    // MARK: - Search Tests
    
    func testSearch_Success() async {
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
        
        viewModel.searchQuery = "Lightning Bolt"
        await viewModel.search()
        
        XCTAssertEqual(viewModel.cardsWithPrices.count, 1)
        XCTAssertEqual(viewModel.cardsWithPrices.first?.card.name, "Lightning Bolt")
        XCTAssertEqual(viewModel.cardsWithPrices.first?.price?.averagePrice, 1.5)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testSearch_EmptyQuery() async {
        viewModel.searchQuery = ""
        await viewModel.search()
        
        XCTAssertTrue(viewModel.cardsWithPrices.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testSearch_WhitespaceQuery() async {
        viewModel.searchQuery = "   "
        await viewModel.search()
        
        XCTAssertTrue(viewModel.cardsWithPrices.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testSearch_NoResults() async {
        mockCardRepository.mockCards = []
        
        viewModel.searchQuery = "Nonexistent Card"
        await viewModel.search()
        
        XCTAssertTrue(viewModel.cardsWithPrices.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testSearch_CardRepositoryError() async {
        mockCardRepository.shouldThrowError = true
        mockCardRepository.errorToThrow = NSError(domain: "CardError", code: 404, userInfo: nil)
        
        viewModel.searchQuery = "Lightning Bolt"
        await viewModel.search()
        
        XCTAssertTrue(viewModel.cardsWithPrices.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.errorMessage?.contains("Search failed") ?? false)
    }
    
    func testSearch_CardMarketRepositoryError() async {
        let testCard = TestDataFactory.createCard(name: "Lightning Bolt")
        mockCardRepository.mockCards = [testCard]
        mockCardMarketRepository.shouldThrowError = true
        
        viewModel.searchQuery = "Lightning Bolt"
        await viewModel.search()
        
        // L'erreur du CardMarketRepository est avalée par try? dans le use case
        // Donc on obtient des cartes sans prix au lieu d'une erreur
        XCTAssertEqual(viewModel.cardsWithPrices.count, 1)
        XCTAssertNil(viewModel.cardsWithPrices.first?.price)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testSearch_MultipleCards() async {
        let card1 = TestDataFactory.createCard(id: "card-1", name: "Lightning Bolt")
        let card2 = TestDataFactory.createCard(id: "card-2", name: "Lightning Strike")
        mockCardRepository.mockCards = [card1, card2]
        
        let price1 = TestDataFactory.createCardMarketPrice(
            cardName: "Lightning Bolt",
            cardId: "card-1",
            lowestPrice: 1.0,
            trendPrice: 1.6,
            averagePrice: 1.5
        )
        let price2 = TestDataFactory.createCardMarketPrice(
            cardName: "Lightning Strike",
            cardId: "card-2",
            lowestPrice: 0.3,
            trendPrice: 0.6,
            averagePrice: 0.5
        )
        mockCardMarketRepository.mockPrices = [price1, price2]
        
        viewModel.searchQuery = "Lightning"
        await viewModel.search()
        
        XCTAssertEqual(viewModel.cardsWithPrices.count, 2)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testSearch_CardWithoutPrice() async {
        let testCard = TestDataFactory.createCard(name: "Rare Card")
        mockCardRepository.mockCards = [testCard]
        mockCardMarketRepository.mockPrices = []
        
        viewModel.searchQuery = "Rare Card"
        await viewModel.search()
        
        XCTAssertEqual(viewModel.cardsWithPrices.count, 1)
        XCTAssertNil(viewModel.cardsWithPrices.first?.price)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    // MARK: - Clear Search Tests
    
    func testClearSearch_ResetsState() async {
        let testCard = TestDataFactory.createCard(name: "Lightning Bolt")
        mockCardRepository.mockCards = [testCard]
        
        viewModel.searchQuery = "Lightning Bolt"
        await viewModel.search()
        
        XCTAssertFalse(viewModel.cardsWithPrices.isEmpty)
        
        viewModel.clearSearch()
        
        XCTAssertEqual(viewModel.searchQuery, "")
        XCTAssertTrue(viewModel.cardsWithPrices.isEmpty)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testClearSearch_WithError() async {
        mockCardRepository.errorToThrow = NSError(domain: "TestError", code: 500, userInfo: nil)
        
        viewModel.searchQuery = "Test"
        await viewModel.search()
        
        // Vérifie qu'une erreur du CardRepository est bien capturée
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.cardsWithPrices.isEmpty)
        
        viewModel.clearSearch()
        
        // Vérifie que clearSearch efface bien l'erreur
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.searchQuery, "")
    }
}
