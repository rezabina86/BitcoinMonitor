//
//  DetailView.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 10.04.25.
//

import SwiftUI

struct DetailView: View {
    let viewState: DetailViewState
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "bitcoinsign.circle.fill")
                    .foregroundStyle(Color.yellow)
                Image(systemName: "arrow.forward")
                Image(systemName: "eurosign.circle.fill")
                    .foregroundStyle(Color.blue)
            }
            
            createRow(with: "OPEN: ", value: viewState.openPrice)
            createRow(with: "HIGH: ", value: viewState.highPrice)
            createRow(with: "LOW: ", value: viewState.lowPrice)
            createRow(with: "CLOSE: ", value: viewState.closePrice)
            createRow(with: "VOLUME: ", value: viewState.volume)
            
            Spacer()
        }
        .navigationTitle(Text(viewState.date, style: .date))
    }
    
    @ViewBuilder
    private func createRow(with title: String, value: String) -> some View {
        Text(title)
            .font(.callout)
        +
        Text(value)
            .font(.callout)
            .bold()
    }
}

struct DetailViewState: Equatable {
    let date: Date
    let openPrice: String
    let highPrice: String
    let lowPrice: String
    let closePrice: String
    let volume: String
}

#Preview {
    DetailView(viewState: .init(date: .now,
                                openPrice: "80,000",
                                highPrice: "80,000",
                                lowPrice: "80,000",
                                closePrice: "80,000",
                                volume: "80,000"))
}
