//
//  AddCardDetailsRepository.swift
//  Hawy
//
//  Created by ahmed abu elregal on 16/09/2022.
//

import Foundation
import Combine

protocol AddCardDetailsAPIProtocol {
    func addedCardDetails(name: String?, mother_name: String?, father_name: String?, age: String?, main_image: String?, images: [String]?, video: String?, category_id: String?, notes: String?, status: String?, inoculations: [String]?, owners: [String]?, docNum: String?) -> AnyPublisher<AddedCardDetailsModel?, APIError>
}

class AddCardDetailsAPI: BaseAPIService<HomeNetwork>, AddCardDetailsAPIProtocol {
    
    func addedCardDetails(name: String?, mother_name: String?, father_name: String?, age: String?, main_image: String?, images: [String]?, video: String?, category_id: String?, notes: String?, status: String?,inoculations: [String]?, owners: [String]?, docNum: String?) -> AnyPublisher<AddedCardDetailsModel?, APIError> {
        
        FetchData(target: .addedCardDetails(name: name, mother_name: mother_name, father_name: father_name, age: age, main_image: main_image, images: images, video: video, category_id: category_id, notes: notes, status: status, inoculations: inoculations, owners: owners, docNum: docNum), responseClass: AddedCardDetailsModel.self)
     
    }
    
    
}
