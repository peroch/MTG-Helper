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
    /// - Parameter dto: DTO représentant la carte depuis l'API Scryfall
    /// - Returns: Entité Card utilisable dans le domain layer
    static func map(_ dto: CardDTO) -> Card {
        let faceOracleText = dto.cardFaces?.first?.oracleText
        let faceImageUrl = dto.cardFaces?.first?.imageUris?.normal
        return Card(
            id: dto.id,
            name: dto.name,
            oracleText: dto.oracleText ?? faceOracleText,
            imageUrl: dto.imageUris?.normal ?? faceImageUrl,
            rulings: [],
            manaCost: dto.manaCost
        )
    }
}
