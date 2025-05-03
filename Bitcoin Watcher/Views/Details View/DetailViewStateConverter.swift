//
//  DetailViewStateConverter.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 10.04.25.
//

protocol DetailViewStateConverterType {
    func create(from model: BTCPriceModel.Price) -> DetailViewState
}

struct DetailViewStateConverter: DetailViewStateConverterType {
    
    init(priceFormatter: PriceFormatterType) {
        self.priceFormatter = priceFormatter
    }
    
    func create(from model: BTCPriceModel.Price) -> DetailViewState {
        .init(date: model.date,
              openPrice: formatePrice(amount: model.open),
              highPrice: formatePrice(amount: model.high),
              lowPrice: formatePrice(amount: model.low),
              closePrice: formatePrice(amount: model.close),
              volume: formatePrice(amount: model.volume))
    }
    
    private let priceFormatter: PriceFormatterType
    
    private func formatePrice(amount: Double) -> String {
        priceFormatter.formate(amount: amount,
                               currency: AppConfig.currentCurrency)
    }
}
