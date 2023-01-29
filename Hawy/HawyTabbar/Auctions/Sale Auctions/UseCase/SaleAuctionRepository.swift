//
//  SaleAuctionRepository.swift
//  Hawy
//
//  Created by ahmed abu elregal on 25/09/2022.
//

import Foundation
import Combine

protocol SaleAuctionAPIProtocol {
    func myAuctions(type: String?) -> AnyPublisher<MyAuctionModel?, APIError>
}

class SaleAuctionAPI: BaseAPIService<HomeNetwork>, SaleAuctionAPIProtocol {
    
    func myAuctions(type: String?) -> AnyPublisher<MyAuctionModel?, APIError> {
        FetchData(target: .myAuctions(type: type), responseClass: MyAuctionModel.self)
    }
    
}
