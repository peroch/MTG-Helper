//
//  CardRepository.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 25/08/2025.
//

import Foundation

/// Protocol définissant les opérations de persistance et récupération des cartes.
/// Les implémentations concrètes se trouvent dans la couche Data.
protocol CardRepository {
    
    /// Recherche des cartes correspondant à une requête textuelle.
    /// - Parameter query: Texte de recherche pour filtrer les cartes
    /// - Returns: Tableau de cartes correspondant aux critères de recherche
    /// - Throws: Une erreur si la recherche échoue
    func search(query: String) async throws -> [Card]
    
    /// Récupère les détails complets d'une carte spécifique.
    /// - Parameter id: Identifiant unique de la carte
    /// - Returns: La carte correspondante avec tous ses détails
    /// - Throws: Une erreur si la carte n'existe pas ou si la récupération échoue
    func getDetail(id: String) async throws -> Card
}
