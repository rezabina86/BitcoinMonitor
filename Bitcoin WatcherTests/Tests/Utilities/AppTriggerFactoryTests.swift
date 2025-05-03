//
//  AppTriggerFactoryTests.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import XCTest
import Combine
import Foundation
@testable import Bitcoin_Watcher

final class AppTriggerFactoryTests: XCTestCase {
    var sut: AppTriggerFactory!
    var mockAppRefreshUseCase: AppRefreshUseCaseMock!
    var mockTimerFactory: TimerFactoryMock!
    
    override func setUp() {
        super.setUp()
        mockAppRefreshUseCase = .init()
        mockTimerFactory = .init()
        
        sut = .init(appRefreshUseCase: mockAppRefreshUseCase,
                    timerFactory: mockTimerFactory)
    }
    
    override func tearDown() {
        super.tearDown()
        mockAppRefreshUseCase = nil
        
        sut = nil
    }
    
    func testOnRetryFeature() {
        var events: [Void] = []
        
        let cancellable = sut.create(of: [.retry(.prices)])
            .sink {
                events.append($0)
            }
        
        // Emits an event when subscribe
        XCTAssertEqual(events.count, 1)
        
        // Emits an event when user is changed
        mockAppRefreshUseCase.refreshTriggeredReturnValue.send(.prices)
        XCTAssertEqual(events.count, 2)
        
        cancellable.cancel()
    }
}
