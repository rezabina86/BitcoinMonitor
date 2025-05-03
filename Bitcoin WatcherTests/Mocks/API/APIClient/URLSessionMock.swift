//
//  URLSessionMock.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation
@testable import Bitcoin_Watcher

enum URLSessionMockError: Error {
    case mockError
}

final class URLSessionMock: URLSessionType {
    
    enum Call: Equatable {
        case data(request: URLRequest)
    }
    
    var calls: [Call] = []
    
    var dataReturnValue: Result<(Data, URLResponse), URLSessionMockError> = .failure(.mockError)
    
    var configuration: URLSessionConfiguration {
        .default
    }
    
    var delegate: URLSessionDelegate? {
        nil
    }
    
    func data(with request: URLRequest) async throws -> (Data, URLResponse) {
        calls.append(.data(request: request))
        switch dataReturnValue {
        case let .success(response):
            return response
        case let .failure(error):
            throw error
        }
    }
}
