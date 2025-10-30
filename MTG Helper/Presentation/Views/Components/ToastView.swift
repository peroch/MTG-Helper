//
//  ToastView.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 30/10/2025.
//

import SwiftUI

/// Vue affichant un message toast temporaire en overlay.
struct ToastView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.body)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black.opacity(0.8))
            )
            .shadow(radius: 8)
    }
}

/// Modificateur de vue pour afficher un toast.
struct ToastModifier: ViewModifier {
    @Binding var toast: ToastMessage?
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if let toast = toast {
                    ToastView(message: toast.message)
                        .padding(.top, 60)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration) {
                                withAnimation {
                                    self.toast = nil
                                }
                            }
                        }
                }
            }
            .animation(.spring(), value: toast?.id)
    }
}

extension View {
    /// Ajoute un toast à la vue.
    /// - Parameter toast: Binding vers le message toast optionnel
    /// - Returns: La vue modifiée avec le toast
    func toast(_ toast: Binding<ToastMessage?>) -> some View {
        modifier(ToastModifier(toast: toast))
    }
}
