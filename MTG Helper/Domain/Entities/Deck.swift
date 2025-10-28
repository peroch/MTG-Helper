//
//  Deck.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 28/10/2025.
//

import Foundation
import SwiftData

@Model
final class Deck {
    var id: UUID
    var name: String
    var format: DeckFormat
    var createdAt: Date
    var updatedAt: Date
    
    init(name: String, format: DeckFormat) {
        self.id = UUID()
        self.name = name
        self.format = format
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

enum DeckFormat: String, Codable, CaseIterable {
    case standard = "Standard"
    case modern = "Modern"
    case duelCommander = "Duel Commander"
    
    var displayName: String {
        return self.rawValue
    }
}
