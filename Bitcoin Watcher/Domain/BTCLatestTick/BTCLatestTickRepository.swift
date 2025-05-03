//
//  BTCLatestTickRepository.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation

enum BTCLatestTickRepositoryError: Error {
    case noData
}

protocol BTCLatestTickRepositoryType {
    func latestPrice() async throws -> BTCLatestTickModel
}

struct BTCLatestTickRepository: BTCLatestTickRepositoryType {
    
    init(service: BTCLatestTickServiceType) {
        self.service = service
    }
    
    func latestPrice() async throws -> BTCLatestTickModel {
        let apiEntity = try await service.latestPrice(for: AppConfig.currentCurrency)
        return try BTCLatestTickModel(from: apiEntity)
    }
    
    private let service: BTCLatestTickServiceType
}

private extension BTCLatestTickModel {
    init(from apiEntity: BTCLatestTickAPIEntity) throws {
        guard let price = apiEntity.price else {
            throw BTCLatestTickRepositoryError.noData
        }
        self.init(value: price.value,
                  valueFlag: .init(from: price.valueFlag),
                  lastUpdate: Date(timeIntervalSince1970: price.lastUpdate))
    }
}

private extension BTCLatestTickModel.ValueFlag {
    init(from apiEntity: BTCLatestTickAPIEntity.Price.ValueFlag) {
        switch apiEntity {
        case .down:
            self = .down
        case .up:
            self = .up
        case .unChanged:
            self = .unChanged
        }
    }
}
