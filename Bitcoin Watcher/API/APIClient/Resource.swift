//
//  Resource.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation

public enum ResourceError: Error {
    case invalidParameters
}

public struct Resource<Entity>: Equatable {

    init(url: URL, method: HTTPMethod = .get, parse: @escaping (Data?) throws -> Entity) {
        self.url = url
        self.method = method
        self.parse = parse
    }

    public enum Error: Swift.Error {
        case dataMissing
        case dataCorrupted
    }

    public static func == (lhs: Resource<Entity>, rhs: Resource<Entity>) -> Bool {
        return lhs.method == rhs.method
            && lhs.url == rhs.url
    }

    let url: URL
    let method: HTTPMethod
    let parse: (Data?) throws -> Entity

    static func get<APIEntity: Decodable>(url: URL, using decoder: DecoderType) -> Resource<APIEntity> {
        return Resource<APIEntity>(
            url: url,
            method: .get,
            parse: { data in
                guard let data = data else { throw Error.dataMissing }
                return try decoder.decode(APIEntity.self, from: data)
            }
        )
    }
}

public enum HTTPMethod: Equatable {
    case get

    // MARK: Internal

    /// Returns the appropriate HTTP Method string
    var httpMethod: String {
        switch self {
        case .get: return "GET"
        }
    }
}
