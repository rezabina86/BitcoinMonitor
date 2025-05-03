//
//  PriceListView.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import SwiftUI
import Combine
import Charts

struct PriceListView: View {
    
    init(viewModel: PriceListViewModelType) {
        self.viewModel = viewModel
        
        viewModel.currentNavigationPath
            .receive(on: RunLoop.main)
            .assign(to: \.currentNavigationPath, on: self)
            .store(in: &subscriptions)
    }
    
    var body: some View {
        NavigationStack(
            path: .init(
                get: {
                    return currentNavigationPath
                },
                set: {
                    viewModel.setNavigationCurrentPath($0)
                }
            )
        ) {
            VStack(alignment: .center) {
                createCurrentPriceView(from: viewState.currentPriceViewState)
                createHistoryView(from: viewState.historyViewState)
                Spacer()
            }
            .padding([.horizontal], 12)
            .ignoresSafeArea(edges: .bottom)
            .navigationDestination(
                for: NavigationDestination.self
            ) { route in
                destination(for: route)
            }
            .navigationBarHidden(true)
        }
        .task {
            for await vs in viewModel.viewState.values {
                self.viewState = vs
            }
        }
    }
    
    @State private var viewState: PriceListViewState = .empty
    @ObservedState private var currentNavigationPath: NavigationPath = .init()
    private var subscriptions: Set<AnyCancellable> = []
    private let viewModel: PriceListViewModelType
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 12), count: 1)
    
    @ViewBuilder
    private func createCurrentPriceView(from viewState: PriceListViewState.CurrentPriceViewState) -> some View {
        switch viewState {
        case let .error(viewState):
            ErrorView(viewState: viewState)
        case let .content(viewState):
            LatestPriceCellView(viewState: viewState)
                .animation(.easeInOut(duration: 0.5), value: viewState)
        }
    }
    
    @ViewBuilder
    private func createHistoryView(from viewState: PriceListViewState.HistoryViewState) -> some View {
        switch viewState {
        case .loading:
            ProgressView()
        case let .error(viewState):
            ErrorView(viewState: viewState)
        case let .content(prices):
            VStack(spacing: 12) {
                createChart(prices: prices)
                createPriceListView(prices: prices)
            }
            .padding(12)
            .animation(.easeInOut(duration: 0.5), value: viewState)
        }
    }
    
    @ViewBuilder
    private func createPriceListView(prices: [PriceCellViewState]) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(prices) { viewState in
                    Button {
                        viewState.onTap.action()
                    } label: {
                        PriceCellView(viewState: viewState)                        
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    @ViewBuilder
    private func createChart(prices: [PriceCellViewState]) -> some View {
        Chart {
            ForEach(prices) { item in
                LineMark(
                    x: .value("Date", item.date),
                    y: .value("Price", item.amount)
                )
                .interpolationMethod(.monotone)
                .foregroundStyle(.orange)
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { value in
                AxisValueLabel(format: .dateTime.day())
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartYScale(domain: prices.map(\.amount).min()!...prices.map(\.amount).max()!)
        .chartPlotStyle { plotArea in
            plotArea
                .padding(.trailing, 16)
        }
        .aspectRatio(1.7, contentMode: .fit)
    }
}

struct PriceListViewState: Equatable {
    let currentPriceViewState: CurrentPriceViewState
    let historyViewState: HistoryViewState
}

extension PriceListViewState {
    enum CurrentPriceViewState: Equatable {
        case error(ErrorViewState)
        case content(LatestPriceCellViewState)
    }
    
    enum HistoryViewState: Equatable {
        case loading
        case error(ErrorViewState)
        case content([PriceCellViewState])
    }
}

extension PriceListViewState {
    static let empty: Self = .init(currentPriceViewState: .content(.init(price: "", flag: .unchanged, lastUpdate: .now)),
                                   historyViewState: .loading)
}

private extension View {
    @ViewBuilder
    func destination(for destination: NavigationDestination) -> some View {
        switch destination {
        case let .detailView(viewState):
            DetailView(viewState: viewState)
        case .none:
            EmptyView()
        }
    }
}
