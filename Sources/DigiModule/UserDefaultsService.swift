//
//  UserDefaultsService.swift
//  PromCoreKit
//
//  Created by v.vasylyda on 23.12.2020.
//

import Foundation

final class UserDefaultsService: NSObject {
    public enum Keys: String {
        case fileUpdateDate
        case baseUrl
        case scriptName
    }

    @UserDefaultValue(key: Keys.fileUpdateDate, defaultValue: "")
    public static var fileUpdateDate: String
    
    @UserDefaultValue(key: Keys.baseUrl, defaultValue: nil)
    public static var baseUrl: String?
    
    @UserDefaultValue(key: Keys.scriptName, defaultValue: nil)
    public static var scriptName: String?
	
    #if DEBUG
    public static func debugClear() {
        $fileUpdateDate.clear()
        $baseUrl.clear()
        $scriptName.clear()
		
        print("Clear user defaults")
    }
    #endif
}
