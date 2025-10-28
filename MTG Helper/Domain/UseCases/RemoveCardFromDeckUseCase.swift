//
//  RemoveCardFromDeckUseCase.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 28/10/2025.
//

import Foundation

/// Use case pour retirer une carte d'un deck.
final class RemoveCardFromDeckUseCase {
    private let deckRepository: DeckRepository
    
    init(deckRepository: DeckRepository) {
        self.deckRepository = deckRepository
    }
    
    /// Retire une carte d'un deck spécifié.
    /// - Parameters:
    ///   - deckCard: La carte du deck à retirer
    ///   - deck: Le deck source
    /// - Throws: Une erreur si la suppression échoue
    func execute(deckCard: DeckCard, from deck: Deck) async throws {
        try await deckRepository.removeCard(deckCard, from: deck)
    }
}
