//
//  DeckRepository.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 28/10/2025.
//

import Foundation

/// Protocol définissant les opérations de gestion des decks et de leurs cartes.
protocol DeckRepository {
    /// Ajoute une carte à un deck.
    /// - Parameters:
    ///   - card: La carte à ajouter
    ///   - deck: Le deck cible
    /// - Throws: Une erreur si l'ajout échoue
    func addCard(_ card: Card, to deck: Deck) async throws
    
    /// Retire une carte d'un deck.
    /// - Parameters:
    ///   - deckCard: La carte du deck à retirer
    ///   - deck: Le deck source
    /// - Throws: Une erreur si la suppression échoue
    func removeCard(_ deckCard: DeckCard, from deck: Deck) async throws
    
    /// Récupère toutes les cartes d'un deck.
    /// - Parameter deck: Le deck dont on veut les cartes
    /// - Returns: La liste des cartes du deck
    func getCards(for deck: Deck) async throws -> [DeckCard]
    
    /// Récupère tous les decks.
    /// - Returns: La liste de tous les decks
    func getAllDecks() async throws -> [Deck]
    
    /// Vérifie si une carte est présente dans un ou plusieurs decks.
    /// - Parameter cardId: L'identifiant de la carte
    /// - Returns: La liste des decks contenant cette carte
    func getDecksContaining(cardId: String) async throws -> [Deck]
}
