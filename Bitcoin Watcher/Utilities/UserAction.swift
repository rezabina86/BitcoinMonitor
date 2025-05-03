//
//  UserAction.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

public struct UserAction {

    public init(_ action: @escaping () -> Void) {
        self.init(alwaysEqual: false, action: action)
    }

    private init(alwaysEqual: Bool, action: @escaping () -> Void) {
        self.alwaysEqual = alwaysEqual
        self.action = action
    }

    public static let fake = Self(alwaysEqual: true, action: {})

    public let action: () -> Void

    private let alwaysEqual: Bool
}

extension UserAction: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        [lhs.alwaysEqual, rhs.alwaysEqual].contains(true)
    }
}
