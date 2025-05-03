//
//  BTCLatestTickResourceFactory.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation

struct BTCLatestTickResourceFactory: ResourceFactoryType {
    
    static var decoder: DecoderType = jsonDecoder
    
    static func resource(for currency: Currency) -> Resource<BTCLatestTickAPIEntity>? {
        return url(for: currency)
            .flatMap {
                .get(
                    url: $0,
                    using: decoder
                )
            }
    }
    
    private static func url(for currency: Currency) -> URL? {
        var components = URLComponents(string: "https://data-api.coindesk.com/index/cc/v1/latest/tick")
        components?.queryItems = buildQueryItems(for: currency)
        return components?.url
    }
    
    private static func buildQueryItems(for currency: Currency) -> [URLQueryItem] {
        return [
            URLQueryItem(name: "market", value: "cadli"),
            URLQueryItem(name: "instruments", value: "BTC-\(currency.rawValue)"),
            URLQueryItem(name: "apply_mapping", value: "true"),
            URLQueryItem(name: "groups", value: "VALUE")
        ]
    }
}
