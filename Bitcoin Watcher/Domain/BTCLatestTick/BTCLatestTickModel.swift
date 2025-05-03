//
//  BTCLatestTickModel.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation

struct BTCLatestTickModel: Equatable {
    let value: Double
    let valueFlag: ValueFlag
    let lastUpdate: Date
}

extension BTCLatestTickModel {
    enum ValueFlag: Equatable {
        case up
        case down
        case unChanged
    }
}
