//
//  CardMarketRepository.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 04/11/2025.
//

import Foundation

/// Protocol defining the contract for CardMarket API interactions
protocol CardMarketRepository {
    /// Searches for products by name on CardMarket
    /// - Parameter query: The search term
    /// - Returns: Array of products with price information
    func searchProducts(query: String) async throws -> [CardMarketPrice]
    
    /// Fetches price information for a specific product by name
    /// - Parameter cardName: The exact card name
    /// - Returns: Price information if found
    func getPrice(for cardName: String) async throws -> CardMarketPrice?
    
    /// Fetches prices for multiple cards at once
    /// - Parameter cardNames: Array of card names
    /// - Returns: Array of price information
    func getPrices(for cardNames: [String]) async throws -> [CardMarketPrice]
}
