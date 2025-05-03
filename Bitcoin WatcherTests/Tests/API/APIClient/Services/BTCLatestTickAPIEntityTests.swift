//
//  BTCLatestTickAPIEntityTests.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import XCTest
import Foundation
@testable import Bitcoin_Watcher

final class BTCLatestTickAPIEntityTests: XCTestCase {
    func testParseResponse() {
        let result: BTCLatestTickAPIEntity?
        
        do {
            result = try JSONDecoder().decode(
                BTCLatestTickAPIEntity.self,
                from: apiReturnValue.data(using: .utf8)!
            )
        } catch {
            result = nil
            XCTFail(error.localizedDescription)
        }
        
        XCTAssertEqual(result, .fake(price: .fake(value: 70009.4455389552, valueFlag: .up, lastUpdate: 1744212053)))
    }
}

private let apiReturnValue = """
{
  "Data": {
    "BTC-EUR": {
      "VALUE": 70009.4455389552,
      "VALUE_FLAG": "UP",
      "VALUE_LAST_UPDATE_TS": 1744212053
    }
  },
  "Err": {}
}
"""
