//
//  CardDetailViewModel.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 25/08/2025.
//

import Foundation

@MainActor
final class CardDetailViewModel: ObservableObject {
    @Published private(set) var card: Card?
    @Published private(set) var isLoading = false
    @Published private(set) var error: String?
    
    private let getCardDetail: GetCardDetailUseCase
    
    init(getCardDetail: GetCardDetailUseCase) {
        self.getCardDetail = getCardDetail
    }
    
    func load(id: String) async {
        isLoading = true
        error = nil
        do {
            let result = try await getCardDetail.execute(id: id)
            card = result
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
}
