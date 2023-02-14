//
//  BaseAPI.swift
//  NetworkLayerAlamofireWithCodable
//
//  Created by Ahmed on 11/7/20.
//  Copyright © 2020 Ahmed. All rights reserved.
//

import Foundation
import Alamofire
import Combine

class BaseAPIService<T: TargetType> {
    
    typealias AnyPublisherResult<M> = AnyPublisher<M?, APIError>
    typealias FutureResult<M> = Future<M?, APIError>
    
    /// ```
    /// Generic Base Class + Combine Concept + Future Promise
    ///
    /// ```
    ///
    /// - Returns: `etc promise(.failure(.timeout)) || promise(.success(value))`.
    ///
    
//    init(networking : AFNetworking = AFNetworking(allHostsMustBeEvaluated: true)) {
//        self.networking = networking
//    }
    
    func FetchData<M: Decodable>(target: T, responseClass: M.Type) -> AnyPublisherResult<M> {
        
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let parameters = buildParams(task: target.task)
        
        //let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        //let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        //let params = buildParameters(task: target.task)
        //let targetPath = buildTarget(target: target.path)
        //let url = (target.baseURL.desc + target.version.desc + targetPath)
        let url = target.baseURL + target.path
        
        return FutureResult<M> { [weak self] promise in
            
            AF.request(url, method: method, parameters: parameters.0, encoding: parameters.1, headers: headers, requestModifier: { $0.timeoutInterval = 20 })
                .validate(statusCode: 200...500)
                .responseDecodable(of: M.self) { response in
                    
                    print("CurrentUrlIS\(url)")
                    print("CurrentUrlParams\(parameters.0)")
                    print("CurrentUrlHeaders\(headers)")
                    print("CurrentUrlResponse\(headers)")
                    
                    switch response.result {
                        
                    case .success(let value):
                        
                        promise(.success(value))
                        
                    case .failure(let error):
                        print(error)
                        print(error.localizedDescription)
                        print(error.isConnectedToTheInternet)
                        print(error.isTimeout)
                        guard !error.isTimeout else {return promise(.failure(.timeout)) }
                        guard !error.isConnectedToTheInternet else { return promise(.failure(.noNetwork)) }
                        return promise(.failure(.general))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
    
    private func buildParams (task: TaskRequest) -> ([String:Any], ParameterEncoding) {
        
        switch task {
        
        case .requestPlain:
            return ([:], URLEncoding.default)
            
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters, encoding)
        
        }
        
    }
}

class BaseAPI<T: TargetType>{
    
    func FetchData<M: Codable>(target: T, responseClass: M.Type, completion: @escaping (Result<M?,NetworkError>) -> Void) {
        
        let method = Alamofire.HTTPMethod(rawValue: target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let parameters = buildParams(task: target.task)
        
        AF.request(target.baseURL + target.path, method: method, parameters: parameters.0, encoding: parameters.1, headers: headers).responseJSON { (response) in
            
            guard let statusCode = response.response?.statusCode else {
                
                completion(.failure(.noConnection))
                return
            }
            //MARK:- Conditions
            //if statusCode == 200
            //if statusCode >= 200 && statusCode <= 299
            //if statusCode < 300
            if statusCode >= 200 && statusCode <= 201 {

                // Successful request
                guard let theJsonResponse =  try? response.result.get() else {
                    
                    // ADD Custom Error
                    completion(.failure(.invalidResponse))
                    return
                }
                
                guard let theJsonData = try? JSONSerialization.data(withJSONObject: theJsonResponse, options: []) else {
                    
                    // ADD Custom Error
                    completion(.failure(.invalidData))
                    return
                }
                guard let theJsonObj = try? JSONDecoder().decode(M?.self, from: theJsonData) else {
                    
                    // ADD Custom Error
                    completion(.failure(.parsingJSONError))
                    return
                }
                completion(.success(theJsonObj))
            }else if statusCode == 100 {
                // ADD custom error base on status code 100
                completion(.failure(.continuee))
            }else if statusCode == 101 {
                // ADD custom error base on status code 101
                completion(.failure(.switchingProtocols))
            }else if statusCode == 102 {
                // ADD custom error base on status code 102
                completion(.failure(.processing))
            }else if statusCode == 201 {
                // ADD custom error base on status code 201
                completion(.failure(.created))
            }else if statusCode == 202 {
                // ADD custom error base on status code 202
                completion(.failure(.accepted))
            }else if statusCode == 203 {
                // ADD custom error base on status code 203
                completion(.failure(.nonAuthoritativeInformation))
            }else if statusCode == 204 {
                // ADD custom error base on status code 204
                completion(.failure(.noContent))
            }else if statusCode == 205 {
                // ADD custom error base on status code 205
                completion(.failure(.resetContent))
            }else if statusCode == 206 {
                // ADD custom error base on status code 206
                completion(.failure(.partialContent))
            }else if statusCode == 207 {
                // ADD custom error base on status code 207
                completion(.failure(.multiStatus))
            }else if statusCode == 208 {
                // ADD custom error base on status code 208
                completion(.failure(.alreadyReported))
            }else if statusCode == 209 {
                // ADD custom error base on status code 209
                completion(.failure(.notAuthenticated))
            }else if statusCode == 226 {
                // ADD custom error base on status code 226
                completion(.failure(.IMUsed))
            }else if statusCode == 300 {
                // ADD custom error base on status code 300
                completion(.failure(.multipleChoices))
            }else if statusCode == 301 {
                // ADD custom error base on status code 301
                completion(.failure(.movedPermanently))
            }else if statusCode == 302 {
                // ADD custom error base on status code 302
                completion(.failure(.found))
            }else if statusCode == 303 {
                // ADD custom error base on status code 303
                completion(.failure(.seeOther))
            }else if statusCode == 304 {
                // ADD custom error base on status code 304
                completion(.failure(.notModified))
            }else if statusCode == 305 {
                // ADD custom error base on status code 305
                completion(.failure(.useProxy))
            }else if statusCode == 306 {
                // ADD custom error base on status code 306
                completion(.failure(.switchProxy))
            }else if statusCode == 307 {
                // ADD custom error base on status code 307
                completion(.failure(.temporaryRedirect))
            }else if statusCode == 308 {
                // ADD custom error base on status code 308
                completion(.failure(.permenantRedirect))
            }else if statusCode == 400 {
                // ADD custom error base on status code 400
                completion(.failure(.noConnection))
            }else if statusCode == 401 {
                // ADD custom error base on status code 401
                completion(.failure(.unauthorized))
            }else if statusCode == 402 {
                // ADD custom error base on status code 402
                completion(.failure(.paymentRequired))
            }else if statusCode == 403 {
                // ADD custom error base on status code 403
                completion(.failure(.forbidden))
            }else if statusCode == 404 {
                // ADD custom error base on status code 404
                completion(.failure(.notFound))
            }else if statusCode == 405 {
                // ADD custom error base on status code 405
                completion(.failure(.methodNotAllowed))
            }else if statusCode == 406 {
                // ADD custom error base on status code 406
                completion(.failure(.notAcceptable))
            }else if statusCode == 407 {
                // ADD custom error base on status code 407
                completion(.failure(.proxyAuthenticationRequired))
            }else if statusCode == 408 {
                // ADD custom error base on status code 408
                completion(.failure(.requestTimeout))
            }else if statusCode == 409 {
                // ADD custom error base on status code 409
                completion(.failure(.conflict))
            }else if statusCode == 410 {
                // ADD custom error base on status code 410
                completion(.failure(.gone))
            }else if statusCode == 411 {
                // ADD custom error base on status code 411
                completion(.failure(.lengthRequired))
            }else if statusCode == 412 {
                // ADD custom error base on status code 412
                completion(.failure(.preconditionFailed))
            }else if statusCode == 413 {
                // ADD custom error base on status code 413
                completion(.failure(.payloadTooLarge))
            }else if statusCode == 414 {
                // ADD custom error base on status code 414
                completion(.failure(.URITooLong))
            }else if statusCode == 415 {
                // ADD custom error base on status code 415
                completion(.failure(.unsupportedMediaType))
            }else if statusCode == 416 {
                // ADD custom error base on status code 416
                completion(.failure(.rangeNotSatisfiable))
            }else if statusCode == 417 {
                // ADD custom error base on status code 417
                completion(.failure(.expectationFailed))
            }else if statusCode == 418 {
                // ADD custom error base on status code 418
                completion(.failure(.teapot))
            }else if statusCode == 421 {
                // ADD custom error base on status code 421
                completion(.failure(.misdirectedRequest))
            }else if statusCode == 422 {
                // ADD custom error base on status code 422
                completion(.failure(.unprocessableEntity))
            }else if statusCode == 423 {
                // ADD custom error base on status code 423
                completion(.failure(.locked))
            }else if statusCode == 424 {
                // ADD custom error base on status code 424
                completion(.failure(.failedDependency))
            }else if statusCode == 426 {
                // ADD custom error base on status code 426
                completion(.failure(.upgradeRequired))
            }else if statusCode == 428 {
                // ADD custom error base on status code 428
                completion(.failure(.preconditionRequired))
            }else if statusCode == 429 {
                // ADD custom error base on status code 429
                completion(.failure(.tooManyRequests))
            }else if statusCode == 431 {
                // ADD custom error base on status code 431
                completion(.failure(.requestHeaderFieldsTooLarge))
            }else if statusCode == 444 {
                // ADD custom error base on status code 444
                completion(.failure(.noResponse))
            }else if statusCode == 451 {
                // ADD custom error base on status code 451
                completion(.failure(.unavailableForLegalReasons))
            }else if statusCode == 495 {
                // ADD custom error base on status code 495
                completion(.failure(.SSLCertificateError))
            }else if statusCode == 496 {
                // ADD custom error base on status code 496
                completion(.failure(.SSLCertificateRequired))
            }else if statusCode == 497 {
                // ADD custom error base on status code 497
                completion(.failure(.HTTPRequestSentToHTTPSPort))
            }else if statusCode == 499 {
                // ADD custom error base on status code 499
                completion(.failure(.clientClosedRequest))
            }else if statusCode == 500 {
                // ADD custom error base on status code 500
                completion(.failure(.serverError))
            }else if statusCode == 501 {
                // ADD custom error base on status code 501
                completion(.failure(.notImplemented))
            }else if statusCode == 502 {
                // ADD custom error base on status code 502
                completion(.failure(.badGateway))
            }else if statusCode == 503 {
                // ADD custom error base on status code 503
                completion(.failure(.serviceUnavailable))
            }else if statusCode == 504 {
                // ADD custom error base on status code 504
                completion(.failure(.gatewayTimeout))
            }else if statusCode == 505 {
                // ADD custom error base on status code 505
                completion(.failure(.HTTPVersionNotSupported))
            }else if statusCode == 506 {
                // ADD custom error base on status code 506
                completion(.failure(.variantAlsoNegotiates))
            }else if statusCode == 507 {
                // ADD custom error base on status code 507
                completion(.failure(.insufficientStorage))
            }else if statusCode == 508 {
                // ADD custom error base on status code 508
                completion(.failure(.loopDetected))
            }else if statusCode == 510 {
                // ADD custom error base on status code 510
                completion(.failure(.notExtended))
            }else if statusCode == 511 {
                // ADD custom error base on status code 511
                completion(.failure(.networkAuthenticationRequired))
            }
            else{
                completion(.failure(.unknownError))
            }
            
        }
        
    }
    
    private func buildParams (task: TaskRequest) -> ([String:Any], ParameterEncoding) {
        
        switch task {
        
        case .requestPlain:
            return ([:], URLEncoding.default)
            
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters, encoding)
        
        }
        
    }
    
}
