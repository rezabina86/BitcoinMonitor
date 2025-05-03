//
//  BTCPriceUseCaseMock.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Combine
import Foundation
@testable import Bitcoin_Watcher

final class BTCPriceUseCaseMock: BTCPriceUseCaseType {
    enum Call: Equatable {
        case create
    }
    
    func create() -> AnyPublisher<BTCPriceDataState, Never> {
        calls.append(.create)
        return createSubject.eraseToAnyPublisher()
    }
    
    var calls: [Call] = []
    var createSubject: PassthroughSubject<BTCPriceDataState, Never> = .init()
}
