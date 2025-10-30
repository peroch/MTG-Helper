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
    ///   - oracleText: Texte Oracle (par défaut : "Deal 3 damage...")
    ///   - imageUrl: URL de l'image (par défaut : "https://example.com/card.jpg")
    ///   - manaCost: Coût en mana (par défaut : "{R}")
    /// - Returns: Une instance de Card pour les tests
    static func createCard(
        id: String = "test-card-1",
        name: String = "Lightning Bolt",
        oracleText: String? = "Deal 3 damage to any target.",
        imageUrl: String? = "https://example.com/card.jpg",
        manaCost: String? = "{R}"
    ) -> Card {
        return Card(
            id: id,
            name: name,
            oracleText: oracleText,
            imageUrl: imageUrl,
            rulings: [],
            manaCost: manaCost
        )
    }

    /// Crée un deck de test avec des valeurs par défaut personnalisables.
    /// - Parameters:
    ///   - name: Nom du deck (par défaut : "Test Deck")
    ///   - format: Format du deck (par défaut : .standard)
    /// - Returns: Une instance de Deck pour les tests
    static func createDeck(
        name: String = "Test Deck",
        format: DeckFormat = .standard
    ) -> Deck {
        return Deck(name: name, format: format)
    }

    /// Crée une carte de deck de test.
    /// - Parameters:
    ///   - card: La carte associée (par défaut : carte créée via createCard())
    /// - Returns: Une instance de DeckCard pour les tests
    static func createDeckCard(
        card: Card? = nil
    ) -> DeckCard {
        let testCard = card ?? createCard()
        return DeckCard(
            cardId: testCard.id,
            cardName: testCard.name,
            cardImageUrl: testCard.imageUrl,
            cardManaCost: testCard.manaCost,
            cardTypeLine: testCard.typeLine
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
                oracleText: "Test oracle text for card \(index)",
                imageUrl: "https://example.com/card-\(index).jpg",
                manaCost: "{\(index)}"
            )
        }
    }

    /// Crée plusieurs decks de test différents.
    /// - Parameter count: Nombre de decks à créer
    /// - Returns: Tableau de decks uniques
    static func createDecks(count: Int) -> [Deck] {
        let formats: [DeckFormat] = [.standard, .modern, .duelCommander]
        return (0..<count).map { index in
            createDeck(
                name: "Test Deck \(index)",
                format: formats[index % formats.count]
            )
        }
    }
}
