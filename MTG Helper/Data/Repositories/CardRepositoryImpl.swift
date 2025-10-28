//
//  CardRepositoryImpl.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 25/08/2025.
//

import Foundation

/// Implémentation concrète du repository de cartes.
/// Délègue les appels réseau au client API Scryfall.
final class CardRepositoryImpl: CardRepository {
    private let api: ScryfallAPI
    
    /// Initialise le repository avec le client API nécessaire.
    /// - Parameter api: Client API Scryfall pour les requêtes réseau
    init(api: ScryfallAPI) {
        self.api = api
    }
    
    /// Recherche des cartes correspondant à une requête textuelle.
    /// - Parameter query: Texte de recherche pour filtrer les cartes
    /// - Returns: Tableau de cartes correspondant aux critères de recherche
    /// - Throws: Une erreur si la recherche échoue (problème réseau, parsing, etc.)
    func search(query: String) async throws -> [Card] {
        try await api.searchCards(query: query)
    }
    
    /// Récupère les détails complets d'une carte spécifique.
    /// - Parameter id: Identifiant unique de la carte
    /// - Returns: La carte correspondante avec tous ses détails
    /// - Throws: Une erreur si la carte n'existe pas ou si la récupération échoue
    func getDetail(id: String) async throws -> Card {
        try await api.getCardDetails(id: id)
    }
}
