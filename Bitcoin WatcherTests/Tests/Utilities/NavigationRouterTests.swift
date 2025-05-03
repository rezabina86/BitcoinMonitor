//
//  NavigationRouterTests.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 10.04.25.
//

import XCTest
import SwiftUI
import Combine
import Foundation
@testable import Bitcoin_Watcher

final class NavigationRouterTests: XCTestCase {
    var sut: NavigationRouter!
    
    override func setUp() {
        super.setUp()
        sut = .init()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    func testGotoDestination() {
        var results: [NavigationPath] = []
        
        let cancelable = sut.currentPath.sink(receiveCompletion: { _ in }) { returnValue in
            results.append(returnValue)
        }
        
        sut.gotoDestination(.detailView(viewState: .init(date: .now,
                                                         openPrice: "",
                                                         highPrice: "",
                                                         lowPrice: "",
                                                         closePrice: "",
                                                         volume: "")))
        
        XCTAssertEqual(results.count, 2)
        
        cancelable.cancel()
    }
}
