//
//  PriceCellView.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import SwiftUI

struct PriceCellView: View {
    
    let viewState: PriceCellViewState
    
    var body: some View {
        HStack(alignment: .center) {
            Text(viewState.formattedAmount)
                .font(.callout)
                .bold()
            Spacer()
            Text(viewState.date, style: .date)
                .font(.caption)
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.primary.opacity(0.2), lineWidth: 0.5)
        )
    }
}

struct PriceCellViewState: Equatable, Identifiable {
    let id: Int
    let date: Date
    let formattedAmount: String
    let amount: Double
    let onTap: UserAction
}

#Preview {
    PriceCellView(
        viewState: .init(
            id: 0,
            date: .now,
            formattedAmount: "80,000",
            amount: 0,
            onTap: .fake
        )
    )
}
