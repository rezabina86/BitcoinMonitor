//
//  BTCLatestTickUseCaseTests.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import XCTest
import Foundation
@testable import Bitcoin_Watcher

final class BTCLatestTickUseCaseTests: XCTestCase {
    var sut: BTCLatestTickUseCase!
    var mockRepository: BTCLatestTickRepositoryMock!
    var mockAppTriggerFactory: AppTriggerFactoryMock!
    
    override func setUp() {
        super.setUp()
        mockRepository = .init()
        mockAppTriggerFactory = .init()
        
        sut = .init(repository: mockRepository,
                    appTriggerFactory: mockAppTriggerFactory)
    }
    
    override func tearDown() {
        super.tearDown()
        mockRepository = nil
        mockAppTriggerFactory = nil
        sut = nil
    }
    
    func testSuccess() {
        let expectation = XCTestExpectation(description: "data state is loaded")
        
        mockRepository.latestPriceReturnValue = .success(.fake())
        
        var results: [BTCLatestTickDataState] = []
        
        let cancellable = sut.create()
            .sink { ds in
                results.append(ds)
                switch ds {
                case .data:
                    expectation.fulfill()
                default:
                    break
                }
            }
        
        mockAppTriggerFactory.triggerRelay.send(())
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(results, [.loading, .data(.fake())])
        XCTAssertEqual(mockAppTriggerFactory.calls, [.create(triggers: [.retry(.latestPrice), .timer(interval: 60)])])
        XCTAssertEqual(mockRepository.calls.count, 1)
        cancellable.cancel()
    }
    
    func testRefetch() {
        let expectation1 = XCTestExpectation(description: "First data state is loaded")
        let expectation2 = XCTestExpectation(description: "Second data state is loaded")
        var results: [BTCLatestTickDataState] = []
        
        mockRepository.latestPriceReturnValue = .success(.fake())
        
        let cancellable = sut.create()
            .sink { ds in
                results.append(ds)
                if results.count == 2 {
                    expectation1.fulfill()
                } else if results.count == 4 {
                    expectation2.fulfill()
                }
            }
        
        mockAppTriggerFactory.triggerRelay.send(())

        wait(for: [expectation1], timeout: 1.0)

        // Send the second trigger only after the first has been fully processed.
        mockAppTriggerFactory.triggerRelay.send(())

        wait(for: [expectation2], timeout: 1.0)

        XCTAssertEqual(results, [.loading, .data(.fake()), .loading, .data(.fake())])
        
        cancellable.cancel()
        
        XCTAssertEqual(mockRepository.calls.count, 2)
    }
    
    func testError() {
        let expectation = XCTestExpectation(description: "data state is loaded with error")
        
        mockRepository.latestPriceReturnValue = .failure(.mockError)
        
        var results: [BTCLatestTickDataState] = []
        
        let cancellable = sut.create()
            .sink { ds in
                results.append(ds)
                switch ds {
                case .error:
                    expectation.fulfill()
                default:
                    break
                }
            }
        
        mockAppTriggerFactory.triggerRelay.send(())
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(results, [.loading, .error])
        cancellable.cancel()
    }
}
