//
//  BTCLatestTickUseCaseMock.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Combine
import Foundation
@testable import Bitcoin_Watcher

final class BTCLatestTickUseCaseMock: BTCLatestTickUseCaseType {
    enum Call: Equatable {
        case create
    }
    
    func create() -> AnyPublisher<BTCLatestTickDataState, Never> {
        calls.append(.create)
        return createSubject.eraseToAnyPublisher()
    }
    
    var calls: [Call] = []
    var createSubject: PassthroughSubject<BTCLatestTickDataState, Never> = .init()
}
