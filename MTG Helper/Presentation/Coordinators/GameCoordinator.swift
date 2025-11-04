//
//  GameCoordinator.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 30/10/2025.
//

import SwiftUI

/// Coordinator responsable de la navigation dans le module de suivi de partie
final class GameCoordinator: ObservableObject {
    
    /// Crée la vue principale du suivi de partie
    /// - Returns: Vue SwiftUI configurée
    @MainActor func makeView() -> some View {
        let viewModel = GameViewModel()
        return GameView(viewModel: viewModel)
    }
}
