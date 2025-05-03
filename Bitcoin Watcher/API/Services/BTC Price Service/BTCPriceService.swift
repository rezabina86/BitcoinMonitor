//
//  BTCPriceService.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation

protocol BTCPriceServiceType {
    func prices(for query: BTCPriceQuery) async throws -> BTCPriceAPIEntity
}

struct BTCPriceService: BTCPriceServiceType {
    
    init(client: HTTPClientType) {
        self.client = client
    }
    
    func prices(for query: BTCPriceQuery) async throws -> BTCPriceAPIEntity {
        guard let resource = BTCPriceResourceFactory.resource(for: query) else {
            throw ResourceError.invalidParameters
        }
        
        let result = try await client.load(resource: resource)
        
        return await MainActor.run {
            return result
        }
    }
    
    // MARK: - Privates
    private let client: HTTPClientType
}
