//
//  BTCLatestTickAPIEntity.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation

struct BTCLatestTickAPIEntity: Decodable, Equatable {
    let price: Price?
    
    enum RootKeys: String, CodingKey {
        case data = "Data"
    }
    
    enum DataKeys: String, CodingKey {
        case price = "BTC-EUR"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let dataContainer = try container.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        price = try dataContainer.decodeIfPresent(Price.self, forKey: .price)
    }
    
    init(price: BTCLatestTickAPIEntity.Price?) {
        self.price = price
    }
}

extension BTCLatestTickAPIEntity {
    
    struct Price: Equatable, Decodable {
        let value: Double
        let valueFlag: ValueFlag
        let lastUpdate: Double
        
        enum CodingKeys: String, CodingKey {
            case value = "VALUE"
            case valueFlag = "VALUE_FLAG"
            case lastUpdate = "VALUE_LAST_UPDATE_TS"
        }
    }
}

extension BTCLatestTickAPIEntity.Price {
    enum ValueFlag: String, Equatable, Decodable {
        case up = "UP"
        case down = "DOWN"
        case unChanged = "UNCHANGED"
    }
}
