//
//  TimerService.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation
import Combine

protocol TimerFactoryType {
    func start(every interval: TimeInterval) -> AnyPublisher<Date, Never>
}

final class TimerFactory: TimerFactoryType {
    func start(every interval: TimeInterval) -> AnyPublisher<Date, Never> {
        Timer
            .publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .eraseToAnyPublisher()
    }
}
