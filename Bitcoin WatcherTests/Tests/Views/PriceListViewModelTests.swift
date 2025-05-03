//
//  PriceListViewModelTests.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 10.04.25.
//

import XCTest
import Foundation
@testable import Bitcoin_Watcher

final class PriceListViewModelTests: XCTestCase {
    var sut: PriceListViewModel!
    
    var mockLatestPriceUseCase: BTCLatestTickUseCaseMock!
    var mockHistoryUseCase: BTCPriceUseCaseMock!
    var mockAppRefreshUseCase: AppRefreshUseCaseMock!
    var mockNavigationRouter: NavigationRouterMock!
    var mockPriceFormatter: PriceFormatterMock!
    var mockDetailViewStateConverter: DetailViewStateConverterMock!
    
    var testSubscriber: TestableSubscriber<PriceListViewState, Never>!
    
    override func setUp() {
        super.setUp()
        mockLatestPriceUseCase = .init()
        mockHistoryUseCase = .init()
        mockAppRefreshUseCase = .init()
        mockNavigationRouter = .init()
        mockPriceFormatter = .init()
        mockDetailViewStateConverter = .init()
        testSubscriber = .init()
        
        mockPriceFormatter.formatReturnValue = "70000"
        
        sut = .init(latestPriceUseCase: mockLatestPriceUseCase,
                    historyUseCase: mockHistoryUseCase,
                    refreshUseCase: mockAppRefreshUseCase,
                    navigationRouter: mockNavigationRouter,
                    priceFormatter: mockPriceFormatter,
                    detailViewStateConverter: mockDetailViewStateConverter)
        
        sut.viewState
            .subscribe(testSubscriber)
    }
    
    override func tearDown() {
        super.tearDown()
        mockLatestPriceUseCase = nil
        mockHistoryUseCase = nil
        mockAppRefreshUseCase = nil
        mockNavigationRouter = nil
        mockPriceFormatter = nil
        mockDetailViewStateConverter = nil
        testSubscriber = nil
        sut = nil
    }
    
    func testCreateLoadingViewState() {
        mockLatestPriceUseCase.createSubject.send(.loading)
        mockHistoryUseCase.createSubject.send(.loading)
        
        XCTAssertEqual(testSubscriber.receivedValues.last, .init(currentPriceViewState: .loading, historyViewState: .loading))
        
        XCTAssertEqual(mockLatestPriceUseCase.calls, [.create])
        XCTAssertEqual(mockHistoryUseCase.calls, [.create])
    }
    
    func testCreateErrorViewState() {
        let mockErrorViewState: ErrorViewState = .init(message: "Something went wrong", onTap: .fake)
        
        mockLatestPriceUseCase.createSubject.send(.error)
        mockHistoryUseCase.createSubject.send(.error)
        
        XCTAssertEqual(testSubscriber.receivedValues.last, .init(currentPriceViewState: .error(mockErrorViewState),
                                                                 historyViewState: .error(mockErrorViewState)))
        
        XCTAssertEqual(mockLatestPriceUseCase.calls, [.create])
        XCTAssertEqual(mockHistoryUseCase.calls, [.create])
        
        // Tap on retry button
        testSubscriber.receivedValues.last?.onTapRetryCurrentPrice?.action()
        testSubscriber.receivedValues.last?.onTapRetryHistory?.action()
        
        // Call refresh use case
        XCTAssertEqual(mockAppRefreshUseCase.calls, [.refresh(feature: .latestPrice), .refresh(feature: .prices)])
    }
    
    func testCreateCurrentPriceViewState() {
        let mockDate: Date = .init(timeIntervalSince1970: 1744209548)
        
        mockLatestPriceUseCase.createSubject.send(.data(.fake(lastUpdate: mockDate)))
        mockHistoryUseCase.createSubject.send(.loading)
        
        let expectedViewState: LatestPriceCellViewState = .init(price: "70000",
                                                                flag: .down,
                                                                lastUpdate: mockDate)
        
        XCTAssertEqual(testSubscriber.receivedValues.last, .init(currentPriceViewState: .content(expectedViewState),
                                                                 historyViewState: .loading))
        
        XCTAssertEqual(mockLatestPriceUseCase.calls, [.create])
        XCTAssertEqual(mockHistoryUseCase.calls, [.create])
        XCTAssertEqual(mockPriceFormatter.calls, [.format(amount: 70_000, currency: .euro)])
    }
    
    func testCreateHistoryViewState() {
        let mockDate: Date = .init(timeIntervalSince1970: 1744209548)
        let fakeModel: BTCPriceModel.Price = .fake(date: mockDate)
        
        mockLatestPriceUseCase.createSubject.send(.loading)
        mockHistoryUseCase.createSubject.send(.data(.fake(prices: [fakeModel])))
        
        let expectedViewState: [PriceCellViewState] = [.init(id: 0, date: mockDate, price: "70000", onTap: .fake)]
        
        XCTAssertEqual(testSubscriber.receivedValues.last, .init(currentPriceViewState: .loading,
                                                                 historyViewState: .content(expectedViewState)))
        
        XCTAssertEqual(mockLatestPriceUseCase.calls, [.create])
        XCTAssertEqual(mockHistoryUseCase.calls, [.create])
        XCTAssertEqual(mockPriceFormatter.calls, [.format(amount: 80918.0, currency: .euro)])
        
        // Tap on cell
        testSubscriber.receivedValues.last?.onTapHistoryCell?.action()
        
        // We call NavigationRouter
        XCTAssertEqual(mockNavigationRouter.calls, [.gotoDestination(id: "detailView")])
        // We call sub view state converter
        XCTAssertEqual(mockDetailViewStateConverter.calls, [.create(model: fakeModel)])
    }
}

private extension PriceListViewState {
    var onTapRetryHistory: UserAction? {
        switch self.historyViewState {
        case let .error(viewState):
            return viewState.onTap
        default:
            return nil
        }
    }
    
    var onTapRetryCurrentPrice: UserAction? {
        switch self.currentPriceViewState {
        case let .error(viewState):
            return viewState.onTap
        default:
            return nil
        }
    }
    
    var onTapHistoryCell: UserAction? {
        switch self.historyViewState {
        case let .content(viewStates):
            return viewStates.first?.onTap
        default:
            return nil
        }
    }
}
