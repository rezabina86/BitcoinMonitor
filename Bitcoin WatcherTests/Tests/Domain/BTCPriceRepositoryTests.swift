//
//  BTCPriceRepositoryTests.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import XCTest
import Foundation
@testable import Bitcoin_Watcher

final class BTCPriceRepositoryTests: XCTestCase {
    var sut: BTCPriceRepository!
    var mockBTCPriceService: BTCPriceServiceMock!
    
    override func setUp() {
        super.setUp()
        
        mockBTCPriceService = .init()
        sut = .init(service: mockBTCPriceService)
    }
    
    override func tearDown() {
        super.tearDown()
        
        mockBTCPriceService = nil
        sut = nil
    }
    
    func testSuccess() async throws {
        mockBTCPriceService.pricesReturnValue = .success(.fake())
        
        let result = try await sut.prices()
        XCTAssertEqual(result, .fake())
        XCTAssertEqual(mockBTCPriceService.calls, [.prices(query: .init(duration: 14, currency: .euro))])
    }
    
    func testFinishedWithError() async throws {
        mockBTCPriceService.pricesReturnValue = .failure(.mockError)
        
        do {
            _ = try await sut.prices()
            XCTFail("Expected error to be thrown, but none was thrown")
        } catch let error {
            XCTAssertNotNil(error)
        }
        
        XCTAssertEqual(mockBTCPriceService.calls, [.prices(query: .init(duration: 14, currency: .euro))])
    }
}
