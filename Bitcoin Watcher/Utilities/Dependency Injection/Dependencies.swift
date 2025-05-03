//
//  Dependencies.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

public func injectDependencies(into container: ContainerType) {
    container.register(in: .container) { container -> HTTPClientType in
        HTTPClient(sessionFactory: container.resolve())
    }
    
    container.register { _ -> URLSessionFactoryType in
        URLSessionFactory()
    }
    
    container.register { container -> BTCPriceServiceType in
        BTCPriceService(client: container.resolve())
    }
    
    container.register { container -> BTCPriceRepositoryType in
        BTCPriceRepository(service: container.resolve())
    }
    
    container.register { container -> BTCLatestTickServiceType in
        BTCLatestTickService(client: container.resolve())
    }
    
    container.register { container -> BTCLatestTickRepositoryType in
        BTCLatestTickRepository(service: container.resolve())
    }
    
    container.register { container -> AppTriggerFactoryType in
        AppTriggerFactory(appRefreshUseCase: container.resolve(),
                          timerFactory: container.resolve())
    }
    
    container.register(in: .weakContainer) { _ -> AppRefreshUseCaseType in
        AppRefreshUseCase()
    }
    
    container.register { _ -> TimerFactoryType in
        TimerFactory()
    }
    
    container.register { container -> BTCPriceUseCaseType in
        BTCPriceUseCase(repository: container.resolve(),
                        appTriggerFactory: container.resolve())
    }
    
    container.register { container -> BTCLatestTickUseCaseType in
        BTCLatestTickUseCase(repository: container.resolve(),
                             appTriggerFactory: container.resolve())
    }
    
    container.register { container -> PriceListViewModelFactoryType in
        PriceListViewModelFactory(latestPriceUseCase: container.resolve(),
                                  historyUseCase: container.resolve(),
                                  refreshUseCase: container.resolve(),
                                  navigationRouter: container.resolve(),
                                  priceFormatter: container.resolve(),
                                  detailViewStateConverter: container.resolve())
    }
    
    container.register(in: .weakContainer) { _ -> NavigationRouterType in
        NavigationRouter()
    }
    
    container.register { _ -> PriceFormatterType in
        PriceFormatter()
    }
    
    container.register { container -> DetailViewStateConverterType in
        DetailViewStateConverter(priceFormatter: container.resolve())
    }
}

