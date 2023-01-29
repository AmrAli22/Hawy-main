//
//  OTPRepository.swift
//  Hawy
//
//  Created by ahmed abu elregal on 03/09/2022.
//

import Foundation
import Combine

protocol OTPAPIProtocol {
    func otp(mobile: String?, otp: String?, countryCode: String?, isoCode: String?) -> AnyPublisher<OTPModel?, APIError>
}

class OTPAPI: BaseAPIService<AuthNetworking>, OTPAPIProtocol {
    
    func otp(mobile: String?, otp: String?, countryCode: String?, isoCode: String?) -> AnyPublisher<OTPModel?, APIError> {
        FetchData(target: .otp(mobile: mobile, otp: otp, countryCode: countryCode, isoCode: isoCode), responseClass: OTPModel.self)
    }
    
}
