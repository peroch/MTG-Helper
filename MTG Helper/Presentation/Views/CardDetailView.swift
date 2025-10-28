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
    }
}
