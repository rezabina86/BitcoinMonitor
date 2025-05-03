//
//  BTCLatestTickService.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation

protocol BTCLatestTickServiceType {
    func latestPrice(for currency: Currency) async throws -> BTCLatestTickAPIEntity
}

struct BTCLatestTickService: BTCLatestTickServiceType {
    
    init(client: HTTPClientType) {
        self.client = client
    }
    
    func latestPrice(for currency: Currency) async throws -> BTCLatestTickAPIEntity {
        guard let resource = BTCLatestTickResourceFactory.resource(for: currency) else {
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
