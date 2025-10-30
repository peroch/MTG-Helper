//
//  UpdateDeckUseCase.swift
//  MTG Helper
//
//  Created by Cline on 30/10/2025.
//

import Foundation

/// Use case pour mettre à jour les propriétés d'un deck.
final class UpdateDeckUseCase {
    private let repository: DeckRepository
    
    init(repository: DeckRepository) {
        self.repository = repository
    }
    
    /// Met à jour les propriétés d'un deck.
    /// - Parameters:
    ///   - deck: Le deck à mettre à jour
    ///   - name: Le nouveau nom du deck
    ///   - format: Le nouveau format du deck
    /// - Throws: Une erreur si la mise à jour échoue
    func execute(deck: Deck, name: String, format: DeckFormat) async throws {
        try await repository.updateDeck(deck, name: name, format: format)
    }
}
