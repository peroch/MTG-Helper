//
//  SearchCardsUseCase.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 25/08/2025.
//

import Foundation

/// Use case responsable de la recherche de cartes Magic.
/// Encapsule la logique métier de recherche et délègue la récupération au repository.
struct SearchCardsUseCase {
    private let repository: CardRepository
    
    /// Initialise le use case avec le repository nécessaire.
    /// - Parameter repository: Repository fournissant l'accès aux données des cartes
    init(repository: CardRepository) {
        self.repository = repository
    }

    /// Exécute la recherche de cartes selon une requête textuelle.
    /// - Parameter query: Texte de recherche pour filtrer les cartes
    /// - Returns: Tableau de cartes correspondant aux critères de recherche
    /// - Throws: Une erreur si la recherche échoue
    func execute(query: String) async throws -> [Card] {
        try await repository.search(query: query)
    }
}
