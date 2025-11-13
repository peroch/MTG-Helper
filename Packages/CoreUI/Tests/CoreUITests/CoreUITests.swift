//
//  CoreUITests.swift
//  CoreUI
//
//  Created by Dan PEROCHEAU on 06/11/2025.
//

import XCTest
@testable import CoreUI

final class CoreUITests: XCTestCase {
    
    // MARK: - ManaSymbolHelper Tests
    
    func testParseManaCost() {
        let manaCost = "{2}{U}{U}"
        let symbols = ManaSymbolHelper.parseManaCost(manaCost)
        
        XCTAssertEqual(symbols.count, 3)
        XCTAssertEqual(symbols[0], "2")
        XCTAssertEqual(symbols[1], "U")
        XCTAssertEqual(symbols[2], "U")
    }
    
    func testParseComplexManaCost() {
        let manaCost = "{X}{R}{W}{B}"
        let symbols = ManaSymbolHelper.parseManaCost(manaCost)
        
        XCTAssertEqual(symbols.count, 4)
        XCTAssertEqual(symbols[0], "X")
        XCTAssertEqual(symbols[1], "R")
        XCTAssertEqual(symbols[2], "W")
        XCTAssertEqual(symbols[3], "B")
    }
    
    func testParseEmptyManaCost() {
        let manaCost = ""
        let symbols = ManaSymbolHelper.parseManaCost(manaCost)
        
        XCTAssertEqual(symbols.count, 0)
    }
    
    func testSupportedSymbols() {
        XCTAssertTrue(ManaSymbolHelper.supportedSymbols.contains("W"))
        XCTAssertTrue(ManaSymbolHelper.supportedSymbols.contains("U"))
        XCTAssertTrue(ManaSymbolHelper.supportedSymbols.contains("B"))
        XCTAssertTrue(ManaSymbolHelper.supportedSymbols.contains("R"))
        XCTAssertTrue(ManaSymbolHelper.supportedSymbols.contains("G"))
        XCTAssertTrue(ManaSymbolHelper.supportedSymbols.contains("C"))
        XCTAssertTrue(ManaSymbolHelper.supportedSymbols.contains("X"))
        XCTAssertTrue(ManaSymbolHelper.supportedSymbols.contains("0"))
        XCTAssertTrue(ManaSymbolHelper.supportedSymbols.contains("10"))
    }
    
    // MARK: - ToastMessage Tests
    
    func testToastMessageCreation() {
        let message = ToastMessage(message: "Test message")
        
        XCTAssertEqual(message.message, "Test message")
        XCTAssertEqual(message.duration, 3.0)
    }
    
    func testToastMessageCustomDuration() {
        let message = ToastMessage(message: "Test", duration: 5.0)
        
        XCTAssertEqual(message.message, "Test")
        XCTAssertEqual(message.duration, 5.0)
    }
    
    func testToastMessageEquality() {
        let message1 = ToastMessage(message: "Test")
        let message2 = ToastMessage(message: "Test")
        
        // Les messages ont des IDs différents, donc ne sont pas égaux
        XCTAssertNotEqual(message1, message2)
    }
    
    // MARK: - Theme Tests
    
    func testThemeColorsExist() {
        // Vérifier que les couleurs du thème sont accessibles
        let _ = Theme.Colors.primary
        let _ = Theme.Colors.secondary
        let _ = Theme.Colors.background
        let _ = Theme.Colors.textPrimary
        let _ = Theme.Colors.textSecondary
    }
    
    func testThemeSpacingValues() {
        XCTAssertEqual(Theme.Spacing.xs, 8)
        XCTAssertEqual(Theme.Spacing.sm, 16)
        XCTAssertEqual(Theme.Spacing.md, 24)
        XCTAssertEqual(Theme.Spacing.lg, 32)
        XCTAssertEqual(Theme.Spacing.xl, 48)
    }
    
    func testThemeCornerRadiusValues() {
        XCTAssertEqual(Theme.CornerRadius.small, 8)
        XCTAssertEqual(Theme.CornerRadius.medium, 16)
        XCTAssertEqual(Theme.CornerRadius.large, 24)
    }
}
