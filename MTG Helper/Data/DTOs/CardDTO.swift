//
//  CardDTO.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 25/08/2025.
//

struct CardSearchResponseDTO: Decodable {
    let data: [CardDTO]
}

struct CardDTO: Decodable {
    let id: String
    let name: String
    let imageUris: ImageUrisDTO?

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageUris = "image_uris"
    }
}

struct ImageUrisDTO: Decodable {
    let normal: String?
}
