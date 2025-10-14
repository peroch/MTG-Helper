//
//  CoordinatorRootView.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 22/07/2025.
//

import SwiftUI

struct CoordinatorRootView: View {
    @StateObject private var searchCoordinator = SearchCoordinator(repository: CardRepositoryImpl(api: ScryfallAPIClient()))
    @StateObject private var decksCoordinator = DecksCoordinator()
    
    var body: some View {
        TabView {
            searchCoordinator.makeView()
                .tabItem {
                    Label("Recherche", systemImage: "magnifyingglass")
                }
            
            decksCoordinator.makeView()
                .tabItem {
                    Label("Decks", systemImage: "star.fill")
                }
        }
    }
}
