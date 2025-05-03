//
//  BTCPriceResourceFactory.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation

struct BTCPriceQuery: Equatable {
    let duration: Int
    let currency: Currency
}

struct BTCPriceResourceFactory: ResourceFactoryType {
    
    static var decoder: DecoderType = jsonDecoder
    
    static func resource(for query: BTCPriceQuery) -> Resource<BTCPriceAPIEntity>? {
        return url(for: query)
            .flatMap {
                .get(
                    url: $0,
                    using: decoder
                )
            }
    }
    
    private static func url(for query: BTCPriceQuery) -> URL? {
        var components = URLComponents(string: "https://data-api.coindesk.com/index/cc/v1/historical/days")
        components?.queryItems = buildQueryItems(from: query)
        return components?.url
    }
    
    private static func buildQueryItems(from query: BTCPriceQuery) -> [URLQueryItem] {
        return [
            URLQueryItem(name: "market", value: "cadli"),
            URLQueryItem(name: "instrument", value: "BTC-\(query.currency.rawValue)"),
            URLQueryItem(name: "limit", value: "\(query.duration)"),
            URLQueryItem(name: "response_format", value: "JSON")
        ]
    }
}
