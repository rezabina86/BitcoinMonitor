//
//  URLSessionFactory.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation

public protocol URLSessionFactoryType {
    func createURLSession() -> URLSessionType
}

struct URLSessionFactory: URLSessionFactoryType {

    init() {
        defaultHeaders = createDefaultHeaders()
    }

    func createURLSession() -> URLSessionType {
        let configuration = URLSessionConfiguration.default

        configuration.httpAdditionalHeaders = defaultHeaders

        return URLSession(configuration: configuration,
                          delegate: nil,
                          delegateQueue: nil)
    }

    private let defaultHeaders: [String: String]
}

// MARK: - Factories
private func createDefaultHeaders() -> [String: String] {
    return [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
}
