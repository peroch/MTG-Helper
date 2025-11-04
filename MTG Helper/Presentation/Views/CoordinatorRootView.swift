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
    @StateObject private var gameCoordinator: GameCoordinator
    @StateObject private var cardMarketCoordinator: CardMarketCoordinator
    
    init(modelContext: ModelContext) {
        let cardRepository = CardRepositoryImpl(api: ScryfallAPIClient())
        let deckRepository = DeckRepositoryImpl(modelContext: modelContext)
        let cardMarketRepository = CardMarketRepositoryImpl(apiClient: CardMarketAPIClient())
        
        _searchCoordinator = StateObject(wrappedValue: SearchCoordinator(
            cardRepository: cardRepository,
            deckRepository: deckRepository
        ))
        
        _decksCoordinator = StateObject(wrappedValue: DecksCoordinator(
            cardRepository: cardRepository,
            deckRepository: deckRepository
        ))
        
        _gameCoordinator = StateObject(wrappedValue: GameCoordinator())
        
        _cardMarketCoordinator = StateObject(wrappedValue: CardMarketCoordinator(
            cardRepository: cardRepository,
            cardMarketRepository: cardMarketRepository
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
            
            cardMarketCoordinator.makeView()
                .tabItem {
                    Label("CardMarket", systemImage: "eurosign.circle.fill")
                }
            
            gameCoordinator.makeView()
                .tabItem {
                    Label("Play", systemImage: "gamecontroller.fill")
                }
        }
    }
}
