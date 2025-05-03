//
//  BTCLatestTickServiceTests.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import XCTest
import Foundation
@testable import Bitcoin_Watcher

final class BTCLatestTickServiceTests: XCTestCase {
    var sut: BTCLatestTickService!
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
        mockHTTPClient.loadReturnValue = .success(BTCLatestTickAPIEntity.fake())
        
        let entity = try await sut.latestPrice(for: .euro)
        let expectedURL = URL(string: "https://data-api.coindesk.com/index/cc/v1/latest/tick?market=cadli&instruments=BTC-EUR&apply_mapping=true&groups=VALUE")!
        
        XCTAssertEqual(entity, .fake())
        XCTAssertEqual(mockHTTPClient.calls, [.load(url: expectedURL, method: .get)])
    }
}
