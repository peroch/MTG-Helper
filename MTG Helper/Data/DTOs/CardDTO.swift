//
//  CardDTO.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 25/08/2025.
//

import Foundation

/// DTO représentant la réponse de recherche de cartes depuis l'API Scryfall.
/// Encapsule un tableau de CardDTO.
struct CardSearchResponseDTO: Decodable {
    let data: [CardDTO]
}

/// DTO représentant une carte Magic depuis l'API Scryfall.
/// Contient toutes les données brutes de la carte avant mapping vers l'entité Domain.
struct CardDTO: Decodable {
    let id: String
    let name: String
    let oracleText: String?
    let imageUris: ImageUrisDTO?
    let cardFaces: [CardFaceDTO]?
    let manaCost: String?
    let typeLine: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case oracleText = "oracle_text"
        case imageUris = "image_uris"
        case cardFaces = "card_faces"
        case manaCost = "mana_cost"
        case typeLine = "type_line"
    }
}

/// DTO représentant les URLs d'images d'une carte.
struct ImageUrisDTO: Decodable {
    let normal: String?
}

/// DTO représentant une face de carte (pour les cartes double-face).
struct CardFaceDTO: Decodable {
    let oracleText: String?
    let imageUris: ImageUrisDTO?
    
    enum CodingKeys: String, CodingKey {
        case oracleText = "oracle_text"
        case imageUris = "image_uris"
    }
}

/// DTO représentant la réponse contenant les rulings d'une carte.
struct CardRulingsResponseDTO: Decodable {
    let data: [CardRulingDTO]
}

/// DTO représentant un ruling (décision de juge) pour une carte.
struct CardRulingDTO: Decodable {
    let comment: String
}
