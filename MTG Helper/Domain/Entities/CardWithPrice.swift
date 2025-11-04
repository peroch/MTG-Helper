//
//  CardWithPrice.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 04/11/2025.
//

import Foundation

/// Represents a card with its associated CardMarket price information
struct CardWithPrice: Identifiable, Equatable {
    static func == (lhs: CardWithPrice, rhs: CardWithPrice) -> Bool {
        return lhs.card.id == rhs.card.id
    }
    
    let card: Card
    let price: CardMarketPrice?
    
    var id: String {
        card.id
    }
    
    init(card: Card, price: CardMarketPrice? = nil) {
        self.card = card
        self.price = price
    }
}
