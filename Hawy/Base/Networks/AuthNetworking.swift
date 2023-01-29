//
//  AuthNetworking.swift
//  Hawy
//
//  Created by ahmed abu elregal on 03/09/2022.
//

import Foundation
import Alamofire

enum AuthNetworking {
    case register(mobile: String?, name: String?, countryCode: String?, isoCode: String?)
    case otp(mobile: String?, otp: String?, countryCode: String?, isoCode: String?)
    case login(mobile: String?, name: String?, countryCode: String?, isoCode: String?)
}

extension AuthNetworking: TargetType {
    var baseURL: String {
        return "https://hawy-kw.com/api"
    }
    
    var path: String {
        switch self {
        case .register:
            return "/auth/register"
        case.otp:
            return "/auth/login"
        case .login:
            return "/auth/otp"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .register:
            return .post
        case .otp:
            return .post
        case .login:
            return .post
        }
    }
    
    var task: TaskRequest {
        switch self {
        case .register(let mobile, let name, let countryCode, let isoCode):
            return .requestParameters(parameters: ["mobile": mobile ?? "", "name": name ?? "", "code": countryCode ?? "", "iso_code": isoCode ?? ""], encoding: JSONEncoding.default)
        case .otp(let mobile, let otp, let countryCode, let isoCode):
            return .requestParameters(parameters: ["mobile": mobile ?? "", "otp": otp ?? "", "code": countryCode ?? "", "iso_code": isoCode ?? ""], encoding: JSONEncoding.default)
        case .login(let mobile, let name, let countryCode, let isoCode):
            return .requestParameters(parameters: ["mobile": mobile ?? "", "name": name ?? "", "code": countryCode ?? "", "iso_code": isoCode ?? ""], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .register:
            return [
                "Content-Type":"application/json",
                "Accept":"application/json",
                "Accept-Language":AppLocalization.currentAppleLanguage(),
                "offset": "\(HelperConstant.getOffst() ?? 0)"
            ]
        case .otp:
            return [
                "Content-Type":"application/json",
                "Accept":"application/json",
                "Accept-Language":AppLocalization.currentAppleLanguage(),
                "offset": "\(HelperConstant.getOffst() ?? 0)"
            ]
        case .login:
            return [
                "Content-Type":"application/json",
                "Accept":"application/json",
                "Accept-Language":AppLocalization.currentAppleLanguage(),
                "offset": "\(HelperConstant.getOffst() ?? 0)"
            ]
        default:
            return [
                "Content-Type":"application/json",
                "Accept":"application/json",
                "Accept-Language":AppLocalization.currentAppleLanguage(),
                "offset": "\(HelperConstant.getOffst() ?? 0)"
            ]
        }
    }
}
