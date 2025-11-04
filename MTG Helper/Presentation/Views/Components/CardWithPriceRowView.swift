//
//  CardWithPriceRowView.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 04/11/2025.
//

import SwiftUI

/// Row view displaying a card with its CardMarket price
struct CardWithPriceRowView: View {
    let cardWithPrice: CardWithPrice
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Card image
            AsyncImage(url: URL(string: cardWithPrice.card.imageUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    }
            }
            .frame(width: 60, height: 84)
            .cornerRadius(4)
            
            // Card details
            VStack(alignment: .leading, spacing: 4) {
                Text(cardWithPrice.card.name)
                    .font(.headline)
                    .lineLimit(2)
                
                if let typeLine = cardWithPrice.card.typeLine {
                    Text(typeLine)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Price information
                if let price = cardWithPrice.price {
                    priceView(price)
                } else {
                    Text("Price unavailable")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .italic()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 4)
    }
    
    @ViewBuilder
    private func priceView(_ price: CardMarketPrice) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            if let lowestPrice = price.lowestPrice {
                HStack(spacing: 4) {
                    Text("Lowest:")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(formatPrice(lowestPrice, currency: price.currency))
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
            }
            
            if let trendPrice = price.trendPrice {
                HStack(spacing: 4) {
                    Text("Trend:")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(formatPrice(trendPrice, currency: price.currency))
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
        }
    }
    
    private func formatPrice(_ price: Double, currency: String) -> String {
        String(format: "%.2f %@", price, currency)
    }
}
