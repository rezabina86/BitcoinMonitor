//
//  BTCLatestTickRepositoryTests.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import XCTest
import Foundation
@testable import Bitcoin_Watcher

final class BTCLatestTickRepositoryTests: XCTestCase {
    var sut: BTCLatestTickRepository!
    var mockService: BTCLatestTickServiceMock!
    
    override func setUp() {
        super.setUp()
        
        mockService = .init()
        sut = .init(service: mockService)
    }
    
    override func tearDown() {
        super.tearDown()
        
        mockService = nil
        sut = nil
    }
    
    func testSuccess() async throws {
        mockService.latestPriceReturnValue = .success(.fake())
        
        let result = try await sut.latestPrice()
        XCTAssertEqual(result, .fake())
        XCTAssertEqual(mockService.calls, [.latestPrice(currency: .euro)])
    }
    
    func testFinishedWithError() async throws {
        mockService.latestPriceReturnValue = .failure(.mockError)
        
        do {
            _ = try await sut.latestPrice()
            XCTFail("Expected error to be thrown, but none was thrown")
        } catch let error {
            XCTAssertNotNil(error)
        }
        
        XCTAssertEqual(mockService.calls, [.latestPrice(currency: .euro)])
    }
}
