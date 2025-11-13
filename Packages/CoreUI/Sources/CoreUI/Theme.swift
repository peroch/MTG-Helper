//
//  Theme.swift
//  CoreUI
//
//  Created by Dan PEROCHEAU on 25/07/2025.
//

import SwiftUI

public struct Theme {
    
    public struct Colors {
        public static let primary: Color = .blue
        public static let secondary: Color = .gray
        public static let background: Color = .white
        public static let textPrimary: Color = .black
        public static let textSecondary: Color = .gray
    }
    
    public struct Typography {
        public static let title = Font.system(size: 24, weight: .bold, design: .rounded)
        public static let subtitle = Font.system(size: 18, weight: .semibold, design: .default)
        public static let body = Font.system(size: 16, weight: .regular)
        public static let caption = Font.system(size: 14, weight: .light)
    }
    
    public struct Spacing {
        public static let xs: CGFloat = 8
        public static let sm: CGFloat = 16
        public static let md: CGFloat = 24
        public static let lg: CGFloat = 32
        public static let xl: CGFloat = 48
    }
    
    public struct CornerRadius {
        public static let small: CGFloat = 8
        public static let medium: CGFloat = 16
        public static let large: CGFloat = 24
    }
    
    public struct PrimaryButtonStyle: ButtonStyle {
        public init() {}
        
        public func makeBody(configuration: Configuration) -> some View {
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
