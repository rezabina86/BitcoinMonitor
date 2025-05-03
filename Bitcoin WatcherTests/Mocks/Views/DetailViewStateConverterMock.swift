//
//  DetailViewStateConverterMock.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 10.04.25.
//

import Foundation
@testable import Bitcoin_Watcher

final class DetailViewStateConverterMock: DetailViewStateConverterType {
    enum Call: Equatable {
        case create(model: BTCPriceModel.Price)
    }
    
    func create(from model: BTCPriceModel.Price) -> DetailViewState {
        calls.append(.create(model: model))
        return createReturnValue
    }
    
    var calls: [Call] = []
    var createReturnValue: DetailViewState = .init(date: .now, openPrice: "", highPrice: "", lowPrice: "", closePrice: "", volume: "")
}
