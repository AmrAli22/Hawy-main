//
//   TargetType.swift
//  NetworkLayerAlamofireWithCodable
//
//  Created by Ahmed on 11/7/20.
//  Copyright © 2020 Ahmed. All rights reserved.
//

import Foundation
import Alamofire

enum  HTTPMethod: String {
    
    case get    = "GET"
    
    case post   = "POST"
    
    case put    = "PUT"
    
    case delete = "DELETE"
    
}

enum TaskRequest {
    
    case requestPlain
    
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)
    
}

protocol TargetType {
    
    var baseURL: String { get }
    
    var path   : String { get }
    
    var method : HTTPMethod { get }
    
    var task   : TaskRequest { get }
    
    var headers : [String: String]? { get }
    
}


