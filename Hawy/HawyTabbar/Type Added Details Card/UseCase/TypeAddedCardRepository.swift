//
//  TypeAddedCardRepository.swift
//  Hawy
//
//  Created by ahmed abu elregal on 16/09/2022.
//

import Foundation
import Combine

protocol TypeAddedCardAPIProtocol {
    func getcategoryAndSub() -> AnyPublisher<TypeOfCardsModel?, APIError>
}

class TypeAddedCardAPI: BaseAPIService<HomeNetwork>, TypeAddedCardAPIProtocol {
    
    func getcategoryAndSub() -> AnyPublisher<TypeOfCardsModel?, APIError> {
        FetchData(target: .categoryAndSub, responseClass: TypeOfCardsModel.self)
    }
    
}
