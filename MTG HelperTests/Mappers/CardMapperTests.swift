//
//  CardMapperTests.swift
//  MTG HelperTests
//
//  Created by Dan PEROCHEAU on 30/10/2025.
//

import XCTest
@testable import MTG_Helper

/// Tests unitaires pour CardMapper.
final class CardMapperTests: XCTestCase {
    
    // MARK: - Tests de mapping basique
    
    func testMapCardDTO_WithAllFields_ReturnsCompleteCard() {
        // Given
        let dto = CardDTO(
            id: "test-id",
            name: "Test Card",
            oracleText: "Test oracle text",
            imageUris: ImageUrisDTO(normal: "https://example.com/image.jpg"),
            cardFaces: nil,
            manaCost: "{2}{U}",
            typeLine: "Instant"
        )
        
        // When
        let card = CardMapper.map(dto)
        
        // Then
        XCTAssertEqual(card.id, "test-id")
        XCTAssertEqual(card.name, "Test Card")
        XCTAssertEqual(card.oracleText, "Test oracle text")
        XCTAssertEqual(card.imageUrl, "https://example.com/image.jpg")
        XCTAssertEqual(card.manaCost, "{2}{U}")
        XCTAssertEqual(card.typeLine, "Instant")
        XCTAssertTrue(card.rulings.isEmpty)
    }
    
    func testMapCardDTO_WithRulings_IncludesRulingsInCard() {
        // Given
        let dto = CardDTO(
            id: "test-id",
            name: "Test Card",
            oracleText: "Test oracle text",
            imageUris: ImageUrisDTO(normal: "https://example.com/image.jpg"),
            cardFaces: nil,
            manaCost: "{1}{R}",
            typeLine: "Sorcery"
        )
        let rulings = [
            "This is the first ruling",
            "This is the second ruling"
        ]
        
        // When
        let card = CardMapper.map(dto, rulings: rulings)
        
        // Then
        XCTAssertEqual(card.rulings.count, 2)
        XCTAssertEqual(card.rulings[0], "This is the first ruling")
        XCTAssertEqual(card.rulings[1], "This is the second ruling")
    }
    
    func testMapCardDTO_WithoutRulings_ReturnsEmptyRulingsArray() {
        // Given
        let dto = CardDTO(
            id: "test-id",
            name: "Test Card",
            oracleText: nil,
            imageUris: nil,
            cardFaces: nil,
            manaCost: nil,
            typeLine: nil
        )
        
        // When
        let card = CardMapper.map(dto)
        
        // Then
        XCTAssertTrue(card.rulings.isEmpty)
    }
    
    // MARK: - Tests de cartes double-face
    
    func testMapCardDTO_WithCardFaces_UsesFirstFaceData() {
        // Given
        let dto = CardDTO(
            id: "test-id",
            name: "Double Face Card",
            oracleText: nil,
            imageUris: nil,
            cardFaces: [
                CardFaceDTO(
                    oracleText: "First face oracle text",
                    imageUris: ImageUrisDTO(normal: "https://example.com/face1.jpg")
                ),
                CardFaceDTO(
                    oracleText: "Second face oracle text",
                    imageUris: ImageUrisDTO(normal: "https://example.com/face2.jpg")
                )
            ],
            manaCost: "{3}{G}",
            typeLine: "Creature — Werewolf"
        )
        
        // When
        let card = CardMapper.map(dto)
        
        // Then
        XCTAssertEqual(card.oracleText, "First face oracle text")
        XCTAssertEqual(card.imageUrl, "https://example.com/face1.jpg")
    }
    
    func testMapCardDTO_WithBothImageUris_PrefersMainImageUri() {
        // Given
        let dto = CardDTO(
            id: "test-id",
            name: "Test Card",
            oracleText: "Main oracle text",
            imageUris: ImageUrisDTO(normal: "https://example.com/main.jpg"),
            cardFaces: [
                CardFaceDTO(
                    oracleText: "Face oracle text",
                    imageUris: ImageUrisDTO(normal: "https://example.com/face.jpg")
                )
            ],
            manaCost: "{1}",
            typeLine: "Artifact"
        )
        
        // When
        let card = CardMapper.map(dto)
        
        // Then
        XCTAssertEqual(card.imageUrl, "https://example.com/main.jpg")
        XCTAssertEqual(card.oracleText, "Main oracle text")
    }
    
    // MARK: - Tests d'extraction du type
    
    func testMapCardDTO_WithCreatureType_ExtractsCreature() {
        // Given
        let dto = CardDTO(
            id: "test-id",
            name: "Test Creature",
            oracleText: nil,
            imageUris: nil,
            cardFaces: nil,
            manaCost: "{2}{G}",
            typeLine: "Creature — Elf Warrior"
        )
        
        // When
        let card = CardMapper.map(dto)
        
        // Then
        XCTAssertEqual(card.typeLine, "Creature")
    }
    
    func testMapCardDTO_WithEnchantmentCreature_ExtractsCreature() {
        // Given
        let dto = CardDTO(
            id: "test-id",
            name: "Test Enchantment Creature",
            oracleText: nil,
            imageUris: nil,
            cardFaces: nil,
            manaCost: "{1}{W}",
            typeLine: "Enchantment Creature — God"
        )
        
        // When
        let card = CardMapper.map(dto)
        
        // Then
        XCTAssertEqual(card.typeLine, "Creature")
    }
    
    func testMapCardDTO_WithLandType_ExtractsLand() {
        // Given
        let dto = CardDTO(
            id: "test-id",
            name: "Test Land",
            oracleText: nil,
            imageUris: nil,
            cardFaces: nil,
            manaCost: nil,
            typeLine: "Land — Forest"
        )
        
        // When
        let card = CardMapper.map(dto)
        
        // Then
        XCTAssertEqual(card.typeLine, "Land")
    }
    
    func testMapCardDTO_WithInstantType_ExtractsInstant() {
        // Given
        let dto = CardDTO(
            id: "test-id",
            name: "Test Instant",
            oracleText: nil,
            imageUris: nil,
            cardFaces: nil,
            manaCost: "{U}",
            typeLine: "Instant"
        )
        
        // When
        let card = CardMapper.map(dto)
        
        // Then
        XCTAssertEqual(card.typeLine, "Instant")
    }
    
    func testMapCardDTO_WithSorceryType_ExtractsSorcery() {
        // Given
        let dto = CardDTO(
            id: "test-id",
            name: "Test Sorcery",
            oracleText: nil,
            imageUris: nil,
            cardFaces: nil,
            manaCost: "{1}{R}",
            typeLine: "Sorcery"
        )
        
        // When
        let card = CardMapper.map(dto)
        
        // Then
        XCTAssertEqual(card.typeLine, "Sorcery")
    }
    
    func testMapCardDTO_WithArtifactType_ExtractsArtifact() {
        // Given
        let dto = CardDTO(
            id: "test-id",
            name: "Test Artifact",
            oracleText: nil,
            imageUris: nil,
            cardFaces: nil,
            manaCost: "{3}",
            typeLine: "Artifact — Equipment"
        )
        
        // When
        let card = CardMapper.map(dto)
        
        // Then
        XCTAssertEqual(card.typeLine, "Artifact")
    }
    
    func testMapCardDTO_WithPlaneswalkerType_ExtractsPlaneswalker() {
        // Given
        let dto = CardDTO(
            id: "test-id",
            name: "Test Planeswalker",
            oracleText: nil,
            imageUris: nil,
            cardFaces: nil,
            manaCost: "{3}{U}{U}",
            typeLine: "Legendary Planeswalker — Jace"
        )
        
        // When
        let card = CardMapper.map(dto)
        
        // Then
        XCTAssertEqual(card.typeLine, "Planeswalker")
    }
    
    func testMapCardDTO_WithUnknownType_ReturnsFullTypeBeforeDash() {
        // Given
        let dto = CardDTO(
            id: "test-id",
            name: "Test Unknown",
            oracleText: nil,
            imageUris: nil,
            cardFaces: nil,
            manaCost: nil,
            typeLine: "Legendary Kindred — Elves"
        )
        
        // When
        let card = CardMapper.map(dto)
        
        // Then
        XCTAssertEqual(card.typeLine, "Legendary Kindred")
    }
    
    func testMapCardDTO_WithNilTypeLine_ReturnsNil() {
        // Given
        let dto = CardDTO(
            id: "test-id",
            name: "Test Card",
            oracleText: nil,
            imageUris: nil,
            cardFaces: nil,
            manaCost: nil,
            typeLine: nil
        )
        
        // When
        let card = CardMapper.map(dto)
        
        // Then
        XCTAssertNil(card.typeLine)
    }
}
