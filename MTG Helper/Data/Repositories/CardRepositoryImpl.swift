//
//  CardRepositoryImpl.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 25/08/2025.
//

final class CardRepositoryImpl: CardRepository {
    private let api: ScryfallAPI
    
    init(api: ScryfallAPI) {
        self.api = api
    }
    
    func search(query: String) async throws -> [Card] {
        try await api.searchCards(query: query)
    }
    
    func getDetail(id: String) async throws -> Card {
        try await api.getCardDetails(id: id)
    }
}
