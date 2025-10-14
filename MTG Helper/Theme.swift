//
//  Theme.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 25/07/2025.
//

import SwiftUI

struct Theme {
    
    struct Colors {
        static let primary: Color = .blue
        static let secondary: Color = .gray
        static let background: Color = .white
        static let textPrimary: Color = .black
        static let textSecondary: Color = .gray
    }
    
    struct Typography {
        static let title = Font.system(size: 24, weight: .bold, design: .rounded)
        static let subtitle = Font.system(size: 18, weight: .semibold, design: .default)
        static let body = Font.system(size: 16, weight: .regular)
        static let caption = Font.system(size: 14, weight: .light)
    }
    
    struct Spacing {
        static let xs: CGFloat = 8
        static let sm: CGFloat = 16
        static let md: CGFloat = 24
        static let lg: CGFloat = 32
        static let xl: CGFloat = 48
    }
    
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
    }
    
    struct PrimaryButtonStyle: ButtonStyle {
            func makeBody(configuration: Configuration) -> some View {
                configuration.label
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Theme.Colors.primary)
                    .foregroundColor(.white)
                    .cornerRadius(Theme.CornerRadius.medium)
                    .opacity(configuration.isPressed ? 0.8 : 1)
            }
        }
}
