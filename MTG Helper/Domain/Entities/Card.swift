//
//  Card.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 25/08/2025.
//

import Foundation

/// Entité représentant une carte Magic: The Gathering.
/// Contient les informations essentielles d'une carte pour l'affichage et la manipulation.
struct Card: Identifiable {
    /// Identifiant unique de la carte
    var id: String
    
    /// Nom de la carte
    var name: String
    
    /// Texte Oracle de la carte (règles et effets)
    var oracleText: String?
    
    /// URL de l'image de la carte
    var imageUrl: String?
    
    /// Liste des rulings (décisions de juges) associés à la carte
    var rulings: [String]
    
    /// Coût en mana de la carte (format texte avec symboles)
    var manaCost: String?

    var typeLine: String?
}

/// Entité représentant un ruling (décision de juge) pour une carte.
/// Utilisée pour afficher les clarifications officielles sur les règles.
struct CardRuling: Identifiable {
    /// Identifiant unique généré automatiquement
    let id = UUID()
    
    /// Commentaire ou texte du ruling
    let comment: String
}
