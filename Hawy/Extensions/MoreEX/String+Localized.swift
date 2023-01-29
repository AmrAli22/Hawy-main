//
//  String+Localized.swift
//  aman
//
//  Created by Enas Abdallah on 04/01/2021.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    public func localized(with arguments: [CVarArg]) -> String {
        return String(format: self.localized, locale: nil, arguments: arguments)
    }
}

public func Localized(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}
