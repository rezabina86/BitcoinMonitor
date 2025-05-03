//
//  BTCLatestTickUseCase.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Combine
import Foundation

enum BTCLatestTickDataState: Equatable {
    case error
    case data(BTCLatestTickModel)
}

protocol BTCLatestTickUseCaseType {
    func create() -> AnyPublisher<BTCLatestTickDataState, Never>
}

struct BTCLatestTickUseCase: BTCLatestTickUseCaseType {
    
    init(repository: BTCLatestTickRepositoryType,
         appTriggerFactory: AppTriggerFactoryType) {
        self.repository = repository
        self.appTriggerFactory = appTriggerFactory
    }
    
    func create() -> AnyPublisher<BTCLatestTickDataState, Never> {
        makeTrigger.flatMap {
            pricesData()
        }.eraseToAnyPublisher()
    }
    
    private let repository: BTCLatestTickRepositoryType
    private let appTriggerFactory: AppTriggerFactoryType
    
    private func pricesData() -> AnyPublisher<BTCLatestTickDataState, Never> {
        Future<BTCLatestTickDataState, Never> { promise in
            Task {
                do {
                    let latestPrice = try await repository.latestPrice()
                    promise(.success(.data(latestPrice)))
                } catch {
                    promise(.success(.error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private var makeTrigger: AnyPublisher<Void, Never> {
        appTriggerFactory.create(of: [
            .retry(.latestPrice),
            .timer(interval: AppConfig.refetchInterval)
        ])
    }
}
