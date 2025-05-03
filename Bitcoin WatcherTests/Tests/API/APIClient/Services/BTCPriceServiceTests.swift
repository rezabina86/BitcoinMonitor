//
//  BTCPriceServiceTests.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import XCTest
import Foundation
@testable import Bitcoin_Watcher

final class BTCPriceServiceTests: XCTestCase {
    var sut: BTCPriceService!
    var mockHTTPClient: HTTPClientMock!
    
    override func setUp() {
        super.setUp()
        
        mockHTTPClient = .init()
        sut = .init(client: mockHTTPClient)
    }
    
    override func tearDown() {
        super.tearDown()
        
        mockHTTPClient = nil
        sut = nil
    }
    
    func testLoad() async throws {
        mockHTTPClient.loadReturnValue = .success(BTCPriceAPIEntity.fake())
        
        let entity = try await sut.prices(for: .init(duration: 14, currency: .euro))
        let expectedURL = URL(string: "https://data-api.coindesk.com/index/cc/v1/historical/days?market=cadli&instrument=BTC-EUR&limit=14&response_format=JSON")!
        
        XCTAssertEqual(entity, .fake())
        XCTAssertEqual(mockHTTPClient.calls, [.load(url: expectedURL, method: .get)])
    }
    
}
