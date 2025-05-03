//
//  BTCPriceModel.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation

struct BTCPriceModel: Equatable {
    let prices: [BTCPriceModel.Price]
}

extension BTCPriceModel {
    struct Price: Equatable {
        let date: Date
        let open: Double
        let high: Double
        let low: Double
        let close: Double
        let volume: Double
    }
}
