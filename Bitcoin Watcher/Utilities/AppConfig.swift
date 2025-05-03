//
//  AppConfig.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 10.04.25.
//

import Foundation

struct AppConfig {
    static let refetchInterval: TimeInterval = 60 // Seconds
    static let historyDuration: Int = 14 // Days
    static let currentCurrency: Currency = .euro
}
