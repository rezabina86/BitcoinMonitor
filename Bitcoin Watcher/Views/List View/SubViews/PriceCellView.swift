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
        VStack(alignment: .center) {
            Text(viewState.date, style: .date)
                .font(.caption)
            
            Text(viewState.price)
                .font(.callout)
                .bold()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 64)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.primary, lineWidth: 1 / 2)
        )
    }
}

struct PriceCellViewState: Equatable, Identifiable {
    let id: Int
    let date: Date
    let price: String
    let onTap: UserAction
}

#Preview {
    PriceCellView(
        viewState: .init(
            id: 0,
            date: .now,
            price: "80,000",
            onTap: .fake
        )
    )
}
