//
//  Container.swift
//  Bitcoin Watcher
//
//  Created by Reza Bina on 09.04.25.
//

import Foundation

public enum Scope {
    case `default`
    case container
    case weakContainer
}

public protocol ContainerType: AnyObject {
    func register<T>(in scope: Scope, builder: @escaping (ContainerType) -> T)
    func resolve<T>() -> T
}

public extension ContainerType {
    func register<T>(builder: @escaping (ContainerType) -> T) {
        register(in: .default, builder: builder)
    }
}

public final class Container: ContainerType {

    public init() {}

    public func register<T>(in scope: Scope, builder: @escaping (ContainerType) -> T) {
        let key = String(reflecting: T.self)

        instances[key] = nil
        weakInstances.removeObject(forKey: key as NSString)

        factories[key] = Factory(scope: scope, build: builder)
    }

    public func resolve<T>() -> T {
        let key = String(reflecting: T.self)

        guard let factory = factories[key] else {
            fatalError("no factory found for \(key)")
        }

        switch factory.scope {
        case .default:
            return factory.build(self) as! T
        case .container:
            if let instance = instances[key] as? T {
                return instance
            } else {
                instances[key] = factory.build(self)
                return instances[key] as! T
            }
        case .weakContainer:
            let key = key as NSString
            if let instance = weakInstances.object(forKey: key) as? T {
                return instance
            } else {
                let instance = factory.build(self)
                weakInstances.setObject(instance as AnyObject, forKey: key)
                return instance as! T
            }
        }
    }

    private struct Factory {
        let scope: Scope
        let build: (ContainerType) -> Any
    }

    private var factories: [String: Factory] = [:]
    private var instances: [String: Any] = [:]
    private var weakInstances = NSMapTable<NSString, AnyObject>(
        keyOptions: [.copyIn],
        valueOptions: [.weakMemory]
    )
}
