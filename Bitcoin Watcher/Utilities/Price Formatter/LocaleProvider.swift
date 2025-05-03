//
//  LocaleProvider.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 02.05.25.
//

import Foundation

public protocol LocaleProviderType {
    var currentLocale: Locale { get }
}

public struct LocaleProvider: LocaleProviderType {
    public var currentLocale: Locale {
        Locale.current
    }
}
