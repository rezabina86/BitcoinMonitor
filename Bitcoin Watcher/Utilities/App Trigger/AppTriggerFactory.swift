//
//  AppTriggerFactory.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Combine
import Foundation

protocol AppTriggerFactoryType {
    func create(of triggers: [AppTrigger]) -> AnyPublisher<Void, Never>
}

enum AppTrigger: Equatable {
    case retry(AppRefreshFeature)
    case timer(interval: TimeInterval)
}

struct AppTriggerFactory: AppTriggerFactoryType {
    
    let appRefreshUseCase: AppRefreshUseCaseType
    let timerFactory: TimerFactoryType
    
    func create(of triggers: [AppTrigger]) -> AnyPublisher<Void, Never> {
        let publishers = triggers.map { observable(for: $0) }
        return Publishers.MergeMany(publishers)
            .prepend(())
            .eraseToAnyPublisher()
    }
    
    private func observable(for trigger: AppTrigger) -> AnyPublisher<Void, Never> {
        switch trigger {
        case let .timer(interval):
            return timerFactory.start(every: interval)
                .asVoidPublisher
                .eraseToAnyPublisher()
        case let .retry(feature):
            return appRefreshUseCase.refreshTriggered
                .filter { $0 == feature }
                .eraseToAnyPublisher()
                .asVoidPublisher
                .eraseToAnyPublisher()
        }
    }
    
}

private extension AnyPublisher where Failure == Never {
    var asVoidPublisher: AnyPublisher<Void, Never> {
        self.map { _ in }.eraseToAnyPublisher()
    }
}
