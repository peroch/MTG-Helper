//
//  Item.swift
//  MTG Helper
//
//  Created by Dan PEROCHEAU on 22/07/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
