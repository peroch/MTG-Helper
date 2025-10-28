//
//  AddCardToDeckUseCase.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 28/10/2025.
//

import Foundation

/// Use case pour ajouter une carte à un deck.
final class AddCardToDeckUseCase {
    private let deckRepository: DeckRepository
    
    init(deckRepository: DeckRepository) {
        self.deckRepository = deckRepository
    }
    
    /// Ajoute une carte à un deck spécifié.
    /// - Parameters:
    ///   - card: La carte à ajouter
    ///   - deck: Le deck cible
    /// - Throws: Une erreur si l'ajout échoue
    func execute(card: Card, to deck: Deck) async throws {
        try await deckRepository.addCard(card, to: deck)
    }
}
