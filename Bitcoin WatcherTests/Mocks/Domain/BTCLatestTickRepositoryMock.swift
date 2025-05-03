//
//  BTCLatestTickRepositoryMock.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation
@testable import Bitcoin_Watcher

final class BTCLatestTickRepositoryMock: BTCLatestTickRepositoryType {
    
    enum Call: Equatable {
        case latestPrice
    }
    
    func latestPrice() async throws -> BTCLatestTickModel {
        calls.append(.latestPrice)
        switch latestPriceReturnValue {
        case let .success(model):
            return model
        case let .failure(error):
            throw error
        }
    }
    
    var calls: [Call] = []
    var latestPriceReturnValue: Result<BTCLatestTickModel, BTCLatestTickRepositoryErrorMock> = .success(.fake())
}

enum BTCLatestTickRepositoryErrorMock: Error {
    case mockError
}
