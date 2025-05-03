//
//  BTCPriceRepository.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation

protocol BTCPriceRepositoryType {
    func prices() async throws -> BTCPriceModel
}

struct BTCPriceRepository: BTCPriceRepositoryType {
    
    init(service: BTCPriceServiceType) {
        self.service = service
    }
    
    func prices() async throws -> BTCPriceModel {
        let apiEntity = try await service.prices(for: .init(duration: AppConfig.historyDuration,
                                                            currency: AppConfig.currentCurrency))
        return BTCPriceModel(from: apiEntity)
    }
    
    private let service: BTCPriceServiceType
}

private extension BTCPriceModel {
    init(from apiEntity: BTCPriceAPIEntity) {
        self.init(prices: apiEntity.prices.map { .init(from: $0) })
    }
}

private extension BTCPriceModel.Price {
    init(from apiEntity: BTCPriceAPIEntity.Price) {
        self.init(date: Date(timeIntervalSince1970: apiEntity.timestamp),
                  open: apiEntity.open,
                  high: apiEntity.high,
                  low: apiEntity.low,
                  close: apiEntity.close,
                  volume: apiEntity.volume)
    }
}
