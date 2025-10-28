//
//  ManaSymbolHelper.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 24/10/2025.
//

import SwiftUI
import Foundation

struct ManaSymbolHelper {
    
    // Liste des symboles de mana supportés
    static let supportedSymbols: Set<String> = [
        // Couleurs de base
        "W", "U", "B", "R", "G", "C",
        
        // Mana générique
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
        "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
        
        // Mana variable
        "X", "Y", "Z",
        
        // Symboles spéciaux
        "T", "Q", "S", "P", "H"
    ]
    
    /// Parse un coût de mana et retourne les symboles individuels
    static func parseManaCost(_ manaCost: String) -> [String] {
        // Regex pour extraire les symboles entre accolades
        let pattern = "\\{([^}]+)\\}"
        let regex = try! NSRegularExpression(pattern: pattern)
        let matches = regex.matches(in: manaCost, range: NSRange(manaCost.startIndex..., in: manaCost))
        
        return matches.compactMap { match in
            if let range = Range(match.range(at: 1), in: manaCost) {
                return String(manaCost[range])
            }
            return nil
        }
    }
    
    /// Obtient l'image locale pour un symbole de mana
    static func getLocalImage(for symbol: String) -> String? {
        guard supportedSymbols.contains(symbol) else { return nil }
        return "symbols/\(symbol).png"
    }
    
    /// Obtient l'URL de fallback pour un symbole de mana (si l'image locale n'existe pas)
    static func getFallbackURL(for symbol: String) -> String? {
        return "https://svgs.scryfall.io/card-symbols/\(symbol).svg"
    }
}

// Vue SwiftUI pour afficher un symbole de mana
struct ManaSymbolView: View {
    let symbol: String
    let size: CGFloat
    
    init(symbol: String, size: CGFloat = 16) {
        self.symbol = symbol
        self.size = size
    }
    
    var body: some View {
        // Charger l'image depuis l'asset catalog
        if let image = UIImage(named: symbol) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
        } else if let fallbackURLString = ManaSymbolHelper.getFallbackURL(for: symbol),
                  let url = URL(string: fallbackURLString) {
            // Fallback vers l'URL distante si l'image locale n'existe pas
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
            } placeholder: {
                placeholderView
            }
        } else {
            placeholderView
        }
    }
    
    private var placeholderView: some View {
        Text(symbol)
            .font(.system(size: size * 0.7, weight: .bold))
            .foregroundColor(.secondary)
            .frame(width: size, height: size)
            .background(Color.gray.opacity(0.2))
            .clipShape(Circle())
    }
}

// Vue pour afficher un coût de mana complet
struct ManaCostView: View {
    let manaCost: String
    let symbolSize: CGFloat
    
    init(manaCost: String, symbolSize: CGFloat = 16) {
        self.manaCost = manaCost
        self.symbolSize = symbolSize
    }
    
    var body: some View {
        HStack(spacing: 2) {
            let symbols = ManaSymbolHelper.parseManaCost(manaCost)
            ForEach(symbols, id: \.self) { symbol in
                ManaSymbolView(symbol: symbol, size: symbolSize)
            }
        }
    }
}
