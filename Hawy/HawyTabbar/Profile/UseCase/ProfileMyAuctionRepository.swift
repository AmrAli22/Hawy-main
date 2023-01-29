//
//  ProfileMyAuctionRepository.swift
//  Hawy
//
//  Created by ahmed abu elregal on 24/09/2022.
//

import Foundation
import Combine

protocol ProfileMyAuctionAPIProtocol {
    func myAuctions(type: String?) -> AnyPublisher<MyAuctionModel?, APIError>
    func profileAuctions(id: Int?) -> AnyPublisher<MyAuctionModel?, APIError>
    func profileMyCards(type: String?, id: Int?) -> AnyPublisher<MyCardsModel?, APIError>
    func avatar() -> AnyPublisher<AvatarModel?, APIError>
}

class ProfileMyAuctionAPI: BaseAPIService<HomeNetwork>, ProfileMyAuctionAPIProtocol {
    
    func myAuctions(type: String?) -> AnyPublisher<MyAuctionModel?, APIError> {
        FetchData(target: .myAuctions(type: type), responseClass: MyAuctionModel.self)
    }
    
    func profileAuctions(id: Int?) -> AnyPublisher<MyAuctionModel?, APIError> {
        FetchData(target: .profileMyAuctions(id: id), responseClass: MyAuctionModel.self)
    }
    
    func profileMyCards(type: String?, id: Int?) -> AnyPublisher<MyCardsModel?, APIError> {
        FetchData(target: .profileMyCards(type: type, id: id), responseClass: MyCardsModel.self)
    }
    
    func avatar() -> AnyPublisher<AvatarModel?, APIError> {
        FetchData(target: .avatars, responseClass: AvatarModel.self)
    }
    
}
