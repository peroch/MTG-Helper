//
//  ComingSoonOverlayView.swift
//  CoreUI
//
//  Created by Dan PEROCHEAU on 06/11/2025.
//

import SwiftUI

/// Vue overlay pour indiquer qu'une fonctionnalité est à venir.
public struct ComingSoonOverlayView: View {
    let title: String
    let message: String
    let icon: String
    
    public init(title: String = "Coming Soon", message: String = "This feature is under development", icon: String = "hammer.fill") {
        self.title = title
        self.message = message
        self.icon = icon
    }
    
    public var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(message)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray.opacity(0.9))
            )
            .padding(40)
        }
    }
}
