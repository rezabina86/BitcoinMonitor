//
//  PriceFormatterMock.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 10.04.25.
//

import Foundation
@testable import Bitcoin_Watcher

final class PriceFormatterMock: PriceFormatterType {
    enum Call: Equatable {
        case format(amount: Double, currency: Currency)
    }
    
    func formate(amount: Double, currency: Currency) -> String {
        calls.append(.format(amount: amount, currency: currency))
        return formatReturnValue
    }
    
    var calls: [Call] = []
    var formatReturnValue: String = ""
}
