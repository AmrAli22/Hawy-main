//
//  BidModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 06/10/2022.
//

import Foundation

//// MARK: - AddSaleAuctionModel
//struct BidModel: Codable {
//    let code: Int?
//    let message: String?
//    let item: BidItem?
//}
//
//// MARK: - Item
//struct BidItem: Codable {
//    let id, userID, cardID, auctionID: Int?
//    let createdAt, updatedAt, deletedAt: String?
//    let price: Double?
//    let user: BidUser
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case userID = "user_id"
//        case cardID = "card_id"
//        case auctionID = "auction_id"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case deletedAt = "deleted_at"
//        case price, user
//    }
//}
//
//// MARK: - User
//struct BidUser: Codable {
//    let id: Int?
//    let name, mobile, phoneCode, image: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, mobile
//        case phoneCode = "phone_code"
//        case image
//    }
//}

// MARK: - AddSaleAuctionModel
struct BidModel: Codable {
    let code: Int?
    let message: String?
    let item: BidItem?
}

// MARK: - Item
struct BidItem: Codable {
    let minimumBiding: Int?
    let offer: BidOffer?

    enum CodingKeys: String, CodingKey {
        case minimumBiding = "minimum_biding"
        case offer
    }
}

// MARK: - Offer
struct BidOffer: Codable {
    let id, userID, cardID, auctionID: Int?
    let createdAt, updatedAt, deletedAt: String?
    let price: String?
    let currency: String?
    //let minimumBidding: Double?
    let user: BidUser?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case cardID = "card_id"
        case auctionID = "auction_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case price, currency
        //case minimumBidding = "minimum_bidding"
        case user
    }
}

// MARK: - User
struct BidUser: Codable {
    let id: Int?
    let name, mobile, phoneCode, image: String?
    let fcmToken: String?

    enum CodingKeys: String, CodingKey {
        case id, name, mobile
        case phoneCode = "phone_code"
        case image
        case fcmToken = "fcm_token"
    }
}
