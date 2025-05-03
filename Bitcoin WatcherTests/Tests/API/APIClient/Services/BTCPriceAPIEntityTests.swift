//
//  BTCPriceAPIEntityTests.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import XCTest
import Foundation
@testable import Bitcoin_Watcher

final class BTCPriceAPIEntityTests: XCTestCase {
    func testParseResponse() {
        let result: BTCPriceAPIEntity?
        
        do {
            result = try JSONDecoder().decode(
                BTCPriceAPIEntity.self,
                from: apiReturnValue.data(using: .utf8)!
            )
        } catch {
            result = nil
            XCTFail(error.localizedDescription)
        }
        
        XCTAssertEqual(result, .fake(prices: [
            .fake(
                timestamp: 1743033600,
                open: 80918.143479491,
                high: 81687.3200099306,
                low:  79504.1925683526,
                close:  80760.858361834,
                volume:  176014.818439654),
            .fake(
                timestamp: 1743120000,
                open: 80760.858361834,
                high: 81018.6260079899,
                low: 76870.0225871469,
                close: 77629.1005805285,
                volume: 250197.473690613
            )
        ]))
    }
}

private let apiReturnValue = """
{
  "Data": [
    {
      "UNIT": "DAY",
      "TIMESTAMP": 1743033600,
      "TYPE": "986",
      "MARKET": "cadli",
      "INSTRUMENT": "BTC-EUR",
      "OPEN": 80918.143479491,
      "HIGH": 81687.3200099306,
      "LOW": 79504.1925683526,
      "CLOSE": 80760.858361834,
      "FIRST_MESSAGE_TIMESTAMP": 1743033600,
      "LAST_MESSAGE_TIMESTAMP": 1743119999,
      "FIRST_MESSAGE_VALUE": 80496.1413007414,
      "HIGH_MESSAGE_VALUE": 81261.3025083932,
      "HIGH_MESSAGE_TIMESTAMP": 1743043853,
      "LOW_MESSAGE_VALUE": 79504.1925683526,
      "LOW_MESSAGE_TIMESTAMP": 1743082891,
      "LAST_MESSAGE_VALUE": 80760.858361834,
      "TOTAL_INDEX_UPDATES": 0,
      "VOLUME": 176014.818439654,
      "QUOTE_VOLUME": 14215479274.9852,
      "VOLUME_TOP_TIER": 104030.760604595,
      "QUOTE_VOLUME_TOP_TIER": 8399310194.59826,
      "VOLUME_DIRECT": 0,
      "QUOTE_VOLUME_DIRECT": 0,
      "VOLUME_TOP_TIER_DIRECT": 0,
      "QUOTE_VOLUME_TOP_TIER_DIRECT": 0
    },
    {
      "UNIT": "DAY",
      "TIMESTAMP": 1743120000,
      "TYPE": "986",
      "MARKET": "cadli",
      "INSTRUMENT": "BTC-EUR",
      "OPEN": 80760.858361834,
      "HIGH": 81018.6260079899,
      "LOW": 76870.0225871469,
      "CLOSE": 77629.1005805285,
      "FIRST_MESSAGE_TIMESTAMP": 1743120000,
      "LAST_MESSAGE_TIMESTAMP": 1743206399,
      "FIRST_MESSAGE_VALUE": 80204.1359620902,
      "HIGH_MESSAGE_VALUE": 80459.9118647764,
      "HIGH_MESSAGE_TIMESTAMP": 1743126230,
      "LOW_MESSAGE_VALUE": 76870.0225871469,
      "LOW_MESSAGE_TIMESTAMP": 1743182000,
      "LAST_MESSAGE_VALUE": 77629.1005805285,
      "TOTAL_INDEX_UPDATES": 0,
      "VOLUME": 250197.473690613,
      "QUOTE_VOLUME": 19675913440.4692,
      "VOLUME_TOP_TIER": 146101.447571296,
      "QUOTE_VOLUME_TOP_TIER": 11485557225.7288,
      "VOLUME_DIRECT": 0,
      "QUOTE_VOLUME_DIRECT": 0,
      "VOLUME_TOP_TIER_DIRECT": 0,
      "QUOTE_VOLUME_TOP_TIER_DIRECT": 0
    }
]
}
"""
