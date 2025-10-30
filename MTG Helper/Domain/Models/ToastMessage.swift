//
//  ToastMessage.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 30/10/2025.
//

import Foundation

/// Modèle représentant un message toast à afficher temporairement.
struct ToastMessage: Identifiable, Equatable {
    let id = UUID()
    let message: String
    let duration: TimeInterval
    
    init(message: String, duration: TimeInterval = 3.0) {
        self.message = message
        self.duration = duration
    }
}
