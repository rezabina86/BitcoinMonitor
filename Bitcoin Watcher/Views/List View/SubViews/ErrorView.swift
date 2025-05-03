//
//  ErrorView.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import SwiftUI

struct ErrorView: View {
    let viewState: ErrorViewState
    
    var body: some View {
        VStack {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.red)
            Text(viewState.message)
            Button("Retry") {
                viewState.onTap.action()
            }
        }
        .cornerRadius(12)
    }
}

struct ErrorViewState: Equatable {
    let message: String
    let onTap: UserAction
}

#Preview {
    ErrorView(viewState: .init(message: "Something went wrong",
                               onTap: .fake))
}
