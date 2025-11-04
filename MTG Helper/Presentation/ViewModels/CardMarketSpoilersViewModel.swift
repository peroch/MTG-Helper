//
//  CardMarketSpoilersViewModel.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 04/11/2025.
//

import Foundation

/// ViewModel for the CardMarket spoilers view
@MainActor
class CardMarketSpoilersViewModel: ObservableObject {
    @Published var cardsWithPrices: [CardWithPrice] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let getSpoilersUseCase: GetNewSpoilersWithPricesUseCase
    
    init(getSpoilersUseCase: GetNewSpoilersWithPricesUseCase) {
        self.getSpoilersUseCase = getSpoilersUseCase
    }
    
    /// Loads the latest spoiled cards with their prices
    func loadSpoilers() async {
        isLoading = true
        errorMessage = nil
        
        do {
            cardsWithPrices = try await getSpoilersUseCase.execute()
        } catch {
            errorMessage = "Failed to load spoilers: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    /// Reloads the spoilers
    func refresh() async {
        await loadSpoilers()
    }
}
