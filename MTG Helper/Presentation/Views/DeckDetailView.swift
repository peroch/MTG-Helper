//
//  DeckDetailView.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 15/09/2025.
//

import SwiftUI

struct DeckDetailView: View {
    let id: String
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Détail du deck")
                .font(.title)
            Text("Deck ID: \(id)")
                .foregroundColor(.secondary)
        }
        .navigationTitle("Deck Detail")
    }
}
