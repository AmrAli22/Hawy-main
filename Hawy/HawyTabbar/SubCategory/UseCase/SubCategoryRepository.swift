//
//  SubCategoryRepository.swift
//  Hawy
//
//  Created by ahmed abu elregal on 07/09/2022.
//

import Foundation
import Combine

protocol SubCategoryAPIProtocol {
    func category(categoryId: Int?) -> AnyPublisher<SubCategoryModel?, APIError>
}

class SubCategoryAPI: BaseAPIService<HomeNetwork>, SubCategoryAPIProtocol {
    
    func category(categoryId: Int?) -> AnyPublisher<SubCategoryModel?, APIError> {
        FetchData(target: .subCategories(categoryId: categoryId), responseClass: SubCategoryModel.self)
    }
    
}

protocol CardsAPIProtocol {
    func cards(categoryId: Int?) -> AnyPublisher<SubCategoryModel?, APIError>
}

class CardsAPI: BaseAPIService<HomeNetwork>, CardsAPIProtocol {
    
    func cards(categoryId: Int?) -> AnyPublisher<SubCategoryModel?, APIError> {
        FetchData(target: .subCategories(categoryId: categoryId), responseClass: SubCategoryModel.self)
    }
    
}
