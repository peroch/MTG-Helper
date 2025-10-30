//
//  UserPreferencesServiceTests.swift
//  MTG HelperTests
//
//  Tests unitaires pour UserPreferencesService.
//

import XCTest
@testable import MTG_Helper

final class UserPreferencesServiceTests: XCTestCase {
    
    var sut: UserPreferencesService!
    var mockUserDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        
        // Utiliser un UserDefaults en mémoire pour les tests
        mockUserDefaults = UserDefaults(suiteName: "TestDefaults")!
        mockUserDefaults.removePersistentDomain(forName: "TestDefaults")
        
        sut = UserPreferencesService(userDefaults: mockUserDefaults)
    }
    
    override func tearDown() {
        mockUserDefaults.removePersistentDomain(forName: "TestDefaults")
        mockUserDefaults = nil
        sut = nil
        
        super.tearDown()
    }
    
    // MARK: - Deck Display Mode Tests
    
    func testDeckListDisplayMode_DefaultValue() {
        // When - Lecture de la valeur par défaut
        let mode = sut.deckListDisplayMode
        
        // Then
        XCTAssertEqual(mode, .list, "Le mode par défaut devrait être .list")
    }
    
    func testDeckListDisplayMode_SetAndGet() {
        // When - Définir le mode grille
        sut.deckListDisplayMode = .grid
        
        // Then
        XCTAssertEqual(sut.deckListDisplayMode, .grid)
        
        // When - Définir le mode liste
        sut.deckListDisplayMode = .list
        
        // Then
        XCTAssertEqual(sut.deckListDisplayMode, .list)
    }
    
    func testDeckListDisplayMode_Persistence() {
        // Given
        sut.deckListDisplayMode = .grid
        
        // When - Créer une nouvelle instance avec les mêmes UserDefaults
        let newService = UserPreferencesService(userDefaults: mockUserDefaults)
        
        // Then
        XCTAssertEqual(newService.deckListDisplayMode, .grid, "La préférence devrait persister")
    }
    
    // MARK: - Last Used Deck Format Tests
    
    func testLastUsedDeckFormat_DefaultValue() {
        // When
        let format = sut.lastUsedDeckFormat
        
        // Then
        XCTAssertNil(format, "Par défaut, aucun format ne devrait être défini")
    }
    
    func testLastUsedDeckFormat_SetAndGet() {
        // When
        sut.lastUsedDeckFormat = "commander"
        
        // Then
        XCTAssertEqual(sut.lastUsedDeckFormat, "commander")
    }
    
    func testLastUsedDeckFormat_SetNil() {
        // Given
        sut.lastUsedDeckFormat = "standard"
        
        // When
        sut.lastUsedDeckFormat = nil
        
        // Then
        XCTAssertNil(sut.lastUsedDeckFormat)
    }
    
    func testLastUsedDeckFormat_Persistence() {
        // Given
        sut.lastUsedDeckFormat = "modern"
        
        // When
        let newService = UserPreferencesService(userDefaults: mockUserDefaults)
        
        // Then
        XCTAssertEqual(newService.lastUsedDeckFormat, "modern")
    }
    
    // MARK: - Mana Symbols Display Tests
    
    func testShowManaSymbols_DefaultValue() {
        // When
        let showSymbols = sut.showManaSymbols
        
        // Then
        XCTAssertTrue(showSymbols, "Par défaut, les symboles de mana devraient être affichés")
    }
    
    func testShowManaSymbols_SetAndGet() {
        // When
        sut.showManaSymbols = false
        
        // Then
        XCTAssertFalse(sut.showManaSymbols)
        
        // When
        sut.showManaSymbols = true
        
        // Then
        XCTAssertTrue(sut.showManaSymbols)
    }
    
    func testShowManaSymbols_Persistence() {
        // Given
        sut.showManaSymbols = false
        
        // When
        let newService = UserPreferencesService(userDefaults: mockUserDefaults)
        
        // Then
        XCTAssertFalse(newService.showManaSymbols)
    }
    
    // MARK: - Reset Tests
    
    func testResetToDefaults() {
        // Given
        sut.deckListDisplayMode = .grid
        sut.searchCardDisplayMode = .compact
        sut.deckCardDisplayMode = .compact
        sut.lastUsedDeckFormat = "commander"
        sut.showManaSymbols = false
        
        // When
        sut.resetToDefaults()
        
        // Then
        XCTAssertEqual(sut.deckListDisplayMode, .list)
        XCTAssertEqual(sut.searchCardDisplayMode, .detailed)
        XCTAssertEqual(sut.deckCardDisplayMode, .detailed)
        XCTAssertNil(sut.lastUsedDeckFormat)
        XCTAssertTrue(sut.showManaSymbols)
    }
    
    func testResetToDefaults_Persistence() {
        // Given
        sut.deckListDisplayMode = .grid
        sut.searchCardDisplayMode = .compact
        sut.deckCardDisplayMode = .compact
        sut.lastUsedDeckFormat = "vintage"
        sut.showManaSymbols = false
        
        // When
        sut.resetToDefaults()
        
        // Then
        let newService = UserPreferencesService(userDefaults: mockUserDefaults)
        XCTAssertEqual(newService.deckListDisplayMode, .list)
        XCTAssertEqual(newService.searchCardDisplayMode, .detailed)
        XCTAssertEqual(newService.deckCardDisplayMode, .detailed)
        XCTAssertNil(newService.lastUsedDeckFormat)
        XCTAssertTrue(newService.showManaSymbols)
    }
    
    // MARK: - Search Card Display Mode Tests
    
    func testSearchCardDisplayMode_DefaultValue() {
        // When
        let mode = sut.searchCardDisplayMode
        
        // Then
        XCTAssertEqual(mode, .detailed, "Default mode should be .detailed")
    }
    
    func testSearchCardDisplayMode_SetAndGet() {
        // When
        sut.searchCardDisplayMode = .compact
        
        // Then
        XCTAssertEqual(sut.searchCardDisplayMode, .compact)
        
        // When
        sut.searchCardDisplayMode = .detailed
        
        // Then
        XCTAssertEqual(sut.searchCardDisplayMode, .detailed)
    }
    
    func testSearchCardDisplayMode_Persistence() {
        // Given
        sut.searchCardDisplayMode = .compact
        
        // When
        let newService = UserPreferencesService(userDefaults: mockUserDefaults)
        
        // Then
        XCTAssertEqual(newService.searchCardDisplayMode, .compact, "Preference should persist")
    }
    
    // MARK: - Deck Card Display Mode Tests
    
    func testDeckCardDisplayMode_DefaultValue() {
        // When
        let mode = sut.deckCardDisplayMode
        
        // Then
        XCTAssertEqual(mode, .detailed, "Default mode should be .detailed")
    }
    
    func testDeckCardDisplayMode_SetAndGet() {
        // When
        sut.deckCardDisplayMode = .compact
        
        // Then
        XCTAssertEqual(sut.deckCardDisplayMode, .compact)
        
        // When
        sut.deckCardDisplayMode = .detailed
        
        // Then
        XCTAssertEqual(sut.deckCardDisplayMode, .detailed)
    }
    
    func testDeckCardDisplayMode_Persistence() {
        // Given
        sut.deckCardDisplayMode = .compact
        
        // When
        let newService = UserPreferencesService(userDefaults: mockUserDefaults)
        
        // Then
        XCTAssertEqual(newService.deckCardDisplayMode, .compact, "Preference should persist")
    }
    
    // MARK: - DeckListDisplayMode Enum Tests
    
    func testDeckListDisplayMode_DisplayName() {
        XCTAssertEqual(DeckListDisplayMode.list.displayName, "List")
        XCTAssertEqual(DeckListDisplayMode.grid.displayName, "Grid")
    }
    
    func testDeckListDisplayMode_RawValue() {
        XCTAssertEqual(DeckListDisplayMode.list.rawValue, "list")
        XCTAssertEqual(DeckListDisplayMode.grid.rawValue, "grid")
    }
    
    func testDeckListDisplayMode_InitFromRawValue() {
        XCTAssertEqual(DeckListDisplayMode(rawValue: "list"), .list)
        XCTAssertEqual(DeckListDisplayMode(rawValue: "grid"), .grid)
        XCTAssertNil(DeckListDisplayMode(rawValue: "invalid"))
    }
    
    // MARK: - SearchCardDisplayMode Enum Tests
    
    func testSearchCardDisplayMode_DisplayName() {
        XCTAssertEqual(SearchCardDisplayMode.detailed.displayName, "Detailed")
        XCTAssertEqual(SearchCardDisplayMode.compact.displayName, "Compact")
    }
    
    func testSearchCardDisplayMode_RawValue() {
        XCTAssertEqual(SearchCardDisplayMode.detailed.rawValue, "detailed")
        XCTAssertEqual(SearchCardDisplayMode.compact.rawValue, "compact")
    }
    
    func testSearchCardDisplayMode_InitFromRawValue() {
        XCTAssertEqual(SearchCardDisplayMode(rawValue: "detailed"), .detailed)
        XCTAssertEqual(SearchCardDisplayMode(rawValue: "compact"), .compact)
        XCTAssertNil(SearchCardDisplayMode(rawValue: "invalid"))
    }
    
    // MARK: - DeckCardDisplayMode Enum Tests
    
    func testDeckCardDisplayMode_DisplayName() {
        XCTAssertEqual(DeckCardDisplayMode.detailed.displayName, "Detailed")
        XCTAssertEqual(DeckCardDisplayMode.compact.displayName, "Compact")
    }
    
    func testDeckCardDisplayMode_RawValue() {
        XCTAssertEqual(DeckCardDisplayMode.detailed.rawValue, "detailed")
        XCTAssertEqual(DeckCardDisplayMode.compact.rawValue, "compact")
    }
    
    func testDeckCardDisplayMode_InitFromRawValue() {
        XCTAssertEqual(DeckCardDisplayMode(rawValue: "detailed"), .detailed)
        XCTAssertEqual(DeckCardDisplayMode(rawValue: "compact"), .compact)
        XCTAssertNil(DeckCardDisplayMode(rawValue: "invalid"))
    }
}
