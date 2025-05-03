//
//  BTCPriceAPIEntity.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation

struct BTCPriceAPIEntity: Decodable, Equatable {
    let prices: [BTCPriceAPIEntity.Price]
    
    enum CodingKeys: String, CodingKey {
        case prices = "Data"
    }
}

extension BTCPriceAPIEntity {
    struct Price: Decodable, Equatable {
        let timestamp: Double
        let open: Double
        let high: Double
        let low: Double
        let close: Double
        let volume: Double
        
        enum CodingKeys: String, CodingKey {
            case timestamp = "TIMESTAMP"
            case open = "OPEN"
            case high = "HIGH"
            case low = "LOW"
            case close = "CLOSE"
            case volume = "VOLUME"
        }
    }
}
