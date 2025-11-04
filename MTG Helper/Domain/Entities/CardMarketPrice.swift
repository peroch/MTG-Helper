//
//  CardMarketPrice.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 04/11/2025.
//

import Foundation

/// Represents price information from CardMarket for a specific card
struct CardMarketPrice: Identifiable, Equatable {
    let id: String
    let cardName: String
    let cardId: String
    let lowestPrice: Double?
    let trendPrice: Double?
    let averagePrice: Double?
    let currency: String
    let lastUpdated: Date
    
    init(
        id: String = UUID().uuidString,
        cardName: String,
        cardId: String,
        lowestPrice: Double? = nil,
        trendPrice: Double? = nil,
        averagePrice: Double? = nil,
        currency: String = "EUR",
        lastUpdated: Date = Date()
    ) {
        self.id = id
        self.cardName = cardName
        self.cardId = cardId
        self.lowestPrice = lowestPrice
        self.trendPrice = trendPrice
        self.averagePrice = averagePrice
        self.currency = currency
        self.lastUpdated = lastUpdated
    }
}
