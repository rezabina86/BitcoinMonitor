//
//  LatestPriceCellView.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import SwiftUI

struct LatestPriceCellView: View {
    let viewState: LatestPriceCellViewState
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "bitcoinsign.circle.fill")
                        .foregroundStyle(Color.yellow)
                    Image(systemName: "arrow.forward")
                    Image(systemName: "eurosign.circle.fill")
                        .foregroundStyle(Color.blue)
                }
                
                Text("Last updated: ")
                    .font(.caption)
                +
                Text(viewState.lastUpdate, style: .time)
                    .font(.caption)
                    .bold()
                
                
                
                HStack {
                    flag
                    Text(viewState.price)
                        .font(.callout)
                        .bold()
                        .foregroundStyle(priceColor)
                }
            }
            Spacer()
        }
        .padding([.horizontal], 8)
        .padding([.vertical], 4)
    }
    
    @ViewBuilder
    private var flag: some View {
        switch viewState.flag {
        case .up:
            Image(systemName: "chevron.up")
                .foregroundStyle(Color.green)
                .bold()
        case .down:
            Image(systemName: "chevron.down")
                .foregroundStyle(Color.red)
                .bold()
        case .unchanged:
            EmptyView()
        }
    }
    
    private var priceColor: Color {
        switch viewState.flag {
        case .up:
            Color.green
        case .down:
            Color.red
        case .unchanged:
            Color.primary
        }
    }
}

struct LatestPriceCellViewState: Equatable {
    let price: String
    let flag: Flag
    let lastUpdate: Date
}

extension LatestPriceCellViewState {
    enum Flag: Equatable {
        case up
        case down
        case unchanged
    }
}

#Preview {
    LatestPriceCellView(viewState: .init(
        price: "80,000",
        flag: .unchanged,
        lastUpdate: .now)
    )
}
