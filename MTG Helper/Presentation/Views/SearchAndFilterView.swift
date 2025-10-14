//
//  SearchAndFilterView.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 25/08/2025.
//

import SwiftUI

struct SearchAndFilterView: View {
    @State private var query: String = ""
    @State private var showResults = false
    
    var onSearch: (String) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Recherche de cartes")
                .font(.title)
                .bold()
            
            TextField("Ex: dragon", text: $query)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button("Rechercher") {
                if !query.isEmpty {
                    onSearch(query)
                    showResults = true
                }
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .padding()
    }
}

