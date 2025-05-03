//
//  PriceListViewModel.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Combine
import SwiftUI
import Foundation

protocol PriceListViewModelFactoryType {
    func create() -> PriceListViewModelType
}

struct PriceListViewModelFactory: PriceListViewModelFactoryType {
    let latestPriceUseCase: BTCLatestTickUseCaseType
    let historyUseCase: BTCPriceUseCaseType
    let refreshUseCase: AppRefreshUseCaseType
    let navigationRouter: NavigationRouterType
    let priceFormatter: PriceFormatterType
    let detailViewStateConverter: DetailViewStateConverterType
    
    func create() -> PriceListViewModelType {
        PriceListViewModel(latestPriceUseCase: latestPriceUseCase,
                           historyUseCase: historyUseCase,
                           refreshUseCase: refreshUseCase,
                           navigationRouter: navigationRouter,
                           priceFormatter: priceFormatter,
                           detailViewStateConverter: detailViewStateConverter)
    }
}

protocol PriceListViewModelType {
    var viewState: AnyPublisher<PriceListViewState, Never> { get }
    
    // Navigation
    var currentNavigationPath: AnyPublisher<NavigationPath, Never> { get }
    func setNavigationCurrentPath(_ path: NavigationPath)
}

final class PriceListViewModel: PriceListViewModelType {
    
    init(latestPriceUseCase: BTCLatestTickUseCaseType,
         historyUseCase: BTCPriceUseCaseType,
         refreshUseCase: AppRefreshUseCaseType,
         navigationRouter: NavigationRouterType,
         priceFormatter: PriceFormatterType,
         detailViewStateConverter: DetailViewStateConverterType) {
        
        self.refreshUseCase = refreshUseCase
        self.navigationRouter = navigationRouter
        self.priceFormatter = priceFormatter
        self.detailViewStateConverter = detailViewStateConverter
        
        Publishers.CombineLatest(latestPriceUseCase.create(), historyUseCase.create())
            .map { [weak self] currentPrice, history -> PriceListViewState in
                guard let self else { return .empty }
                return .init(
                    currentPriceViewState: createCurrentPriceViewState(from: currentPrice),
                    historyViewState: createHistoryViewState(from: history)
                )
            }
            .assign(to: \.value, on: viewStateSubject)
            .store(in: &cancellables)
    }
    
    var viewState: AnyPublisher<PriceListViewState, Never> {
        viewStateSubject.eraseToAnyPublisher()
    }
    
    var currentNavigationPath: AnyPublisher<NavigationPath, Never> {
        navigationRouter.currentPath
    }
    
    func setNavigationCurrentPath(_ path: NavigationPath) {
        navigationRouter.setCurrentPath(path)
    }
    
    private let refreshUseCase: AppRefreshUseCaseType
    private let navigationRouter: NavigationRouterType
    private let priceFormatter: PriceFormatterType
    private let detailViewStateConverter: DetailViewStateConverterType
    private let viewStateSubject: CurrentValueSubject<PriceListViewState, Never> = .init(.empty)
    private var cancellables: Set<AnyCancellable> = []
    
    private func createCurrentPriceViewState(from dataState: BTCLatestTickDataState) -> PriceListViewState.CurrentPriceViewState {
        switch dataState {
        case .error:
            return .error(.init(
                message: "Something went wrong",
                onTap: .init { [refreshUseCase] in
                    refreshUseCase.refresh(feature: .latestPrice)
                }
            ))
        case let .data(model):
            return .content(
                .init(
                    price: priceFormatter.formate(amount: model.value,
                                                  currency: AppConfig.currentCurrency),
                    flag: .init(from: model.valueFlag),
                    lastUpdate: model.lastUpdate
                )
            )
        }
    }
    
    private func createHistoryViewState(from dataState: BTCPriceDataState) -> PriceListViewState.HistoryViewState {
        switch dataState {
        case .loading:
            return .loading
        case .error:
            return .error(.init(
                message: "Something went wrong",
                onTap: .init { [refreshUseCase] in
                    refreshUseCase.refresh(feature: .prices)
                }
            ))
        case let .data(model):
            return .content(model.prices.enumerated().map { (index, priceModel) in
                PriceCellViewState(
                    id: index,
                    date: priceModel.date,
                    formattedAmount: priceFormatter.formate(amount: priceModel.close,
                                                            currency: AppConfig.currentCurrency),
                    amount: priceModel.close,
                    onTap: .init { [detailViewStateConverter, navigationRouter] in
                        navigationRouter.gotoDestination(.detailView(viewState: detailViewStateConverter.create(from: priceModel)))
                    })
            })
        }
    }
}

private extension LatestPriceCellViewState.Flag {
    init(from model: BTCLatestTickModel.ValueFlag) {
        switch model {
        case .up:
            self = .up
        case .down:
            self = .down
        case .unChanged:
            self = .unchanged
        }
    }
}
