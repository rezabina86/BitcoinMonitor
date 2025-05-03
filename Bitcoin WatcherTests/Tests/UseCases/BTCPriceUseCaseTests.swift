//
//  BTCPriceUseCaseTests.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import XCTest
import Foundation
@testable import Bitcoin_Watcher

final class BTCPriceUseCaseTests: XCTestCase {
    var sut: BTCPriceUseCase!
    var mockBTCPriceRepository: BTCPriceRepositoryMock!
    var mockAppTriggerFactory: AppTriggerFactoryMock!
    
    override func setUp() {
        super.setUp()
        mockBTCPriceRepository = .init()
        mockAppTriggerFactory = .init()
        
        sut = .init(repository: mockBTCPriceRepository,
                    appTriggerFactory: mockAppTriggerFactory)
    }
    
    override func tearDown() {
        super.tearDown()
        mockBTCPriceRepository = nil
        mockAppTriggerFactory = nil
        sut = nil
    }
    
    func testSuccess() {
        let expectation = XCTestExpectation(description: "data state is loaded")
        
        mockBTCPriceRepository.pricesReturnValue = .success(.fake())
        
        var results: [BTCPriceDataState] = []
        
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
        XCTAssertEqual(mockAppTriggerFactory.calls, [.create(triggers: [.retry(.prices)])])
        XCTAssertEqual(mockBTCPriceRepository.calls.count, 1)
        cancellable.cancel()
    }
    
    func testRetry() {
        let expectation1 = XCTestExpectation(description: "First data state is loaded")
        let expectation2 = XCTestExpectation(description: "Second data state is loaded")
        var results: [BTCPriceDataState] = []
        
        mockBTCPriceRepository.pricesReturnValue = .success(.fake())
        
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
        
        XCTAssertEqual(mockBTCPriceRepository.calls.count, 2)
    }
    
    func testError() {
        let expectation = XCTestExpectation(description: "data state is loaded with error")
        
        mockBTCPriceRepository.pricesReturnValue = .failure(.mockError)
        
        var results: [BTCPriceDataState] = []
        
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
