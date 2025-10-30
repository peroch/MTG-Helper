//
//  CardDetailView.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 25/08/2025.
//

import SwiftUI

struct CardDetailView: View {
    @StateObject private var viewModel: CardDetailViewModel
    let cardId: String
    
    init(viewModel: CardDetailViewModel, cardId: String) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.cardId = cardId
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let card = viewModel.card {
                ScrollView {
                    VStack(spacing: 16) {
                        if let imageUrlString = card.imageUrl, let imageUrl = URL(string: imageUrlString) {
                            AsyncImage(url: imageUrl) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(12)
                                        .shadow(radius: 6)
                                case .failure:
                                    Text("Image unavailable")
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(maxHeight: 400)
                        }
                            
                        VStack(spacing: 8) {
                            Text(card.name)
                                .font(.title)
                                .bold()
                            
                            if let manaCost = card.manaCost, !manaCost.isEmpty {
                                ManaCostView(manaCost: manaCost, symbolSize: 20)
                            }
                        }
                        
                        if let oracleText = card.oracleText {
                            Text(oracleText)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                        }
                        
                        if !viewModel.decksContainingCard.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Present in Decks")
                                    .font(.headline)
                                    .bold()
                                
                                ForEach(viewModel.decksContainingCard) { deck in
                                    HStack {
                                        Text(deck.name)
                                            .font(.body)
                                        Spacer()
                                        Text(deck.format.displayName)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical)
                        }
                        
                        if !card.rulings.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Rulings")
                                    .font(.headline)
                                    .bold()
                                
                                ForEach(card.rulings, id: \.self) { ruling in
                                    Text("• \(ruling)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Spacer()
                    }
                    .padding()
                }
            } else if let error = viewModel.error {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            } else {
                EmptyView()
            }
        }
        .task {
            await viewModel.load(id: cardId)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    Task {
                        await viewModel.loadAvailableDecks()
                        viewModel.showDeckPicker = true
                    }
                }) {
                    Label("Add to Deck", systemImage: "plus.circle")
                }
            }
        }
        .sheet(isPresented: $viewModel.showDeckPicker) {
            DeckPickerView(
                decks: viewModel.availableDecks,
                onSelectDeck: { deck in
                    Task {
                        await viewModel.addToDeck(deck)
                    }
                }
            )
        }
        .toast($viewModel.toastMessage)
    }
}

struct DeckPickerView: View {
    let decks: [Deck]
    let onSelectDeck: (Deck) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                if decks.isEmpty {
                    Text("No decks available. Create a deck first.")
                        .foregroundColor(.secondary)
                        .italic()
                } else {
                    ForEach(decks) { deck in
                        Button(action: {
                            onSelectDeck(deck)
                            dismiss()
                        }) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(deck.name)
                                    .font(.headline)
                                Text(deck.format.displayName)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Select Deck")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
