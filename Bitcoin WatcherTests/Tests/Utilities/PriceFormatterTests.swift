//
//  PriceFormatterTests.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 10.04.25.
//

import XCTest
import Foundation
@testable import Bitcoin_Watcher

final class PriceFormatterTests: XCTestCase {
    var sut: PriceFormatter!
    var mockLocaleProvider: LocaleProviderMock!
    
    override func setUp() {
        super.setUp()
        mockLocaleProvider = .init()
        sut = .init(localeProvider: mockLocaleProvider)
    }
    
    override func tearDown() {
        super.tearDown()
        mockLocaleProvider = nil
        sut = nil
    }
    
    func testFormatAmount() {
        let a = sut.formate(amount: 0, currency: .euro)
        let b = sut.formate(amount: 1, currency: .euro)
        let c = sut.formate(amount: 100, currency: .euro)
        let d = sut.formate(amount: 10000.234, currency: .euro)
        
        XCTAssertEqual(a, "0,00 €")
        XCTAssertEqual(b, "1,00 €")
        XCTAssertEqual(c, "100,00 €")
        XCTAssertEqual(d, "10.000,23 €")
    }
}
