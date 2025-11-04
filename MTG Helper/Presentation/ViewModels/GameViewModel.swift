//
//  GameViewModel.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 30/10/2025.
//

import Foundation

/// ViewModel responsable de la gestion d'une partie de Magic
@MainActor
final class GameViewModel: ObservableObject {
    @Published var game: Game?
    @Published var showNewGameSheet = false
    @Published var showWinnerAlert = false
    
    /// Crée une nouvelle partie
    /// - Parameters:
    ///   - format: Format de jeu
    ///   - playerCount: Nombre de joueurs
    func startNewGame(format: GameFormat, playerCount: Int) {
        game = Game(format: format, playerCount: playerCount)
        showNewGameSheet = false
    }
    
    /// Modifie les points de vie d'un joueur
    /// - Parameters:
    ///   - playerId: Identifiant du joueur
    ///   - amount: Montant à ajouter (positif) ou retirer (négatif)
    func adjustLife(for playerId: UUID, by amount: Int) {
        guard let game = game,
              let playerIndex = game.players.firstIndex(where: { $0.id == playerId }) else {
            return
        }
        
        self.game?.players[playerIndex].life += amount
        
        checkGameOver()
    }
    
    /// Définit directement les points de vie d'un joueur
    /// - Parameters:
    ///   - playerId: Identifiant du joueur
    ///   - newLife: Nouvelle valeur de points de vie
    func setLife(for playerId: UUID, to newLife: Int) {
        guard let game = game,
              let playerIndex = game.players.firstIndex(where: { $0.id == playerId }) else {
            return
        }
        
        self.game?.players[playerIndex].life = newLife
        
        checkGameOver()
    }
    
    /// Modifie les marqueurs de poison d'un joueur
    /// - Parameters:
    ///   - playerId: Identifiant du joueur
    ///   - amount: Montant à ajouter (positif) ou retirer (négatif)
    func adjustPoison(for playerId: UUID, by amount: Int) {
        guard let game = game,
              let playerIndex = game.players.firstIndex(where: { $0.id == playerId }) else {
            return
        }
        
        let newPoison = max(0, game.players[playerIndex].poisonCounters + amount)
        self.game?.players[playerIndex].poisonCounters = newPoison
        
        checkGameOver()
    }
    
    /// Modifie le nom d'un joueur
    /// - Parameters:
    ///   - playerId: Identifiant du joueur
    ///   - newName: Nouveau nom
    func updatePlayerName(for playerId: UUID, to newName: String) {
        guard let game = game,
              let playerIndex = game.players.firstIndex(where: { $0.id == playerId }) else {
            return
        }
        
        self.game?.players[playerIndex].name = newName
    }
    
    /// Réinitialise les points de vie de tous les joueurs
    func resetAllLife() {
        guard let game = game else { return }
        
        let startingLife = game.format.startingLife
        
        for index in game.players.indices {
            self.game?.players[index].life = startingLife
            self.game?.players[index].poisonCounters = 0
        }
    }
    
    /// Termine la partie en cours
    func endGame() {
        game = nil
        showWinnerAlert = false
    }
    
    /// Vérifie si la partie est terminée et affiche le gagnant
    private func checkGameOver() {
        guard let game = game, game.isGameOver else {
            return
        }
        
        showWinnerAlert = true
    }
}
