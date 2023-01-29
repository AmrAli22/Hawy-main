//
//  NetworkError.swift
//  NetworkLayerAlamofireWithCodable
//
//  Created by Ahmed on 10/2/21.
//  Copyright © 2021 Ahmed. All rights reserved.
//

import Foundation
import Alamofire

struct MessageHelper {
    
    /// General Message Handler
    struct serverError {
        static let general : String = "Bad Request"
        static let noInternet : String = "Check the Connection"
        static let timeOut : String = "Timeout"
        static let notFound : String = "No Result"
        static let serverError : String = "Internal Server Error"
    }
}

enum APIError : Error {
    case general
    case timeout
    case pageNotFound
    case noData
    case noNetwork
    case unknownError
    case serverError
    case statusMessage(message : String)
    case decodeError(String)
}

extension APIError {
    ///Description of error
    var desc: String {
        
        switch self {
        case .general:                    return MessageHelper.serverError.general
        case .timeout:                    return MessageHelper.serverError.timeOut
        case .pageNotFound:               return MessageHelper.serverError.notFound
        case .noData:                     return MessageHelper.serverError.notFound
        case .noNetwork:                  return MessageHelper.serverError.noInternet
        case .unknownError:               return MessageHelper.serverError.general
        case .serverError:                return MessageHelper.serverError.serverError
        case .statusMessage(let message): return message
        case .decodeError(let error):     return error
        }
    }
}

extension AFError {
    
    var isTimeout: Bool {
        if isSessionTaskError,
           let error = underlyingError as NSError?,
           error.code == NSURLErrorTimedOut || error.code == NSURLErrorUnknown {
            return true
        }
        return false
    }
    
    var isConnectedToTheInternet: Bool {
        if isSessionTaskError,
           let error = underlyingError as NSError?,
           error.code == NSURLErrorNotConnectedToInternet || error.code == NSURLErrorDataNotAllowed {
            return true
        }
        return false
    }
}


extension Error
{
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}

public enum NetworkError: Error
{
    case invalidResponse
    case invalidData
    case badJSON
    case noConnection
    case noData
    case notAuthenticated
    case forbidden
    case notFound
    case serverError
    case timeout
    case conflict
    case unknownError
    case parsingJSONError
    case errorMessage(text: String)
    
    case continuee
    case switchingProtocols
    case processing
    case ok
    case created
    case accepted
    case nonAuthoritativeInformation
    case noContent
    case resetContent
    case partialContent
    case multiStatus
    case alreadyReported
    case IMUsed
    case multipleChoices
    case movedPermanently
    case found
    case seeOther
    case notModified
    case useProxy
    case switchProxy
    case temporaryRedirect
    case permenantRedirect
    case unauthorized
    case paymentRequired
    case methodNotAllowed
    case notAcceptable
    case proxyAuthenticationRequired
    case requestTimeout
    case gone
    case lengthRequired
    case preconditionFailed
    case payloadTooLarge
    case URITooLong
    case unsupportedMediaType
    case rangeNotSatisfiable
    case expectationFailed
    case teapot
    case misdirectedRequest
    case unprocessableEntity
    case locked
    case failedDependency
    case upgradeRequired
    case preconditionRequired
    case tooManyRequests
    case requestHeaderFieldsTooLarge
    case noResponse
    case unavailableForLegalReasons
    case SSLCertificateError
    case SSLCertificateRequired
    case HTTPRequestSentToHTTPSPort
    case clientClosedRequest
    case notImplemented
    case badGateway
    case serviceUnavailable
    case gatewayTimeout
    case HTTPVersionNotSupported
    case variantAlsoNegotiates
    case insufficientStorage
    case loopDetected
    case notExtended
    case networkAuthenticationRequired
    
    
    init(_ error: Error)
    {
        let error: NSError = error as NSError
        if error.domain == NSURLErrorDomain
        {
            switch error.code
            {
            case NSURLErrorTimedOut:
                self = .timeout
            case NSURLErrorResourceUnavailable:
                self = .noData
            case NSURLErrorUserAuthenticationRequired:
                self = .notAuthenticated
            case NSURLErrorBadURL:
                self = .notFound
            case NSURLErrorNotConnectedToInternet:
                self = .noConnection
            case NSURLErrorCannotDecodeRawData, NSURLErrorCannotDecodeContentData, NSURLErrorCannotParseResponse:
                self = .parsingJSONError
            default:
                self = .unknownError
            }
            return
        }
        
        self = .unknownError
    }
    
    init(_ statusCode: Int)
    {
        switch statusCode
        {
        /// - continue: The server has received the request headers and the client should proceed to send the request body.
        case 100:
            self = .badJSON
        /// - switchingProtocols: The requester has asked the server to switch protocols and the server has agreed to do so.
        case 101:
            self = .switchingProtocols
            
        /// - processing: This code indicates that the server has received and is processing the request, but no response is available yet.
        case 102:
            self = .ok
        //
        // Success - 2xx
        //
        /// - ok: Standard response for successful HTTP requests.
        case 200:
            self = .ok
        /// - created: The request has been fulfilled, resulting in the creation of a new resource.
        case 201:
            self = .created
        /// - accepted: The request has been accepted for processing, but the processing has not been completed.
        case 202:
            self = .accepted
        /// - nonAuthoritativeInformation: The server is a transforming proxy (e.g. a Web accelerator) that received a 200 OK from its origin, but is returning a modified version of the origin's response.
        case 203:
            self = .nonAuthoritativeInformation
        /// - noContent: The server successfully processed the request and is not returning any content.
        case 204:
            self = .noContent
        /// - resetContent: The server successfully processed the request, but is not returning any content.
        case 205:
            self = .resetContent
        /// - partialContent: The server is delivering only part of the resource (byte serving) due to a range header sent by the client.
        case 206:
            self = .partialContent
        /// - multiStatus: The message body that follows is an XML message and can contain a number of separate response codes, depending on how many sub-requests were made.
        case 207:
            self = .multiStatus
        case 209:
            self = .notAuthenticated
        /// - alreadyReported: The members of a DAV binding have already been enumerated in a previous reply to this request, and are not being included again.
        case 208:
            self = .alreadyReported
        /// - IMUsed: The server has fulfilled a request for the resource, and the response is a representation of the result of one or more instance-manipulations applied to the current instance.
        case 226:
            self = .IMUsed
            
        //
        // Redirection - 3xx
        //
        
        /// - multipleChoices: Indicates multiple options for the resource from which the client may choose
        case 300:
            self = .multipleChoices
        /// - movedPermanently: This and all future requests should be directed to the given URI.
        case 301:
            self = .movedPermanently
        /// - found: The resource was found.
        case 302:
            self = .found
        /// - seeOther: The response to the request can be found under another URI using a GET method.
        case 303:
            self = .seeOther
        /// - notModified: Indicates that the resource has not been modified since the version specified by the request headers If-Modified-Since or If-None-Match.
        case 304:
            self = .notModified
        /// - useProxy: The requested resource is available only through a proxy, the address for which is provided in the response.
        case 305:
            self = .useProxy
        /// - switchProxy: No longer used. Originally meant "Subsequent requests should use the specified proxy.
        case 306:
            self = .switchProxy
        /// - temporaryRedirect: The request should be repeated with another URI.
        case 307:
            self = .temporaryRedirect
        /// - permenantRedirect: The request and all future requests should be repeated using another URI.
        case 308:
            self = .permenantRedirect
        //
        // Client Error - 4xx
        //
        /// - badRequest: The server cannot or will not process the request due to an apparent client error.
        case 400:
            self = .noConnection
        /// - forbidden: The request was a valid request, but the server is refusing to respond to it.
        case 403:
            self = .forbidden
        /// - notFound: The requested resource could not be found but may be available in the future.
        case 404:
            self = .notFound
            
        /// - unauthorized: Similar to 403 Forbidden, but specifically for use when authentication is required and has failed or has not yet been provided.
        case 401:
            self = .unauthorized
        /// - paymentRequired: The content available on the server requires payment.
        case 402:
            self = .paymentRequired
        /// - methodNotAllowed: A request method is not supported for the requested resource. e.g. a GET request on a form which requires data to be presented via POST
        case 405:
            self = .methodNotAllowed
        /// - notAcceptable: The requested resource is capable of generating only content not acceptable according to the Accept headers sent in the request.
        case 406:
            self = .notAcceptable
        /// - proxyAuthenticationRequired: The client must first authenticate itself with the proxy.
        case 407:
            self = .proxyAuthenticationRequired
        /// - requestTimeout: The server timed out waiting for the request.
        case 408:
            self = .requestTimeout
        /// - conflict: Indicates that the request could not be processed because of conflict in the request, such as an edit conflict between multiple simultaneous updates.
        case 409:
            self = .conflict
        /// - gone: Indicates that the resource requested is no longer available and will not be available again.
        case 410:
            self = .gone
        /// - lengthRequired: The request did not specify the length of its content, which is required by the requested resource.
        case 411:
            self = .lengthRequired
        /// - preconditionFailed: The server does not meet one of the preconditions that the requester put on the request.
        case 412:
            self = .preconditionFailed
        /// - payloadTooLarge: The request is larger than the server is willing or able to process.
        case 413:
            self = .payloadTooLarge
        /// - URITooLong: The URI provided was too long for the server to process.
        case 414:
            self = .URITooLong
        /// - unsupportedMediaType: The request entity has a media type which the server or resource does not support.
        case 415:
            self = .unsupportedMediaType
        /// - rangeNotSatisfiable: The client has asked for a portion of the file (byte serving), but the server cannot supply that portion.
        case 416:
            self = .rangeNotSatisfiable
        /// - expectationFailed: The server cannot meet the requirements of the Expect request-header field.
        case 417:
            self = .expectationFailed
        /// - teapot: This HTTP status is used as an Easter egg in some websites.
        case 418:
            self = .teapot
        /// - misdirectedRequest: The request was directed at a server that is not able to produce a response.
        case 421:
            self = .misdirectedRequest
        /// - unprocessableEntity: The request was well-formed but was unable to be followed due to semantic errors.
        case 422:
            self = .unprocessableEntity
        /// - locked: The resource that is being accessed is locked.
        case 423:
            self = .locked
        /// - failedDependency: The request failed due to failure of a previous request (e.g., a PROPPATCH).
        case 424:
            self = .failedDependency
        /// - upgradeRequired: The client should switch to a different protocol such as TLS/1.0, given in the Upgrade header field.
        case 426:
            self = .upgradeRequired
        /// - preconditionRequired: The origin server requires the request to be conditional.
        case 428:
            self = .preconditionRequired
        /// - tooManyRequests: The user has sent too many requests in a given amount of time.
        case 429:
            self = .tooManyRequests
        /// - requestHeaderFieldsTooLarge: The server is unwilling to process the request because either an individual header field, or all the header fields collectively, are too large.
        case 431:
            self = .requestHeaderFieldsTooLarge
        /// - noResponse: Used to indicate that the server has returned no information to the client and closed the connection.
        case 444:
            self = .noResponse
        /// - unavailableForLegalReasons: A server operator has received a legal demand to deny access to a resource or to a set of resources that includes the requested resource.
        case 451:
            self = .unavailableForLegalReasons
        /// - SSLCertificateError: An expansion of the 400 Bad Request response code, used when the client has provided an invalid client certificate.
        case 495:
            self = .SSLCertificateError
        /// - SSLCertificateRequired: An expansion of the 400 Bad Request response code, used when a client certificate is required but not provided.
        case 496:
            self = .SSLCertificateRequired
        /// - HTTPRequestSentToHTTPSPort: An expansion of the 400 Bad Request response code, used when the client has made a HTTP request to a port listening for HTTPS requests.
        case 497:
            self = .HTTPRequestSentToHTTPSPort
        /// - clientClosedRequest: Used when the client has closed the request before the server could send a response.
        case 499:
            self = .clientClosedRequest
        //
        // Server Error - 5xx
        //
        
        /// - internalServerError: A generic error message, given when an unexpected condition was encountered and no more specific message is suitable.
        case 500:
            self = .serverError
        /// - notImplemented: The server either does not recognize the request method, or it lacks the ability to fulfill the request.
        case 501:
            self = .notImplemented
        /// - badGateway: The server was acting as a gateway or proxy and received an invalid response from the upstream server.
        case 502:
            self = .badGateway
        /// - serviceUnavailable: The server is currently unavailable (because it is overloaded or down for maintenance). Generally, this is a temporary state.
        case 503:
            self = .serviceUnavailable
        /// - gatewayTimeout: The server was acting as a gateway or proxy and did not receive a timely response from the upstream server.
        case 504:
            self = .gatewayTimeout
        /// - HTTPVersionNotSupported: The server does not support the HTTP protocol version used in the request.
        case 505:
            self = .HTTPVersionNotSupported
        /// - variantAlsoNegotiates: Transparent content negotiation for the request results in a circular reference.
        case 506:
            self = .variantAlsoNegotiates
        /// - insufficientStorage: The server is unable to store the representation needed to complete the request.
        case 507:
            self = .insufficientStorage
        /// - loopDetected: The server detected an infinite loop while processing the request.
        case 508:
            self = .loopDetected
        /// - notExtended: Further extensions to the request are required for the server to fulfill it.
        case 510:
            self = .notExtended
        /// - networkAuthenticationRequired: The client needs to authenticate to gain network access.
        case 511:
            self = .networkAuthenticationRequired
        default:
            self = .unknownError
        }
    }
}

extension NetworkError: LocalizedError
{
    public var errorDescription: String?
    {
        switch self {
        
        case .invalidResponse:
            return NSLocalizedString("Invalid response from a server, please try again", comment: "")
        case .invalidData:
            return NSLocalizedString("The data received from the server wa invalid, please try again", comment: "")
        case .badJSON:
            return NSLocalizedString("The data from the server is dammeged, status: 100", comment: "")
        case .noConnection:
            return NSLocalizedString("Please check your internet connection and try again, status: 400", comment: "")
        case .noData:
            let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName, status: ") as? String ?? ""
            return NSLocalizedString("can not get data from \(appName) server, status: ", comment: "")
        case .notAuthenticated:
            let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
            return NSLocalizedString("please check your authorization with, status: 209", comment: "") + appName
        case .forbidden:
            return NSLocalizedString("forbidden: The request was a valid request, but the server is refusing to respond to it., status: 403", comment: "")
        case .notFound:
            return NSLocalizedString("seemes That your connection request un-avaliable link, status: 404", comment: "")
        case .serverError:
            return NSLocalizedString("server error, status: 500", comment: "")
        case .timeout:
            return NSLocalizedString("It took us too long to load the data, please try again later, status: ", comment: "")
        case .conflict:
            return NSLocalizedString("server conflict error, status: 409", comment: "")
            
        case .parsingJSONError:
            return NSLocalizedString("CHECK YOUR MODEL KEYS AND VALUES, status: ", comment: "")
        case .errorMessage(text: let text):
            return text
        case .continuee:
            return NSLocalizedString("continue: The server has received the request headers and the client should proceed to send the request body., status: ", comment: "")
        case .switchingProtocols:
            return NSLocalizedString("switchingProtocols: The requester has asked the server to switch protocols and the server has agreed to do so, status: 101", comment: "")
        case .processing:
            return NSLocalizedString("processing: This code indicates that the server has received and is processing the request, but no response is available yet., status: ", comment: "")
        case .ok:
            return NSLocalizedString("ok: Standard response for successful HTTP requests., status: 102", comment: "")
        case .created:
            return NSLocalizedString("created: The request has been fulfilled, resulting in the creation of a new resource., status: 201", comment: "")
        case .accepted:
            return NSLocalizedString("accepted: The request has been accepted for processing, but the processing has not been completed., status: 202", comment: "")
        case .nonAuthoritativeInformation:
            return NSLocalizedString("nonAuthoritativeInformation: The server is a transforming proxy (e.g. a Web accelerator) that received a 200 OK from its origin, but is returning a modified version of the origin's response., status: 203", comment: "")
        case .noContent:
            return NSLocalizedString("noContent: The server successfully processed the request and is not returning any content., status: 204", comment: "")
        case .resetContent:
            return NSLocalizedString("resetContent: The server successfully processed the request, but is not returning any content., status: 205", comment: "")
        case .partialContent:
            return NSLocalizedString("partialContent: The server is delivering only part of the resource (byte serving) due to a range header sent by the client., status: 206", comment: "")
        case .multiStatus:
            return NSLocalizedString("multiStatus: The message body that follows is an XML message and can contain a number of separate response codes, depending on how many sub-requests were made., status: 207", comment: "")
        case .alreadyReported:
            return NSLocalizedString("alreadyReported: The members of a DAV binding have already been enumerated in a previous reply to this request, and are not being included again., status: 208", comment: "")
        case .IMUsed:
            return NSLocalizedString("IMUsed: The server has fulfilled a request for the resource, and the response is a representation of the result of one or more instance-manipulations applied to the current instance., status: 226", comment: "")
        case .multipleChoices:
            return NSLocalizedString("multipleChoices: Indicates multiple options for the resource from which the client may choose, status: 300", comment: "")
        case .movedPermanently:
            return NSLocalizedString("movedPermanently: This and all future requests should be directed to the given URI., status: 301", comment: "")
        case .found:
            return NSLocalizedString("found: The resource was found., status: 302", comment: "")
        case .seeOther:
            return NSLocalizedString("seeOther: The response to the request can be found under another URI using a GET method., status: 303", comment: "")
        case .notModified:
            return NSLocalizedString("notModified: Indicates that the resource has not been modified since the version specified by the request headers If-Modified-Since or If-None-Match., status: 304", comment: "")
        case .useProxy:
            return NSLocalizedString("useProxy: The requested resource is available only through a proxy, the address for which is provided in the response., status: 305", comment: "")
        case .switchProxy:
            return NSLocalizedString("switchProxy: No longer used. Originally meant 'Subsequent requests should use the specified proxy'., status: 306", comment: "")
        case .temporaryRedirect:
            return NSLocalizedString("temporaryRedirect: The request should be repeated with another URI., status: 307", comment: "")
        case .permenantRedirect:
            return NSLocalizedString("permenantRedirect: The request and all future requests should be repeated using another URI., status: 308", comment: "")
        case .unauthorized:
            return NSLocalizedString("unauthorized: Similar to 403 Forbidden, but specifically for use when authentication is required and has failed or has not yet been provided., status: 401", comment: "")
        case .paymentRequired:
            return NSLocalizedString("paymentRequired: The content available on the server requires payment., status: 308", comment: "")
        case .methodNotAllowed:
            return NSLocalizedString("methodNotAllowed: A request method is not supported for the requested resource. e.g. a GET request on a form which requires data to be presented via POST, status: 405", comment: "")
        case .notAcceptable:
            return NSLocalizedString("notAcceptable: The requested resource is capable of generating only content not acceptable according to the Accept headers sent in the request., status: 406", comment: "")
        case .proxyAuthenticationRequired:
            return NSLocalizedString("proxyAuthenticationRequired: The client must first authenticate itself with the proxy., status: 407", comment: "")
        case .requestTimeout:
            return NSLocalizedString("requestTimeout: The server timed out waiting for the request., status: 408", comment: "")
        case .gone:
            return NSLocalizedString("gone: Indicates that the resource requested is no longer available and will not be available again., status: 410", comment: "")
        case .lengthRequired:
            return NSLocalizedString("lengthRequired: The request did not specify the length of its content, which is required by the requested resource., status: 411", comment: "")
        case .preconditionFailed:
            return NSLocalizedString("preconditionFailed: The server does not meet one of the preconditions that the requester put on the request., status: 412", comment: "")
        case .payloadTooLarge:
            return NSLocalizedString("payloadTooLarge: The request is larger than the server is willing or able to process., status: 413", comment: "")
        case .URITooLong:
            return NSLocalizedString("URITooLong: The URI provided was too long for the server to process., status: 414", comment: "")
        case .unsupportedMediaType:
            return NSLocalizedString("unsupportedMediaType: The request entity has a media type which the server or resource does not support., status: 415", comment: "")
        case .rangeNotSatisfiable:
            return NSLocalizedString("rangeNotSatisfiable: The client has asked for a portion of the file (byte serving), but the server cannot supply that portion., status: 416", comment: "")
        case .expectationFailed:
            return NSLocalizedString("expectationFailed: The server cannot meet the requirements of the Expect request-header field., status: 417", comment: "")
        case .teapot:
            return NSLocalizedString("teapot: This HTTP status is used as an Easter egg in some websites., status: 418", comment: "")
        case .misdirectedRequest:
            return NSLocalizedString("misdirectedRequest: The request was directed at a server that is not able to produce a response., status: 421", comment: "")
        case .unprocessableEntity:
            return NSLocalizedString("unprocessableEntity: The request was well-formed but was unable to be followed due to semantic errors., status: 422", comment: "")
        case .locked:
            return NSLocalizedString("locked: The resource that is being accessed is locked., status: 423", comment: "")
        case .failedDependency:
            return NSLocalizedString("failedDependency: The request failed due to failure of a previous request (e.g., a PROPPATCH)., status: 424", comment: "")
        case .upgradeRequired:
            return NSLocalizedString("upgradeRequired: The client should switch to a different protocol such as TLS/1.0, given in the Upgrade header field., status: 426", comment: "")
        case .preconditionRequired:
            return NSLocalizedString("preconditionRequired: The origin server requires the request to be conditional., status: 428", comment: "")
        case .tooManyRequests:
            return NSLocalizedString("tooManyRequests: The user has sent too many requests in a given amount of time., status: 429", comment: "")
        case .requestHeaderFieldsTooLarge:
            return NSLocalizedString("requestHeaderFieldsTooLarge: The server is unwilling to process the request because either an individual header field, or all the header fields collectively, are too large., status: 431", comment: "")
        case .noResponse:
            return NSLocalizedString("noResponse: Used to indicate that the server has returned no information to the client and closed the connection., status: 444", comment: "")
        case .unavailableForLegalReasons:
            return NSLocalizedString("unavailableForLegalReasons: A server operator has received a legal demand to deny access to a resource or to a set of resources that includes the requested resource., status: 451", comment: "")
        case .SSLCertificateError:
            return NSLocalizedString("SSLCertificateError: An expansion of the 400 Bad Request response code, used when the client has provided an invalid client certificate., status: 495", comment: "")
        case .SSLCertificateRequired:
            return NSLocalizedString("SSLCertificateRequired: An expansion of the 400 Bad Request response code, used when a client certificate is required but not provided., status: 496", comment: "")
        case .HTTPRequestSentToHTTPSPort:
            return NSLocalizedString("HTTPRequestSentToHTTPSPort: An expansion of the 400 Bad Request response code, used when the client has made a HTTP request to a port listening for HTTPS requests., status: 497", comment: "")
        case .clientClosedRequest:
            return NSLocalizedString("clientClosedRequest: Used when the client has closed the request before the server could send a response., status: 499", comment: "")
        case .notImplemented:
            return NSLocalizedString("notImplemented: The server either does not recognize the request method, or it lacks the ability to fulfill the request., status: 501", comment: "")
        case .badGateway:
            return NSLocalizedString("badGateway: The server was acting as a gateway or proxy and received an invalid response from the upstream server., status: 502", comment: "")
        case .serviceUnavailable:
            return NSLocalizedString("serviceUnavailable: The server is currently unavailable (because it is overloaded or down for maintenance). Generally, this is a temporary state., status: 503", comment: "")
        case .gatewayTimeout:
            return NSLocalizedString("gatewayTimeout: The server was acting as a gateway or proxy and did not receive a timely response from the upstream server., status: 504", comment: "")
        case .HTTPVersionNotSupported:
            return NSLocalizedString("HTTPVersionNotSupported: The server does not support the HTTP protocol version used in the request., status: 505", comment: "")
        case .variantAlsoNegotiates:
            return NSLocalizedString("variantAlsoNegotiates: Transparent content negotiation for the request results in a circular reference., status: 506", comment: "")
        case .insufficientStorage:
            return NSLocalizedString("insufficientStorage: The server is unable to store the representation needed to complete the request., status: 507", comment: "")
        case .loopDetected:
            return NSLocalizedString("loopDetected: The server detected an infinite loop while processing the request., status: 508", comment: "")
        case .notExtended:
            return NSLocalizedString("notExtended: Further extensions to the request are required for the server to fulfill it., status: 510", comment: "")
        case .networkAuthenticationRequired:
            return NSLocalizedString("networkAuthenticationRequired: The client needs to authenticate to gain network access., status: 511", comment: "")
        default:
            return NSLocalizedString("There is something wrong please try again later, status: ", comment: "")
            
        }
    }
}
