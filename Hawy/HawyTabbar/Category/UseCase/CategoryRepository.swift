//
//  CategoryRepository.swift
//  Hawy
//
//  Created by ahmed abu elregal on 07/09/2022.
//

import Foundation
import Combine

protocol CategoryAPIProtocol {
    func category() -> AnyPublisher<CategoryModel?, APIError>
}

class CategoryAPI: BaseAPIService<HomeNetwork>, CategoryAPIProtocol {
    
    func category() -> AnyPublisher<CategoryModel?, APIError> {
        FetchData(target: .categories, responseClass: CategoryModel.self)
    }
    
}
