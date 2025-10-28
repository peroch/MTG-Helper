//
//  CardDetailViewModel.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 25/08/2025.
//

import Foundation

/// ViewModel gérant l'affichage des détails d'une carte.
/// Encapsule l'état de chargement, les erreurs et les données de la carte.
@MainActor
final class CardDetailViewModel: ObservableObject {
    /// Carte actuellement chargée (nil si pas encore chargée)
    @Published private(set) var card: Card?
    
    /// Indicateur de chargement en cours
    @Published private(set) var isLoading = false
    
    /// Message d'erreur si le chargement échoue
    @Published private(set) var error: String?
    
    private let getCardDetail: GetCardDetailUseCase
    
    /// Initialise le ViewModel avec le use case de récupération de détails.
    /// - Parameter getCardDetail: Use case responsable de la récupération des détails d'une carte
    init(getCardDetail: GetCardDetailUseCase) {
        self.getCardDetail = getCardDetail
    }
    
    /// Charge les détails d'une carte spécifique via son identifiant.
    /// Met à jour automatiquement les propriétés `card`, `isLoading` et `error`.
    /// - Parameter id: Identifiant unique de la carte à charger
    func load(id: String) async {
        isLoading = true
        error = nil
        do {
            let result = try await getCardDetail.execute(id: id)
            card = result
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
}
