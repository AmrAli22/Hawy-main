//
//  AddSaleAuctionFromHomeRepository.swift
//  Hawy
//
//  Created by ahmed abu elregal on 25/09/2022.
//

import Foundation
import Combine

protocol AddSaleAuctionFromHomeAPIProtocol {
    func profileMyAuctions(id: Int?) -> AnyPublisher<MyAuctionModel?, APIError>
}

class AddSaleAuctionFromHomeAPI: BaseAPIService<HomeNetwork>, AddSaleAuctionFromHomeAPIProtocol {
    
    func profileMyAuctions(id: Int?) -> AnyPublisher<MyAuctionModel?, APIError> {
        FetchData(target: .profileMyAuctions(id: id), responseClass: MyAuctionModel.self)
    }
}
