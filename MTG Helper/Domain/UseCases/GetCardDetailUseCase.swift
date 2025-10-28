//
//  GetCardDetailUseCase.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 25/08/2025.
//

import Foundation

/// Use case responsable de la récupération des détails d'une carte Magic.
/// Encapsule la logique métier de récupération et délègue l'accès aux données au repository.
struct GetCardDetailUseCase {
    private let repository: CardRepository
    
    /// Initialise le use case avec le repository nécessaire.
    /// - Parameter repository: Repository fournissant l'accès aux données des cartes
    init(repository: CardRepository) {
        self.repository = repository
    }
    
    /// Exécute la récupération des détails d'une carte spécifique.
    /// - Parameter id: Identifiant unique de la carte
    /// - Returns: La carte correspondante avec tous ses détails
    /// - Throws: Une erreur si la carte n'existe pas ou si la récupération échoue
    func execute(id: String) async throws -> Card {
        try await repository.getDetail(id: id)
    }
}
