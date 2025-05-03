//
//  HTTPClient.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation

extension URL {
    func relativeTo(baseURL: URL) -> URL? {
        return URL(string: absoluteString, relativeTo: baseURL)
    }
}

protocol HTTPClientType {
    func load<Entity>(resource: Resource<Entity>) async throws -> Entity
}

final class HTTPClient: HTTPClientType {

    public init(sessionFactory: URLSessionFactoryType) {
        session = sessionFactory.createURLSession()
    }

    public enum Error: Swift.Error, Equatable {
        case invalidRequestUrl
        case invalidResponse
        case http(code: Int, data: Data?)
    }
    
    func load<Entity>(resource: Resource<Entity>) async throws -> Entity {
        guard resource.url.isValid else {
            throw Error.invalidRequestUrl
        }
        
        let request = createRequest(url: resource.url, method: resource.method)
        
        let data = try await performRequest(request)
        return try resource.parse(data)
    }

    // MARK: Private

    private let session: URLSessionType

    private func createRequest(url: URL, method: HTTPMethod) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.httpMethod
        return request
    }
    
    private func performRequest(_ request: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(with: request)
        return try handleResponse(data: data, response: response)
    }
}

private func handleResponse(data: Data, response: URLResponse) throws -> Data {
    guard let response = response as? HTTPURLResponse else {
        throw HTTPClient.Error.invalidResponse
    }

    guard (200..<400).contains(response.statusCode) else {
        throw HTTPClient.Error.http(code: response.statusCode, data: data)
    }

    return data
}

extension URL {
    var isValid: Bool {
        return URLComponents(url: self, resolvingAgainstBaseURL: true)?.url != nil
    }
}
