//
//  ComingSoonOverlayView.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 04/11/2025.
//

import SwiftUI

/// Overlay view that displays a "coming soon" message over blurred content
struct ComingSoonOverlayView: View {
    let title: String
    let message: String
    let icon: String
    
    init(
        title: String = "Coming Soon",
        message: String,
        icon: String = "hourglass"
    ) {
        self.title = title
        self.message = message
        self.icon = icon
    }
    
    var body: some View {
        ZStack {
            // Blur background
            Color.black.opacity(0.3)
                .blur(radius: 2)
            
            // Message card
            VStack(spacing: 24) {
                Image(systemName: icon)
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                VStack(spacing: 12) {
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(message)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(radius: 20)
            )
            .padding(40)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ComingSoonOverlayView(
        message: "This feature is currently under development and will be available soon."
    )
}
