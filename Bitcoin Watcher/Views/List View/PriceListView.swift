//
//  PriceListView.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import SwiftUI
import Combine

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
                Spacer()
                
                Rectangle()
                    .frame(height: 2)
                    .background(Color.primary)
                    .cornerRadius(1)
                
                Text("Bitcoin Price History (2 Weeks)")
                    .font(.headline)
                
                createHistoryView(from: viewState.historyViewState)
            }
            .padding([.horizontal], 12)
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
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 12), count: 2)
    
    @ViewBuilder
    private func createCurrentPriceView(from viewState: PriceListViewState.CurrentPriceViewState) -> some View {
        switch viewState {
        case .loading:
            ProgressView()
        case let .error(viewState):
            ErrorView(viewState: viewState)
        case let .content(viewState):
            LatestPriceCellView(viewState: viewState)
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
                .padding(12)
            }
        }
    }
}

struct PriceListViewState: Equatable {
    let currentPriceViewState: CurrentPriceViewState
    let historyViewState: HistoryViewState
}

extension PriceListViewState {
    enum CurrentPriceViewState: Equatable {
        case loading
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
    static let empty: Self = .init(currentPriceViewState: .loading,
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
