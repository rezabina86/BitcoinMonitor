//
//  Currency.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

enum Currency: String, Equatable {
    case euro = "EUR"
    
    var symbol: String {
        switch self {
        case .euro:
            return "€"
        }
    }
}
