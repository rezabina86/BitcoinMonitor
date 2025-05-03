//
//  TimerFactoryMock.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Combine
import Foundation
@testable import Bitcoin_Watcher

final class TimerFactoryMock: TimerFactoryType {
    enum Call: Equatable {
        case start(interval: TimeInterval)
    }
    
    func start(every interval: TimeInterval) -> AnyPublisher<Date, Never> {
        calls.append(.start(interval: interval))
        return timerSubject.eraseToAnyPublisher()
    }
    
    var calls: [Call] = []
    var timerSubject: PassthroughSubject<Date, Never> = .init()
}
