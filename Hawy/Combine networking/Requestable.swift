//
//  Requestable.swift
//  combineApp
//
//  Created by Ahmed on 1/15/22.
//

import Foundation
import Combine

public protocol Requestable {
    var requestTimeOut: Float { get }
    
    func request<T: Codable>(_ req: NetworkRequest) -> AnyPublisher<T, NetworkErrror>
}
