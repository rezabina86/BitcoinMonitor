//
//  URLSessionFactoryMock.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation
@testable import Bitcoin_Watcher

final class URLSessionFactoryMock: URLSessionFactoryType {
    
    enum Call: Equatable {
        case createURLSession
    }
    
    var calls: [Call] = []
    var createURLSessionReturnValue: URLSessionMock = .init()
    
    func createURLSession() -> URLSessionType {
        calls.append(.createURLSession)
        return createURLSessionReturnValue
    }
}
