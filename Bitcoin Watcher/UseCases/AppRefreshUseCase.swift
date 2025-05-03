//
//  AppRefreshUseCase.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Combine
import Foundation

enum AppRefreshFeature: Equatable {
    case prices
    case latestPrice
}

protocol AppRefreshUseCaseType {
    func refresh(feature: AppRefreshFeature)
    var refreshTriggered: AnyPublisher<AppRefreshFeature, Never> { get }
}

final class AppRefreshUseCase: AppRefreshUseCaseType {
    
    var refreshTriggered: AnyPublisher<AppRefreshFeature, Never> {
        refreshTriggeredSubject.eraseToAnyPublisher()
    }
    
    func refresh(feature: AppRefreshFeature) {
        refreshTriggeredSubject.send(feature)
    }
    
    private let refreshTriggeredSubject: PassthroughSubject<AppRefreshFeature, Never> = .init()
}
