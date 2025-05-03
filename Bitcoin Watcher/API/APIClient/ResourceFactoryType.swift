//
//  ResourceFactoryType.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation

protocol ResourceFactoryType {
    static var jsonDecoder: DecoderType { get }
}

extension ResourceFactoryType {
    static var jsonDecoder: DecoderType {
        decoder
    }
}

// MARK: - JSONDecoder
private let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    return decoder
}()

