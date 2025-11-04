//
//  DeckFormView.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 28/10/2025.
//

import SwiftUI
import SwiftData

struct DeckFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var deckName: String = ""
    @State private var selectedFormat: DeckFormat = .standard
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Information")) {
                    TextField("Deck name", text: $deckName)
                    
                    Picker("Format", selection: $selectedFormat) {
                        ForEach(DeckFormat.allCases, id: \.self) { format in
                            Text(format.displayName).tag(format)
                        }
                    }
                }
            }
            .navigationTitle("New Deck")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveDeck()
                    }
                    .disabled(deckName.isEmpty)
                }
            }
        }
    }
    
    private func saveDeck() {
        let newDeck = Deck(name: deckName, format: selectedFormat)
        modelContext.insert(newDeck)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Error saving deck: \(error)")
        }
    }
}

#Preview {
    DeckFormView()
}
