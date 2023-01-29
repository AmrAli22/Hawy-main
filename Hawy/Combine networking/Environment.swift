//
//  Environment.swift
//  combineApp
//
//  Created by Ahmed on 1/15/22.
//

import Foundation

public enum Environment: String, CaseIterable {
    case development
    case staging
    case testing
    case production
}

extension Environment {
    var purchaseServiceBaseUrl: String {
        switch self {
        case .development:
            return "https://jsonplaceholder.typicode.com/"
        case .staging:
            return "https://stg-combine.com/purchaseService"
        case .testing:
            return "https://jsonplaceholder.typicode.com/"
        case .production:
            return "https://run.mocky.io/v3/4e23865c-b464-4259-83a3-061aaee400ba"
            
            
        
        }
    }
}

public enum Environment2: String, CaseIterable {
    case development
    case staging
    case testing
    case production
}

extension Environment2 {
    var purchaseServiceBaseUrl2: String {
        switch self {
        case .development:
            return "https://jsonplaceholder.typicode.com/"
        case .staging:
            return "https://stg-combine.com/purchaseService"
        case .testing:
            return "https://jsonplaceholder.typicode.com/"
        case .production:
            return "https://jsonplaceholder.typicode.com/"
            
            
        
        }
    }
}
