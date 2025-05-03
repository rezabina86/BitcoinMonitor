//
//  DetailViewStateConverterTests.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 10.04.25.
//

import XCTest
import Foundation
@testable import Bitcoin_Watcher

final class DetailViewStateConverterTests: XCTestCase {
    var sut: DetailViewStateConverter!
    var mockPriceFormatter: PriceFormatterMock!
    
    override func setUp() {
        super.setUp()
        mockPriceFormatter = .init()
        sut = .init(priceFormatter: mockPriceFormatter)
    }
    
    override func tearDown() {
        super.tearDown()
        mockPriceFormatter = nil
        sut = nil
    }
    
    func testCreateViewState() {
        let date = Date(timeIntervalSince1970: 1743033600)
        mockPriceFormatter.formatReturnValue = "10.000"
        let viewState = sut.create(from: .fake(date: date))
        let expectedViewState = DetailViewState(date: date,
                                                openPrice: "10.000",
                                                highPrice: "10.000",
                                                lowPrice: "10.000",
                                                closePrice: "10.000",
                                                volume: "10.000")
        
        XCTAssertEqual(viewState, expectedViewState)
        XCTAssertEqual(mockPriceFormatter.calls, [.format(amount: 80918, currency: .euro),
                                                  .format(amount: 80918, currency: .euro),
                                                  .format(amount: 80918, currency: .euro),
                                                  .format(amount: 80918, currency: .euro),
                                                  .format(amount: 176014, currency: .euro)])
    }
}
