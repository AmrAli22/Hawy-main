//
//  RegisterRepository.swift
//  Hawy
//
//  Created by ahmed abu elregal on 03/09/2022.
//

import Foundation
import Combine

protocol RegisterAPIProtocol {
    func register(mobile: String?, name: String?, countryCode: String?, isoCode: String?) -> AnyPublisher<RegisterModel?, APIError>
}

class RegisterAPI: BaseAPIService<AuthNetworking>, RegisterAPIProtocol {
    
    func register(mobile: String?, name: String?, countryCode: String?, isoCode: String?) -> AnyPublisher<RegisterModel?, APIError> {
        FetchData(target: .register(mobile: mobile, name: name, countryCode: countryCode, isoCode: isoCode), responseClass: RegisterModel.self)
    }
    
}
