//
//  DecoderType.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation

protocol DecoderType: AnyObject {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
}

extension JSONDecoder: DecoderType {}
