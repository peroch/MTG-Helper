//
//  ToastView.swift
//  CoreUI
//
//  Created by Dan PEROCHEAU on 30/10/2025.
//

import SwiftUI

/// Modèle représentant un message toast à afficher temporairement.
public struct ToastMessage: Identifiable, Equatable {
    public let id = UUID()
    public let message: String
    public let duration: TimeInterval
    
    public init(message: String, duration: TimeInterval = 3.0) {
        self.message = message
        self.duration = duration
    }
}

/// Vue affichant un message toast temporaire.
public struct ToastView: View {
    let message: String
    
    public init(message: String) {
        self.message = message
    }
    
    public var body: some View {
        Text(message)
            .font(.callout)
            .padding()
            .background(Color.black.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 4)
    }
}

/// ViewModifier pour afficher un toast automatiquement.
public struct ToastModifier: ViewModifier {
    @Binding var toast: ToastMessage?
    
    public init(toast: Binding<ToastMessage?>) {
        self._toast = toast
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            
            if let toast = toast {
                VStack {
                    Spacer()
                    ToastView(message: toast.message)
                        .padding(.bottom, 50)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration) {
                                withAnimation {
                                    self.toast = nil
                                }
                            }
                        }
                }
                .animation(.spring(), value: toast.id)
            }
        }
    }
}

public extension View {
    /// Ajoute un toast à la vue.
    func toast(_ toast: Binding<ToastMessage?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}
