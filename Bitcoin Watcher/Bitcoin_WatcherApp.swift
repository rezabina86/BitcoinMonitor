//
//  Bitcoin_WatcherApp.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import SwiftUI

@main
struct Bitcoin_WatcherApp: App {
    init(container: ContainerType) {
        self.container = container
        configureDependencies(container)
        
        self.viewModelFactory = container.resolve()
    }
    
    init() {
        self.init(container: Container())
    }
    
    var body: some Scene {
        WindowGroup {
            PriceListView(viewModel: viewModelFactory.create())
        }
    }
    
    // MARK: - Privates
    private let container: ContainerType
    private var configureDependencies = injectDependencies
    
    private let viewModelFactory: PriceListViewModelFactoryType
}
