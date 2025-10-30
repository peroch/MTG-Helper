//
//  DeckSettingsViewModel.swift
//  MTG Helper
//
//  Created by Cline on 30/10/2025.
//

import Foundation

/// ViewModel pour gérer les paramètres d'un deck.
@MainActor
final class DeckSettingsViewModel: ObservableObject {
    @Published var name: String
    @Published var format: DeckFormat
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var showSuccessMessage: Bool = false
    
    private let deck: Deck
    private let updateDeckUseCase: UpdateDeckUseCase
    
    init(deck: Deck, updateDeckUseCase: UpdateDeckUseCase) {
        self.deck = deck
        self.updateDeckUseCase = updateDeckUseCase
        self.name = deck.name
        self.format = deck.format
    }
    
    /// Sauvegarde les modifications du deck.
    func saveDeck() async {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            error = "Le nom du deck ne peut pas être vide"
            return
        }
        
        isLoading = true
        error = nil
        
        do {
            try await updateDeckUseCase.execute(deck: deck, name: name, format: format)
            showSuccessMessage = true
        } catch {
            self.error = "Erreur lors de la sauvegarde: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    /// Annule les modifications et restaure les valeurs d'origine.
    func cancelChanges() {
        name = deck.name
        format = deck.format
        error = nil
    }
    
    /// Indique si des modifications ont été effectuées.
    var hasChanges: Bool {
        return name != deck.name || format != deck.format
    }
}
