//
//  AddliveAuctionModel.swift
//  Hawy
//
//  Created by Amr Ali on 22/01/2023.
//

import Foundation

// MARK: - AddLiveAuctionModel
struct AddLiveAuctionModel: Codable {
    var code: Int?
    var message: String?
    var item: AddLiveAuctionModelItem?
}

// MARK: - Item
struct AddLiveAuctionModelItem: Codable {
    var id: Int?
    var name: String?
    var startDate, endDate: Int?
    var user, conductedBy, adminNumber, subscribePrice: String?
    var currency, type, status, openPrice: String?
    var categoryID: Int?
    var cards: [Card]?
    var owner: Owner?
    var startColor, endColor: String?
    var bidCounter: Int?
    var joinedUsers: [JoinedUser]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case startDate = "start_date"
        case endDate = "end_date"
        case user
        case conductedBy = "conducted_by"
        case adminNumber = "admin_number"
        case subscribePrice = "subscribe_price"
        case currency, type, status
        case openPrice = "open_price"
        case categoryID = "category_id"
        case cards, owner
        case startColor = "start_color"
        case endColor = "end_color"
        case bidCounter = "bid_counter"
        case joinedUsers = "joined_users"
    }
}
//
//// MARK: - Card
//struct Card: Codable {
//    var id, auctionID: Int?
//    var type, name, price, motherName: String?
//    var fatherName, age, status: String?
//    var selectorStatus: Bool?
//    var auctionStatus: String?
//    var liveAuctionStatus: JSONNull?
//    var startDate, endDate: Int?
//    var currency, bidMaxPrice: String?
//    var bidCounter: Int?
//    var notes: JSONNull?
//    var conductedBy: String?
//    var conductorAvailable: Bool?
//    var documentationNumber, conductor: JSONNull?
//    var categoryID: Int?
//    var categoryName, mainImage: String?
//    var video: JSONNull?
//    var images: [JSONAny]?
//    var owners: [Owner]?
//    var inoculations, joinedUsers: [JSONAny]?
//    var owner: Owner?
//    var purchasedTo, offer: JSONNull?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case auctionID = "auction_id"
//        case type, name, price
//        case motherName = "mother_name"
//        case fatherName = "father_name"
//        case age, status
//        case selectorStatus = "selector_status"
//        case auctionStatus = "auction_status"
//        case liveAuctionStatus = "live_auction_status"
//        case startDate = "start_date"
//        case endDate = "end_date"
//        case currency
//        case bidMaxPrice = "bid_max_price"
//        case bidCounter = "bid_counter"
//        case notes
//        case conductedBy = "conducted_by"
//        case conductorAvailable = "conductor_available"
//        case documentationNumber = "documentation_number"
//        case conductor
//        case categoryID = "category_id"
//        case categoryName = "category_name"
//        case mainImage = "main_image"
//        case video, images, owners, inoculations
//        case joinedUsers = "joined_users"
//        case owner
//        case purchasedTo = "purchased_to"
//        case offer
//    }
//}
//
//// MARK: - Owner
//struct Owner: Codable {
//    var id: Int?
//    var name, mobile, code: String?
//    var subscription: Bool?
//    var image, currency, isoCode: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, mobile, code, subscription, image, currency
//        case isoCode = "iso_code"
//    }
//}
