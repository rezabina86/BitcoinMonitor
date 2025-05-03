//
//  AppRefreshUseCaseMock.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Combine
import Foundation
@testable import Bitcoin_Watcher

final class AppRefreshUseCaseMock: AppRefreshUseCaseType {
    
    enum Call: Equatable {
        case refresh(feature: AppRefreshFeature)
    }
    
    var refreshTriggered: AnyPublisher<AppRefreshFeature, Never> {
        refreshTriggeredReturnValue.eraseToAnyPublisher()
    }
    
    func refresh(feature: AppRefreshFeature) {
        calls.append(.refresh(feature: feature))
    }
    
    var calls: [Call] = []
    var refreshTriggeredReturnValue: PassthroughSubject<AppRefreshFeature, Never> = .init()
}
