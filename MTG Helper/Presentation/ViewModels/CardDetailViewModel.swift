//
//  CardDetailViewModel.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 25/08/2025.
//

import Foundation
import CoreUI

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
    
    /// Liste de tous les decks disponibles
    @Published private(set) var availableDecks: [Deck] = []
    
    /// Liste des decks contenant la carte actuelle
    @Published private(set) var decksContainingCard: [Deck] = []
    
    /// Indicateur d'affichage du sélecteur de deck
    @Published var showDeckPicker = false
    
    /// Message toast à afficher
    @Published var toastMessage: CoreUI.ToastMessage?
    
    private let getCardDetail: GetCardDetailUseCase
    private let deckRepository: DeckRepository
    private let addCardToDeck: AddCardToDeckUseCase
    private let getDecksContainingCard: GetDecksContainingCardUseCase
    
    /// Initialise le ViewModel avec les use cases nécessaires.
    /// - Parameters:
    ///   - getCardDetail: Use case responsable de la récupération des détails d'une carte
    ///   - deckRepository: Repository pour accéder aux decks
    ///   - addCardToDeck: Use case pour ajouter une carte à un deck
    ///   - getDecksContainingCard: Use case pour récupérer les decks contenant une carte
    init(
        getCardDetail: GetCardDetailUseCase,
        deckRepository: DeckRepository,
        addCardToDeck: AddCardToDeckUseCase,
        getDecksContainingCard: GetDecksContainingCardUseCase
    ) {
        self.getCardDetail = getCardDetail
        self.deckRepository = deckRepository
        self.addCardToDeck = addCardToDeck
        self.getDecksContainingCard = getDecksContainingCard
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
            await loadDecksContainingCard()
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
    
    /// Charge tous les decks disponibles pour affichage dans le sélecteur.
    func loadAvailableDecks() async {
        do {
            availableDecks = try await deckRepository.getAllDecks()
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    /// Charge la liste des decks contenant la carte actuelle.
    func loadDecksContainingCard() async {
        guard let card = card else { return }
        
        do {
            decksContainingCard = try await getDecksContainingCard.execute(cardId: card.id)
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    /// Ajoute la carte actuelle à un deck spécifié.
    /// - Parameter deck: Le deck auquel ajouter la carte
    func addToDeck(_ deck: Deck) async {
        guard let card = card else { return }
        
        do {
            try await addCardToDeck.execute(card: card, to: deck)
            await loadDecksContainingCard()
            showDeckPicker = false
            
            // Afficher un toast de confirmation
            toastMessage = ToastMessage(
                message: "\(card.name) added to \(deck.name) - \(deck.format)"
            )
        } catch {
            self.error = error.localizedDescription
        }
    }
}
