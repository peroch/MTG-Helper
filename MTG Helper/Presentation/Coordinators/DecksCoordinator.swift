//
//  DecksCoordinator.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 15/09/2025.
//

import SwiftUI

final class DecksCoordinator: ObservableObject {
    @Published var path: [Destination] = []
    
    enum Destination: Hashable {
        case deckDetail(id: UUID)
    }

    func makeView() -> some View {
        DecksView()
    }
}
