//
//  BTCLatestTickResourceFactoryTests.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import XCTest
import Foundation
@testable import Bitcoin_Watcher

final class BTCLatestTickResourceFactoryTests: XCTestCase {
    var sut: Resource<BTCLatestTickAPIEntity>!
    var mockDecoder: JSONDecoderMock!
    
    override func setUp() {
        super.setUp()
        
        mockDecoder = .init()
        mockDecoder.decodeReturnValue = BTCLatestTickAPIEntity.fake()
        BTCLatestTickResourceFactory.decoder = mockDecoder
    }
    
    override func tearDown() {
        super.tearDown()
        
        mockDecoder = nil
        sut = nil
    }
    
    func testGenerateURL() {
        sut = BTCLatestTickResourceFactory.resource(for: .euro)
        XCTAssertEqual(sut.url.absoluteString, "https://data-api.coindesk.com/index/cc/v1/latest/tick?market=cadli&instruments=BTC-EUR&apply_mapping=true&groups=VALUE")
    }
    
    func testMethod() {
        sut = BTCLatestTickResourceFactory.resource(for: .euro)
        XCTAssertEqual(sut.method, .get)
    }
    
    func testParse() {
        sut = BTCLatestTickResourceFactory.resource(for: .euro)
        let result: BTCLatestTickAPIEntity!
        result = try? sut.parse(Data())
        
        XCTAssertEqual(result, .fake())
        XCTAssertTrue(mockDecoder.decodeCalls.compactMap{ $0.type }.count == 1)
    }
}
