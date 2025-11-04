//
//  CardMarketSpoilersViewModelTests.swift
//  MTG HelperTests
//
//  Created by Dan PEROCHEAU on 04/11/2025.
//

import XCTest
@testable import MTG_Helper

@MainActor
final class CardMarketSpoilersViewModelTests: XCTestCase {
    var viewModel: CardMarketSpoilersViewModel!
    var mockCardRepository: MockCardRepository!
    var mockCardMarketRepository: MockCardMarketRepository!
    var getSpoilersUseCase: GetNewSpoilersWithPricesUseCase!
    
    override func setUp() {
        super.setUp()
        mockCardRepository = MockCardRepository()
        mockCardMarketRepository = MockCardMarketRepository()
        getSpoilersUseCase = GetNewSpoilersWithPricesUseCase(
            cardRepository: mockCardRepository,
            cardMarketRepository: mockCardMarketRepository
        )
        viewModel = CardMarketSpoilersViewModel(getSpoilersUseCase: getSpoilersUseCase)
    }
    
    override func tearDown() {
        viewModel = nil
        getSpoilersUseCase = nil
        mockCardMarketRepository = nil
        mockCardRepository = nil
        super.tearDown()
    }
    
    // MARK: - Load Spoilers Tests
    
    func testLoadSpoilers_Success() async {
        let testCard = TestDataFactory.createCard(name: "New Spoiler Card")
        mockCardRepository.mockCards = [testCard]
        
        let testPrice = TestDataFactory.createCardMarketPrice(
            cardName: "New Spoiler Card",
            cardId: testCard.id,
            lowestPrice: 4.0,
            trendPrice: 5.5,
            averagePrice: 5.0
        )
        mockCardMarketRepository.mockPrices = [testPrice]
        
        await viewModel.loadSpoilers()
        
        XCTAssertEqual(viewModel.cardsWithPrices.count, 1)
        XCTAssertEqual(viewModel.cardsWithPrices.first?.card.name, "New Spoiler Card")
        XCTAssertEqual(viewModel.cardsWithPrices.first?.price?.averagePrice, 5.0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testLoadSpoilers_NoSpoilers() async {
        mockCardRepository.mockCards = []
        
        await viewModel.loadSpoilers()
        
        XCTAssertTrue(viewModel.cardsWithPrices.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testLoadSpoilers_Error() async {
        mockCardRepository.shouldThrowError = true
        mockCardRepository.errorToThrow = NSError(domain: "SpoilerError", code: 500, userInfo: nil)
        
        await viewModel.loadSpoilers()
        
        XCTAssertTrue(viewModel.cardsWithPrices.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.errorMessage?.contains("Failed to load spoilers") ?? false)
    }
    
    func testLoadSpoilers_MultipleSpoilers() async {
        let card1 = TestDataFactory.createCard(id: "card-1", name: "Spoiler 1")
        let card2 = TestDataFactory.createCard(id: "card-2", name: "Spoiler 2")
        let card3 = TestDataFactory.createCard(id: "card-3", name: "Spoiler 3")
        mockCardRepository.mockCards = [card1, card2, card3]
        
        let price1 = TestDataFactory.createCardMarketPrice(
            cardName: "Spoiler 1",
            cardId: "card-1",
            lowestPrice: 1.5,
            trendPrice: 2.2,
            averagePrice: 2.0
        )
        let price2 = TestDataFactory.createCardMarketPrice(
            cardName: "Spoiler 2",
            cardId: "card-2",
            lowestPrice: 7.0,
            trendPrice: 8.5,
            averagePrice: 8.0
        )
        mockCardMarketRepository.mockPrices = [price1, price2]
        
        await viewModel.loadSpoilers()
        
        XCTAssertEqual(viewModel.cardsWithPrices.count, 3)
        XCTAssertNotNil(viewModel.cardsWithPrices[0].price)
        XCTAssertNotNil(viewModel.cardsWithPrices[1].price)
        XCTAssertNil(viewModel.cardsWithPrices[2].price)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testLoadSpoilers_CardMarketError() async {
        let testCard = TestDataFactory.createCard(name: "Spoiler Card")
        mockCardRepository.mockCards = [testCard]
        mockCardMarketRepository.shouldThrowError = true
        
        await viewModel.loadSpoilers()
        
        // Le UseCase utilise try? pour CardMarketRepository, donc pas d'erreur
        // On obtient des cartes sans prix
        XCTAssertEqual(viewModel.cardsWithPrices.count, 1)
        XCTAssertNil(viewModel.cardsWithPrices.first?.price)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    // MARK: - Refresh Tests
    
    func testRefresh_CallsLoadSpoilers() async {
        let testCard = TestDataFactory.createCard(name: "Refreshed Spoiler")
        mockCardRepository.mockCards = [testCard]
        
        let testPrice = TestDataFactory.createCardMarketPrice(
            cardName: "Refreshed Spoiler",
            cardId: testCard.id,
            lowestPrice: 2.5,
            trendPrice: 3.2,
            averagePrice: 3.0
        )
        mockCardMarketRepository.mockPrices = [testPrice]
        
        await viewModel.refresh()
        
        XCTAssertEqual(viewModel.cardsWithPrices.count, 1)
        XCTAssertEqual(viewModel.cardsWithPrices.first?.card.name, "Refreshed Spoiler")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testRefresh_UpdatesExistingData() async {
        let card1 = TestDataFactory.createCard(name: "Old Spoiler")
        mockCardRepository.mockCards = [card1]
        
        await viewModel.loadSpoilers()
        
        XCTAssertEqual(viewModel.cardsWithPrices.count, 1)
        
        let card2 = TestDataFactory.createCard(name: "New Spoiler")
        mockCardRepository.mockCards = [card2]
        
        await viewModel.refresh()
        
        XCTAssertEqual(viewModel.cardsWithPrices.count, 1)
        XCTAssertEqual(viewModel.cardsWithPrices.first?.card.name, "New Spoiler")
    }
    
    func testRefresh_ClearsErrorMessage() async {
        // Provoque une erreur du CardRepository (seul qui remonte au ViewModel)
        mockCardRepository.errorToThrow = NSError(domain: "TestError", code: 500, userInfo: nil)
        
        await viewModel.loadSpoilers()
        
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.cardsWithPrices.isEmpty)
        
        // Corrige l'erreur
        mockCardRepository.searchError = nil
        let testCard = TestDataFactory.createCard(name: "Fixed Spoiler")
        mockCardRepository.mockCards = [testCard]
        
        await viewModel.refresh()
        
        // Vérifie que l'erreur est bien effacée
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.cardsWithPrices.count, 1)
    }
}
