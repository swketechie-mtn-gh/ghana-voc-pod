//
//  UserDefaultWrapper.swift
//  PromCoreKit
//
//  Created by v.vasylyda on 23.12.2020.
//

import Foundation

private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}

// MARK: - Values

@propertyWrapper public struct UserDefaultValue<Value> {
    public let key: String
    public let defaultValue: Value
    public var container: UserDefaults = .standard

    public init<Key: RawRepresentable>(key: Key,
                                       defaultValue: Value,
                                       container: UserDefaults = .standard) where Key.RawValue == String {
        self.key = key.rawValue
        self.defaultValue = defaultValue
        self.container = container
    }
    
    public var projectedValue: Self { return self }
    
    public var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                container.removeObject(forKey: key)
            } else {
                container.set(newValue, forKey: key)
            }
            
        }
    }
    
    public func clear() {
        container.removeObject(forKey: key)
    }
}
