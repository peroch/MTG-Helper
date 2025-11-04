//
//  CardMarketProductDTO.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 04/11/2025.
//

import Foundation

/// DTO for CardMarket product response
struct CardMarketProductDTO: Codable {
    let product: ProductData
    
    struct ProductData: Codable {
        let idProduct: Int
        let name: String
        let categoryName: String?
        let expansion: String?
        let priceGuide: PriceGuide?
        
        enum CodingKeys: String, CodingKey {
            case idProduct
            case name
            case categoryName
            case expansion
            case priceGuide
        }
    }
    
    struct PriceGuide: Codable {
        let SELL: Double?
        let LOW: Double?
        let LOWEX: Double?
        let LOWFOIL: Double?
        let AVG: Double?
        let TREND: Double?
        
        enum CodingKeys: String, CodingKey {
            case SELL, LOW, LOWEX, LOWFOIL, AVG, TREND
        }
    }
}

/// DTO for CardMarket search response
struct CardMarketSearchResponseDTO: Codable {
    let product: [CardMarketProductDTO.ProductData]
}
