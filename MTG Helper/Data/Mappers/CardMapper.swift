//
//  CardMapper.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 25/08/2025.
//

import Foundation

/// Mapper responsable de la conversion entre DTOs et entités Domain.
/// Transforme les CardDTO (provenant de l'API) en objets Card (entités métier).
enum CardMapper {
    
    /// Convertit un CardDTO en entité Card.
    /// Gère les cartes double-face en extrayant les données de la première face si nécessaire.
    /// - Parameters:
    ///   - dto: DTO représentant la carte depuis l'API Scryfall
    ///   - rulings: Tableau des rulings associés à la carte (par défaut vide)
    /// - Returns: Entité Card utilisable dans le domain layer
    static func map(_ dto: CardDTO, rulings: [String] = []) -> Card {
        let faceOracleText = dto.cardFaces?.first?.oracleText
        let faceImageUrl = dto.cardFaces?.first?.imageUris?.normal
        
        // Extrait uniquement la partie avant le "-" dans typeLine
        let processedTypeLine = extractTypeBeforeDash(from: dto.typeLine)
        
        return Card(
            id: dto.id,
            name: dto.name,
            oracleText: dto.oracleText ?? faceOracleText,
            imageUrl: dto.imageUris?.normal ?? faceImageUrl,
            rulings: rulings,
            manaCost: dto.manaCost,
            typeLine: processedTypeLine
        )
    }
    
    /// Ordre de priorité des types de cartes pour la classification.
    /// Une carte avec plusieurs types sera classée selon le type de priorité la plus haute.
    private static let typePriority: [String] = [
        "Creature",
        "Land",
        "Instant",
        "Sorcery",
        "Enchantment",
        "Artifact",
        "Planeswalker"
    ]
    
    /// Extrait la partie avant le tiret "-" dans une typeLine et détermine le type prioritaire.
    /// Si la carte a plusieurs types (ex: "Enchantment Creature"), retourne celui avec la priorité la plus haute.
    /// - Parameter typeLine: La typeLine complète (ex: "Legendary Creature — Human Artificer")
    /// - Returns: Le type avec la priorité la plus haute (ex: "Creature"), ou la typeLine complète si aucun type connu
    private static func extractTypeBeforeDash(from typeLine: String?) -> String? {
        guard let typeLine = typeLine else { return nil }
        
        // Extrait la partie avant le tiret
        var beforeDash = typeLine
        if let dashRange = typeLine.range(of: "—") {
            beforeDash = String(typeLine[..<dashRange.lowerBound]).trimmingCharacters(in: .whitespaces)
        } else if let dashRange = typeLine.range(of: "-") {
            beforeDash = String(typeLine[..<dashRange.lowerBound]).trimmingCharacters(in: .whitespaces)
        }
        
        // Recherche le type avec la priorité la plus haute
        for priorityType in typePriority {
            if beforeDash.contains(priorityType) {
                return priorityType
            }
        }
        
        // Si aucun type connu n'est trouvé, retourne la partie avant le tiret
        return beforeDash.isEmpty ? typeLine : beforeDash
    }
}
