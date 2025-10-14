//
//  CardMapper.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 25/08/2025.
//

enum CardMapper {
    static func map(_ dto: CardDTO) -> Card {
        Card(
            id: dto.id,
            name: dto.name,
            imageUrl: dto.imageUris?.normal
        )
    }
}
