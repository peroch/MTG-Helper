//
//  CardMarketSearchViewModel.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 04/11/2025.
//

import Foundation

/// ViewModel for the CardMarket search view
@MainActor
class CardMarketSearchViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var cardsWithPrices: [CardWithPrice] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let searchCardsWithPricesUseCase: SearchCardsWithPricesUseCase
    
    init(searchCardsWithPricesUseCase: SearchCardsWithPricesUseCase) {
        self.searchCardsWithPricesUseCase = searchCardsWithPricesUseCase
    }
    
    /// Searches for cards with their prices
    func search() async {
        guard !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty else {
            cardsWithPrices = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            cardsWithPrices = try await searchCardsWithPricesUseCase.execute(query: searchQuery)
        } catch {
            errorMessage = "Search failed: \(error.localizedDescription)"
            cardsWithPrices = []
        }
        
        isLoading = false
    }
    
    /// Clears the search results
    func clearSearch() {
        searchQuery = ""
        cardsWithPrices = []
        errorMessage = nil
    }
}
