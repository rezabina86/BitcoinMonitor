//
//  BTCPriceUseCase.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Combine
import Foundation

enum BTCPriceDataState: Equatable {
    case loading
    case error
    case data(BTCPriceModel)
}

protocol BTCPriceUseCaseType {
    func create() -> AnyPublisher<BTCPriceDataState, Never>
}

struct BTCPriceUseCase: BTCPriceUseCaseType {
    
    init(repository: BTCPriceRepositoryType, appTriggerFactory: AppTriggerFactoryType) {
        self.repository = repository
        self.appTriggerFactory = appTriggerFactory
    }
    
    func create() -> AnyPublisher<BTCPriceDataState, Never> {
        makeTrigger.flatMap {
            pricesData()
        }.eraseToAnyPublisher()
    }
    
    private let repository: BTCPriceRepositoryType
    private let appTriggerFactory: AppTriggerFactoryType
    
    private func pricesData() -> AnyPublisher<BTCPriceDataState, Never> {
        Future<BTCPriceDataState, Never> { promise in
            Task {
                do {
                    let prices = try await repository.prices()
                    promise(.success(.data(prices)))
                } catch {
                    promise(.success(.error))
                }
            }
        }
        .prepend(.loading)
        .eraseToAnyPublisher()
    }
    
    private var makeTrigger: AnyPublisher<Void, Never> {
        appTriggerFactory.create(of: [.retry(.prices)])
    }
}
