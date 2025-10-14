//
//  ScryfallAPIClient.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 25/08/2025.
//

import Foundation

protocol ScryfallAPI {
    func searchCards(query: String) async throws -> [Card]
    func getCardDetails(id: String) async throws -> Card
}

final class ScryfallAPIClient: ScryfallAPI {
    private let baseURL = "https://api.scryfall.com"
    
    func searchCards(query: String) async throws -> [Card] {
        let url = URL(string: "\(baseURL)/cards/search?q=\(query)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let dto = try JSONDecoder().decode(CardSearchResponseDTO.self, from: data)
        return dto.data.map(CardMapper.map)
    }
    
    func getCardDetails(id: String) async throws -> Card {
        let url = URL(string: "\(baseURL)/cards/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let dto = try JSONDecoder().decode(CardDTO.self, from: data)
        return CardMapper.map(dto)
    }
}
