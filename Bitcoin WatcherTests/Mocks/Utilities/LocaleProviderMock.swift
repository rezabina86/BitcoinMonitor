//
//  LocaleProviderMock.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 02.05.25.
//

import Foundation
@testable import Bitcoin_Watcher

public final class LocaleProviderMock: LocaleProviderType {

    public init(locale: Locale = .init(identifier: "de_DE")) {
        currentLocale = locale
    }

    public var currentLocale: Locale
}
