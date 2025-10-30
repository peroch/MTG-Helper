//
//  DeckSettingsView.swift
//  MTG Helper
//
//  Created by Cline on 30/10/2025.
//

import SwiftUI

struct DeckSettingsView: View {
    @StateObject private var viewModel: DeckSettingsViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: DeckSettingsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Nom du deck", text: $viewModel.name)
                        .textFieldStyle(.plain)
                } header: {
                    Text("Nom")
                }
                
                Section {
                    Picker("Format", selection: $viewModel.format) {
                        ForEach(DeckFormat.allCases, id: \.self) { format in
                            Text(format.displayName)
                                .tag(format)
                        }
                    }
                    .pickerStyle(.menu)
                } header: {
                    Text("Format")
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Suggestions de formats supplémentaires")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("Vous souhaitez d'autres formats ? N'hésitez pas à les suggérer.")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("À venir")
                }
            }
            .navigationTitle("Paramètres du deck")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        viewModel.cancelChanges()
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Enregistrer") {
                        Task {
                            await viewModel.saveDeck()
                            if viewModel.showSuccessMessage {
                                dismiss()
                            }
                        }
                    }
                    .disabled(!viewModel.hasChanges || viewModel.isLoading)
                }
            }
            .alert("Erreur", isPresented: .constant(viewModel.error != nil)) {
                Button("OK") {
                    viewModel.error = nil
                }
            } message: {
                if let error = viewModel.error {
                    Text(error)
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
                }
            }
        }
    }
}
