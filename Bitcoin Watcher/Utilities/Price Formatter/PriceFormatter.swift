//
//  PriceFormatter.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 10.04.25.
//

import Foundation

protocol PriceFormatterType {
    func formate(amount: Double, currency: Currency) -> String
}

struct PriceFormatter: PriceFormatterType {
    func formate(amount: Double, currency: Currency) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency.rawValue

        if let currencyString = formatter.string(from: NSNumber(value: amount)) {
            return currencyString
        }
        
        return ""
    }
}
