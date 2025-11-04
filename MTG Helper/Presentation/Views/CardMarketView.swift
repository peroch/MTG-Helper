//
//  CardMarketView.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 04/11/2025.
//

import SwiftUI

/// Main CardMarket view with tabs for Spoilers and Search
struct CardMarketView: View {
    @StateObject private var spoilersViewModel: CardMarketSpoilersViewModel
    @StateObject private var searchViewModel: CardMarketSearchViewModel
    
    @State private var selectedTab = 0
    
    init(
        spoilersViewModel: CardMarketSpoilersViewModel,
        searchViewModel: CardMarketSearchViewModel
    ) {
        _spoilersViewModel = StateObject(wrappedValue: spoilersViewModel)
        _searchViewModel = StateObject(wrappedValue: searchViewModel)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Main content (blurred when overlay is shown)
                VStack(spacing: 0) {
                    // Custom tab selector
                    Picker("Tab", selection: $selectedTab) {
                        Text("New Spoilers").tag(0)
                        Text("Search").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding()
                    
                    // Content
                    TabView(selection: $selectedTab) {
                        SpoilersTabView(viewModel: spoilersViewModel)
                            .tag(0)
                        
                        SearchTabView(viewModel: searchViewModel)
                            .tag(1)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
                .blur(radius: 10)
                .disabled(true)
                
                // Coming soon overlay
                ComingSoonOverlayView(
                    title: "CardMarket API Required",
                    message: "This feature requires CardMarket API credentials to display card prices.\n\nTo enable this feature:\n1. Create an app at cardmarket.com\n2. Configure OAuth credentials\n3. Restart the app",
                    icon: "eurosign.circle"
                )
            }
            .navigationTitle("CardMarket")
        }
    }
}

// MARK: - Spoilers Tab

private struct SpoilersTabView: View {
    @ObservedObject var viewModel: CardMarketSpoilersViewModel
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView("Loading spoilers...")
            } else if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    Text(errorMessage)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                    Button("Retry") {
                        Task {
                            await viewModel.loadSpoilers()
                        }
                    }
                }
                .padding()
            } else if viewModel.cardsWithPrices.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "sparkles")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("No spoilers available")
                        .foregroundColor(.secondary)
                    Button("Load Spoilers") {
                        Task {
                            await viewModel.loadSpoilers()
                        }
                    }
                }
            } else {
                List(viewModel.cardsWithPrices) { cardWithPrice in
                    CardWithPriceRowView(cardWithPrice: cardWithPrice)
                }
                .refreshable {
                    await viewModel.refresh()
                }
            }
        }
        .task {
            if viewModel.cardsWithPrices.isEmpty {
                await viewModel.loadSpoilers()
            }
        }
    }
}

// MARK: - Search Tab

private struct SearchTabView: View {
    @ObservedObject var viewModel: CardMarketSearchViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            HStack {
                TextField("Search cards...", text: $viewModel.searchQuery)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.search)
                    .onSubmit {
                        Task {
                            await viewModel.search()
                        }
                    }
                
                Button("Search") {
                    Task {
                        await viewModel.search()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.searchQuery.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding()
            
            // Results
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Searching...")
                } else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text(errorMessage)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                } else if viewModel.cardsWithPrices.isEmpty && !viewModel.searchQuery.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("No results found")
                            .foregroundColor(.secondary)
                    }
                } else if viewModel.searchQuery.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("Enter a card name to search")
                            .foregroundColor(.secondary)
                    }
                } else {
                    List(viewModel.cardsWithPrices) { cardWithPrice in
                        CardWithPriceRowView(cardWithPrice: cardWithPrice)
                    }
                }
            }
        }
    }
}
