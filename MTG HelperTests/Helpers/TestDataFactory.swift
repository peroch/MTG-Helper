//
//  TestDataFactory.swift
//  MTG HelperTests
//
//  Created by Dan PEROCHEAU on 28/10/2025.
//

import Foundation
@testable import MTG_Helper

/// Factory pour créer des données de test réutilisables.
enum TestDataFactory {
    /// Crée une carte de test avec des valeurs par défaut personnalisables.
    /// - Parameters:
    ///   - id: Identifiant unique de la carte (par défaut : "test-card-1")
    ///   - name: Nom de la carte (par défaut : "Lightning Bolt")
    ///   - manaCost: Coût en mana (par défaut : "{R}")
    ///   - typeLine: Type de la carte (par défaut : "Instant")
    ///   - oracleText: Texte Oracle (par défaut : "Deal 3 damage...")
    /// - Returns: Une instance de Card pour les tests
    static func createCard(
        id: String = "test-card-1",
        name: String = "Lightning Bolt",
        manaCost: String = "{R}",
        typeLine: String = "Instant",
        oracleText: String = "Deal 3 damage to any target."
    ) -> Card {
        return Card(
            id: id,
            name: name,
            manaCost: manaCost,
            cmc: 1.0,
            typeLine: typeLine,
            oracleText: oracleText,
            colors: ["R"],
            colorIdentity: ["R"],
            rarity: "common",
            setCode: "LEA",
            setName: "Limited Edition Alpha",
            imageUris: Card.ImageUris(
                small: "https://example.com/small.jpg",
                normal: "https://example.com/normal.jpg",
                large: "https://example.com/large.jpg",
                png: "https://example.com/png.png",
                artCrop: "https://example.com/art_crop.jpg",
                borderCrop: "https://example.com/border_crop.jpg"
            )
        )
    }
    
    /// Crée un deck de test avec des valeurs par défaut personnalisables.
    /// - Parameters:
    ///   - name: Nom du deck (par défaut : "Test Deck")
    ///   - format: Format du deck (par défaut : "Standard")
    /// - Returns: Une instance de Deck pour les tests
    static func createDeck(
        name: String = "Test Deck",
        format: String = "Standard"
    ) -> Deck {
        return Deck(name: name, format: format)
    }
    
    /// Crée une carte de deck de test.
    /// - Parameters:
    ///   - card: La carte associée (par défaut : carte créée via createCard())
    ///   - quantity: Quantité de la carte (par défaut : 1)
    /// - Returns: Une instance de DeckCard pour les tests
    static func createDeckCard(
        card: Card? = nil,
        quantity: Int = 1
    ) -> DeckCard {
        let testCard = card ?? createCard()
        return DeckCard(
            cardId: testCard.id,
            name: testCard.name,
            manaCost: testCard.manaCost,
            typeLine: testCard.typeLine,
            imageUrl: testCard.imageUris?.small,
            quantity: quantity
        )
    }
    
    /// Crée plusieurs cartes de test différentes.
    /// - Parameter count: Nombre de cartes à créer
    /// - Returns: Tableau de cartes uniques
    static func createCards(count: Int) -> [Card] {
        return (0..<count).map { index in
            createCard(
                id: "test-card-\(index)",
                name: "Test Card \(index)",
                manaCost: "{\(index)}",
                typeLine: "Creature - Test"
            )
        }
    }
    
    /// Crée plusieurs decks de test différents.
    /// - Parameter count: Nombre de decks à créer
    /// - Returns: Tableau de decks uniques
    static func createDecks(count: Int) -> [Deck] {
        let formats = ["Standard", "Modern", "Commander", "Legacy", "Vintage"]
        return (0..<count).map { index in
            createDeck(
                name: "Test Deck \(index)",
                format: formats[index % formats.count]
            )
        }
    }
}
