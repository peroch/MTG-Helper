//
//  Main.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 25/08/2025.
//

import SwiftUI
import SwiftData

@main
struct MTG_HelperApp: App {
    var body: some Scene {
        WindowGroup {
            CoordinatorRootView()
        }
        .modelContainer(for: [Deck.self])
    }
}
