//
//  DeckRepositoryImpl.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 28/10/2025.
//

import Foundation
import SwiftData

/// Implémentation du repository de gestion des decks utilisant SwiftData.
final class DeckRepositoryImpl: DeckRepository {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    /// Ajoute une carte à un deck.
    /// - Parameters:
    ///   - card: La carte à ajouter
    ///   - deck: Le deck cible
    /// - Throws: Une erreur si l'ajout échoue
    func addCard(_ card: Card, to deck: Deck) async throws {
        let deckCard = DeckCard(
            cardId: card.id,
            cardName: card.name,
            cardImageUrl: card.imageUrl,
            cardManaCost: card.manaCost
        )
        
        deckCard.deck = deck
        deck.cards.append(deckCard)
        deck.updatedAt = Date()
        
        modelContext.insert(deckCard)
        try modelContext.save()
    }
    
    /// Retire une carte d'un deck.
    /// - Parameters:
    ///   - deckCard: La carte du deck à retirer
    ///   - deck: Le deck source
    /// - Throws: Une erreur si la suppression échoue
    func removeCard(_ deckCard: DeckCard, from deck: Deck) async throws {
        deck.updatedAt = Date()
        modelContext.delete(deckCard)
        try modelContext.save()
    }
    
    /// Récupère toutes les cartes d'un deck.
    /// - Parameter deck: Le deck dont on veut les cartes
    /// - Returns: La liste des cartes du deck
    func getCards(for deck: Deck) async throws -> [DeckCard] {
        return deck.cards
    }
    
    /// Récupère tous les decks.
    /// - Returns: La liste de tous les decks
    func getAllDecks() async throws -> [Deck] {
        let descriptor = FetchDescriptor<Deck>(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }
    
    /// Vérifie si une carte est présente dans un ou plusieurs decks.
    /// - Parameter cardId: L'identifiant de la carte
    /// - Returns: La liste des decks contenant cette carte
    func getDecksContaining(cardId: String) async throws -> [Deck] {
        let descriptor = FetchDescriptor<DeckCard>(
            predicate: #Predicate { $0.cardId == cardId }
        )
        let deckCards = try modelContext.fetch(descriptor)
        
        let decks = deckCards.compactMap { $0.deck }
        return Array(Set(decks))
    }
}
