//
//  Player.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 30/10/2025.
//

import Foundation

/// Représente un joueur dans une partie de Magic
struct Player: Identifiable, Equatable {
    let id: UUID
    var name: String
    var life: Int
    var poisonCounters: Int
    
    /// Initialise un nouveau joueur
    /// - Parameters:
    ///   - id: Identifiant unique du joueur
    ///   - name: Nom du joueur
    ///   - life: Points de vie de départ
    ///   - poisonCounters: Nombre de marqueurs de poison
    init(id: UUID = UUID(), name: String, life: Int = 20, poisonCounters: Int = 0) {
        self.id = id
        self.name = name
        self.life = life
        self.poisonCounters = poisonCounters
    }
    
    /// Indique si le joueur a perdu la partie
    var hasLost: Bool {
        return life <= 0 || poisonCounters >= 10
    }
}
