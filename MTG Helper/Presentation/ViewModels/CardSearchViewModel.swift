//
//  CardSearchViewModel.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 25/07/2025.
//

import SwiftUI

/// ViewModel gérant la logique de recherche de cartes.
/// Encapsule l'état de chargement et la liste des résultats pour la vue de recherche.
@MainActor
final class CardSearchViewModel: ObservableObject {
    /// Liste des cartes résultant de la recherche
    @Published var cards: [Card] = []
    
    /// Indicateur de chargement en cours
    @Published var isLoading = false
    
    /// Mode d'affichage de la liste des cartes
    @Published var displayMode: SearchCardDisplayMode {
        didSet {
            UserPreferencesService.shared.searchCardDisplayMode = displayMode
        }
    }

    private let searchCards: SearchCardsUseCase

    /// Initialise le ViewModel avec le use case de recherche.
    /// - Parameter searchCards: Use case responsable de la recherche de cartes
    init(searchCards: SearchCardsUseCase) {
        self.searchCards = searchCards
        self.displayMode = UserPreferencesService.shared.searchCardDisplayMode
    }

    /// Exécute une recherche de cartes basée sur une requête textuelle.
    /// Met à jour automatiquement les propriétés `cards` et `isLoading`.
    /// - Parameter query: Texte de recherche pour filtrer les cartes
    func search(query: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            cards = try await searchCards.execute(query: query)
        } catch {
            print("Error: \(error)")
        }
    }
}
