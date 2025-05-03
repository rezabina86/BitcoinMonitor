//
//  BTCLatestTickModel+Fakes.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation
@testable import Bitcoin_Watcher

extension BTCLatestTickModel {
    static func fake(value: Double = 70_000,
                     valueFlag: ValueFlag = .down,
                     lastUpdate: Date = .init(timeIntervalSince1970: 1744209548)) -> Self {
        .init(value: value,
              valueFlag: valueFlag,
              lastUpdate: lastUpdate)
    }
}
