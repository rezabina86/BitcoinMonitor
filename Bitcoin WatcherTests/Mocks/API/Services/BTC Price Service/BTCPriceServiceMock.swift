//
//  BTCPriceServiceMock.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation
@testable import Bitcoin_Watcher

final class BTCPriceServiceMock: BTCPriceServiceType {
    
    enum Call: Equatable {
        case prices(query: BTCPriceQuery)
    }
    
    func prices(for query: BTCPriceQuery) async throws -> BTCPriceAPIEntity {
        calls.append(.prices(query: query))
        switch pricesReturnValue {
        case let .success(entity):
            return entity
        case let .failure(error):
            throw error
        }
    }
    
    var calls: [Call] = []
    var pricesReturnValue: Result<BTCPriceAPIEntity, BTCPriceServiceErrorMock> = .success(.fake())
}

enum BTCPriceServiceErrorMock: Error {
    case mockError
}
