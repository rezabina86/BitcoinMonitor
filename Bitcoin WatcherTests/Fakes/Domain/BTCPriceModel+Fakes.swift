//
//  BTCPriceModel+Fakes.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation
@testable import Bitcoin_Watcher

extension BTCPriceModel {
    static func fake(prices: [Price] = [.fake()]) -> Self {
        .init(prices: prices)
    }
}

extension BTCPriceModel.Price {
    static func fake(date: Date = Date(timeIntervalSince1970: 1743033600),
                     open: Double = 80918,
                     high: Double = 80918,
                     low: Double = 80918,
                     close: Double = 80918,
                     volume: Double = 176014) -> Self {
        .init(date: date,
              open: open,
              high: high,
              low: low,
              close: close,
              volume: volume)
    }
}
