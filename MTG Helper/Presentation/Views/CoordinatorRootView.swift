//
//  CoordinatorRootView.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 22/07/2025.
//

import SwiftUI
import SwiftData

struct CoordinatorRootView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        CoordinatorRootContentView(modelContext: modelContext)
    }
}

struct CoordinatorRootContentView: View {
    @StateObject private var searchCoordinator: SearchCoordinator
    @StateObject private var decksCoordinator: DecksCoordinator
    
    init(modelContext: ModelContext) {
        let cardRepository = CardRepositoryImpl(api: ScryfallAPIClient())
        let deckRepository = DeckRepositoryImpl(modelContext: modelContext)
        
        _searchCoordinator = StateObject(wrappedValue: SearchCoordinator(
            cardRepository: cardRepository,
            deckRepository: deckRepository
        ))
        
        _decksCoordinator = StateObject(wrappedValue: DecksCoordinator(
            cardRepository: cardRepository,
            deckRepository: deckRepository
        ))
    }
    
    var body: some View {
        TabView {
            searchCoordinator.makeView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            decksCoordinator.makeView()
                .tabItem {
                    Label("Decks", systemImage: "star.fill")
                }
        }
    }
}
