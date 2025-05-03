//
//  BTCPriceResourceFactoryTests.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import XCTest
import Foundation
@testable import Bitcoin_Watcher

final class BTCPriceResourceFactoryTests: XCTestCase {
    var sut: Resource<BTCPriceAPIEntity>!
    var mockDecoder: JSONDecoderMock!
    
    let fakeQuery: BTCPriceQuery = .init(duration: 14, currency: .euro)
    
    override func setUp() {
        super.setUp()
        
        mockDecoder = .init()
        mockDecoder.decodeReturnValue = BTCPriceAPIEntity.fake()
        BTCPriceResourceFactory.decoder = mockDecoder
    }
    
    override func tearDown() {
        super.tearDown()
        
        mockDecoder = nil
        sut = nil
    }
    
    func testGenerateURL() {
        sut = BTCPriceResourceFactory.resource(for: fakeQuery)
        XCTAssertEqual(sut.url.absoluteString, "https://data-api.coindesk.com/index/cc/v1/historical/days?market=cadli&instrument=BTC-EUR&limit=14&response_format=JSON")
    }
    
    func testMethod() {
        sut = BTCPriceResourceFactory.resource(for: fakeQuery)
        XCTAssertEqual(sut.method, .get)
    }
    
    func testParse() {
        sut = BTCPriceResourceFactory.resource(for: fakeQuery)
        let result: BTCPriceAPIEntity!
        result = try? sut.parse(Data())
        
        XCTAssertEqual(result, .fake())
        XCTAssertTrue(mockDecoder.decodeCalls.compactMap{ $0.type }.count == 1)
    }
}

