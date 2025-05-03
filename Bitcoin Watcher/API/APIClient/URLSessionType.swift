//
//  URLSessionType.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation

public protocol URLSessionType {
    var configuration: URLSessionConfiguration { get }
    var delegate: URLSessionDelegate? { get }
    
    func data(with request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionType {
    public func data(with request: URLRequest) async throws -> (Data, URLResponse) {
        try await self.data(for: request)
    }
}
