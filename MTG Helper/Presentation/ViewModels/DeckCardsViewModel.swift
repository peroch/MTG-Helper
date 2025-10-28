//
//  DeckCardsViewModel.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 28/10/2025.
//

import Foundation

/// ViewModel gérant l'affichage de la liste des cartes d'un deck.
@MainActor
final class DeckCardsViewModel: ObservableObject {
    /// Liste des cartes du deck
    @Published private(set) var cards: [DeckCard] = []
    
    /// Indicateur de chargement en cours
    @Published private(set) var isLoading = false
    
    /// Message d'erreur si le chargement échoue
    @Published private(set) var error: String?
    
    /// Mode d'affichage de la liste des cartes
    @Published var displayMode: DisplayMode = .detailed
    
    enum DisplayMode {
        case detailed
        case compact
    }
    
    private let deckRepository: DeckRepository
    private let removeCardFromDeck: RemoveCardFromDeckUseCase
    
    /// Initialise le ViewModel avec les dépendances nécessaires.
    /// - Parameters:
    ///   - deckRepository: Repository pour accéder aux decks
    ///   - removeCardFromDeck: Use case pour retirer une carte d'un deck
    init(
        deckRepository: DeckRepository,
        removeCardFromDeck: RemoveCardFromDeckUseCase
    ) {
        self.deckRepository = deckRepository
        self.removeCardFromDeck = removeCardFromDeck
    }
    
    /// Charge les cartes d'un deck spécifique.
    /// - Parameter deck: Le deck dont on veut charger les cartes
    func loadCards(for deck: Deck) async {
        isLoading = true
        error = nil
        do {
            cards = try await deckRepository.getCards(for: deck)
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
    
    /// Retire une carte du deck.
    /// - Parameters:
    ///   - deckCard: La carte à retirer
    ///   - deck: Le deck source
    func removeCard(_ deckCard: DeckCard, from deck: Deck) async {
        do {
            try await removeCardFromDeck.execute(deckCard: deckCard, from: deck)
            await loadCards(for: deck)
        } catch {
            self.error = error.localizedDescription
        }
    }
}
