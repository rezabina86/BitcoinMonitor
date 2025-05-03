//
//  BTCLatestTickServiceMock.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation
@testable import Bitcoin_Watcher

final class BTCLatestTickServiceMock: BTCLatestTickServiceType {
    
    enum Call: Equatable {
        case latestPrice(currency: Currency)
    }
    
    func latestPrice(for currency: Currency) async throws -> BTCLatestTickAPIEntity {
        calls.append(.latestPrice(currency: currency))
        switch latestPriceReturnValue {
        case let .success(entity):
            return entity
        case let .failure(error):
            throw error
        }
    }
    
    var calls: [Call] = []
    var latestPriceReturnValue: Result<BTCLatestTickAPIEntity, BTCLatestTickServiceErrorMock> = .success(.fake())
}

enum BTCLatestTickServiceErrorMock: Error {
    case mockError
}
