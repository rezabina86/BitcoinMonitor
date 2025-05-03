//
//  BTCPriceRepositoryMock.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation
@testable import Bitcoin_Watcher

final class BTCPriceRepositoryMock: BTCPriceRepositoryType {
    
    enum Call: Equatable {
        case prices
    }
    
    func prices() async throws -> BTCPriceModel {
        calls.append(.prices)
        switch pricesReturnValue {
        case let .success(model):
            return model
        case let .failure(error):
            throw error
        }
    }
    
    var calls: [Call] = []
    var pricesReturnValue: Result<BTCPriceModel, BTCPriceRepositoryErrorMock> = .success(.fake())
}

enum BTCPriceRepositoryErrorMock: Error {
    case mockError
}
