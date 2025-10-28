//
//  GetDecksContainingCardUseCase.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 28/10/2025.
//

import Foundation

/// Use case pour récupérer les decks contenant une carte spécifique.
final class GetDecksContainingCardUseCase {
    private let deckRepository: DeckRepository
    
    init(deckRepository: DeckRepository) {
        self.deckRepository = deckRepository
    }
    
    /// Récupère tous les decks contenant une carte spécifique.
    /// - Parameter cardId: L'identifiant de la carte
    /// - Returns: La liste des decks contenant cette carte
    func execute(cardId: String) async throws -> [Deck] {
        return try await deckRepository.getDecksContaining(cardId: cardId)
    }
}
