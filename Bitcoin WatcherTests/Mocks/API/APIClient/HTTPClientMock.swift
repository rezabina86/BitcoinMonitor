//
//  HTTPClientMock.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation
@testable import Bitcoin_Watcher

final class HTTPClientMock: HTTPClientType {
    
    enum Call: Equatable {
        case load(url: URL, method: HTTPMethod)
    }
    
    var calls: [Call] = []
    var loadReturnValue: Result<Decodable, HTTPClient.Error> = .failure(.invalidRequestUrl)
    
    func load<Entity>(resource: Resource<Entity>) async throws -> Entity {
        calls.append(.load(
            url: resource.url,
            method: resource.method
        ))
        
        switch loadReturnValue {
        case let .success(result):
            return result as! Entity
        case let .failure(error):
            throw error
        }
    }
    
}
