//
//  ServiceEndpoints.swift
//  combineApp
//
//  Created by Ahmed on 1/15/22.
//

import Foundation

public typealias Headers = [String: String]
public typealias Parameter = [String: Any]

// if you wish you can have multiple services like this in a project
enum PurchaseServiceEndpoints {
    
  // organise all the end points here for clarity
    case fetchData
    
  // gave a default timeout but can be different for each.
    var requestTimeOut: Int {
        return 20
    }
    
    //specify the type of HTTP request
    var httpMethod: HTTPMethodCombine {
        switch self {
        case .fetchData:
            return .GET
        }
    }
    
  // compose the NetworkRequest
    
//    func createRequest(token: String, environment: Environment) -> NetworkRequest {
//        var headers: Headers = [:]
//        headers["Content-Type"] = "application/json"
//        headers["Authorization"] = "Bearer \(token)"
//        return NetworkRequest(url: getURL(from: environment), headers: headers, reqBody: requestBody, httpMethod: httpMethod)
//    }
    
    func fetchData(environment: Environment) -> NetworkRequest {
        var headers: Headers = [:]
        headers["Content-Type"]     = "application/json"
        headers["Accept"]           = "application/json"
        //headers["Accept-Language"]  = AppLocalization.currentAppleLanguage()
        
        return NetworkRequest(url: getURL(from: environment), headers: headers, reqBody: requestBody, httpMethod: .GET)
    }
    
    // encodable request body for POST
    var requestBody: Encodable? { //Encodable? //Parameter
        switch self {
        case .fetchData:
            return nil
        }
    }
    
    // compose urls for each request
    func getURL(from environment: Environment) -> String {
        let baseUrl = environment.purchaseServiceBaseUrl
        switch self {
        
        case .fetchData:
            return baseUrl
        }
        
    }
    
}
