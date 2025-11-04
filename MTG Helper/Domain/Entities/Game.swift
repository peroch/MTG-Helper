//
//  Game.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 30/10/2025.
//

import Foundation

/// Type de partie Magic
enum GameFormat: Hashable {
    case standard
    case commander
    case custom(startingLife: Int)
    
    /// Nombre de points de vie de départ pour ce format
    var startingLife: Int {
        switch self {
        case .standard:
            return 20
        case .commander:
            return 40
        case .custom(let life):
            return life
        }
    }
}

/// Représente une partie de Magic en cours
struct Game: Identifiable {
    let id: UUID
    var format: GameFormat
    var players: [Player]
    var startDate: Date
    
    /// Initialise une nouvelle partie
    /// - Parameters:
    ///   - id: Identifiant unique de la partie
    ///   - format: Format de jeu
    ///   - playerCount: Nombre de joueurs
    init(id: UUID = UUID(), format: GameFormat, playerCount: Int) {
        self.id = id
        self.format = format
        self.startDate = Date()
        
        self.players = (1...playerCount).map { index in
            Player(
                name: "Joueur \(index)",
                life: format.startingLife
            )
        }
    }
    
    /// Retourne les joueurs encore en jeu
    var activePlayers: [Player] {
        return players.filter { !$0.hasLost }
    }
    
    /// Indique si la partie est terminée
    var isGameOver: Bool {
        return activePlayers.count <= 1
    }
    
    /// Retourne le gagnant de la partie si elle est terminée
    var winner: Player? {
        guard isGameOver, let winner = activePlayers.first else {
            return nil
        }
        return winner
    }
}
