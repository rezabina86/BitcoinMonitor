//
//  AppRefreshUseCaseTests.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Combine
import XCTest
import Foundation
@testable import Bitcoin_Watcher

final class AppRefreshUseCaseTests: XCTestCase {
    var sut: AppRefreshUseCase!
    
    override func setUp() {
        super.setUp()
        sut = .init()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testRetry() {
        let expectation = XCTestExpectation(description: "retry triggered")
        var results: [AppRefreshFeature] = []
        
        let cancellable = sut.refreshTriggered.sink {
            results.append($0)
            if !results.isEmpty {
                expectation.fulfill()
            }
        }
        
        sut.refresh(feature: .prices)
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(results, [.prices])
        
        cancellable.cancel()
    }
}
