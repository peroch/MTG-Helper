//
//  DeckCard.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 28/10/2025.
//

import Foundation
import SwiftData

/// Entité représentant une carte dans un deck.
/// Permet de gérer la relation entre les decks et les cartes.
@Model
final class DeckCard {
    /// Identifiant unique de l'entrée
    var id: UUID
    
    /// Identifiant de la carte (correspond à Card.id)
    var cardId: String
    
    /// Nom de la carte (stocké pour faciliter l'affichage)
    var cardName: String
    
    /// URL de l'image de la carte (stocké pour faciliter l'affichage)
    var cardImageUrl: String?
    
    /// Coût en mana de la carte (stocké pour faciliter l'affichage)
    var cardManaCost: String?

    var cardTypeLine: String?
    
    /// Référence vers le deck parent
    var deck: Deck?
    
    /// Date d'ajout de la carte au deck
    var addedAt: Date
    
    init(cardId: String, cardName: String, cardImageUrl: String?, cardManaCost: String?, cardTypeLine: String?) {
        self.id = UUID()
        self.cardId = cardId
        self.cardName = cardName
        self.cardImageUrl = cardImageUrl
        self.cardManaCost = cardManaCost
        self.cardTypeLine = cardTypeLine
        self.addedAt = Date()
    }
}
