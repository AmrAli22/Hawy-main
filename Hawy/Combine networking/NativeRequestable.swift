//
//  NativeRequestable.swift
//  combineApp
//
//  Created by Ahmed on 1/15/22.
//

import Combine
import Foundation

public class NativeRequestable: Requestable {
    public var requestTimeOut: Float = 30
    
    public func request<T>(_ req: NetworkRequest) -> AnyPublisher<T, NetworkErrror>
    where T: Decodable, T: Encodable {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = TimeInterval(req.requestTimeOut ?? requestTimeOut)
        
        guard let url = URL(string: req.url) else {
            // Return a fail publisher if the url is invalid
            return AnyPublisher(
                Fail<T, NetworkErrror>(error: NetworkErrror.badURL("Invalid Url"))
            )
        }
        // We use the dataTaskPublisher from the URLSession which gives us a publisher to play around with.
        return URLSession.shared
            .dataTaskPublisher(for: req.buildURLRequest(with: url))
            .tryMap { output in
                // throw an error if response is nil
                guard let httpResponse = output.response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    switch (output.response as! HTTPURLResponse).statusCode {
                    case (401):
                        throw NetworkErrror.unauthorized(code: 401, error: "UnAuthentication")
                    case (404):
                        throw NetworkErrror.serverError(code: 404, error: "Not Found")
                    case (400...499):
                        throw NetworkErrror.serverError(code: 400, error: "StatusCode : (400...499)")
                    default:
                        throw NetworkErrror.serverError(code: 500, error: "Server error")
                    }
                    
                }
                
//                guard output.response is HTTPURLResponse else {
//                    throw NetworkError.serverError(code: (output.response as! HTTPURLResponse).statusCode, error: "Server error")
//                }
                
                print("Status Code is : \(httpResponse.statusCode)")
                
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .retry(1)
            .mapError { error in
                // return error if json decoding fails
                NetworkErrror.invalidJSON(String(describing: error.localizedDescription))
                
            }
            .eraseToAnyPublisher()
    }
    
}
