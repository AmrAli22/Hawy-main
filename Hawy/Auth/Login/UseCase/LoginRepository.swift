//
//  LoginRepository.swift
//  Hawy
//
//  Created by ahmed abu elregal on 03/09/2022.
//

import Foundation
import Combine

protocol LoginAPIProtocol {
    func register(mobile: String?, name: String?, countryCode: String?, isoCode: String?) -> AnyPublisher<RegisterModel?, APIError>
}

class LoginAPI: BaseAPIService<AuthNetworking>, LoginAPIProtocol {
    
    func register(mobile: String?, name: String?, countryCode: String?, isoCode: String?) -> AnyPublisher<RegisterModel?, APIError> {
        FetchData(target: .login(mobile: mobile, name: name, countryCode: countryCode, isoCode: isoCode), responseClass: RegisterModel.self)
    }
    
}
