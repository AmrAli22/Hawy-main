//
//  NewLiveAuctionModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 06/01/2023.
//

import Foundation
// MARK: - NewLiveAuctionModel
struct NewLiveAuctionModel: Codable {
    let code: Int?
    let message: String?
    let item: NewLiveAuctionItem?
}

// MARK: - NewLiveAuctionItem
struct NewLiveAuctionItem: Codable {
    var isExpanded: Bool = false
    let id: Int?
    let name: String?
    let startDate, endDate: Int?
    let user, conductedBy, adminNumber, subscribePrice: String?
    let currency, type, status, openPrice: String?
    let categoryID: Int?
    let cards: [Card]?
    let owner: NewLiveAuctionOwner?
    let startColor, endColor: String?
    let bidCounter: Int?
    let joinedUsers: [ShowCardDetailsJoinedUser]?

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

// MARK: - Card
struct NewLiveAuctionCard: Codable {
    var isExpanded: Bool = false
    let id, auctionID: Int?
    let type, name, price, motherName: String?
    let fatherName, age, status: String?
    var selectorStatus: Bool?
    let auctionStatus: String?
    let liveAuctionStatus: String?
    let startDate, endDate: Int?
    let currency, bidMaxPrice: String?
    let bidCounter: Int?
    let notes, conductedBy: String?
    let conductorAvailable: Bool?
    let documentationNumber: String?
    let categoryID: Int
    let categoryName, mainImage, video: String?
    let images: [String]?
    let owners, inoculations: [NewLiveAuctionOwner]?
    let joinedUsers: [ShowCardDetailsJoinedUser]?
    let owner, conductor, purchasedTo: NewLiveAuctionOwner?
    let offer: NewLiveAuctionOffer?

    enum CodingKeys: String, CodingKey {
        case id
        case auctionID = "auction_id"
        case type, name, price
        case motherName = "mother_name"
        case fatherName = "father_name"
        case age, status
        case selectorStatus = "selector_status"
        case auctionStatus = "auction_status"
        case liveAuctionStatus = "live_auction_status"
        case startDate = "start_date"
        case endDate = "end_date"
        case currency
        case bidMaxPrice = "bid_max_price"
        case bidCounter = "bid_counter"
        case notes
        case conductedBy = "conducted_by"
        case conductorAvailable = "conductor_available"
        case documentationNumber = "documentation_number"
        case conductor
        case categoryID = "category_id"
        case categoryName = "category_name"
        case mainImage = "main_image"
        case video, images, owners, inoculations
        case joinedUsers = "joined_users"
        case owner
        case purchasedTo = "purchased_to"
        case offer
    }
}

// MARK: - Owner
struct NewLiveAuctionOwner: Codable {
    let id: Int?
    let name, mobile, code: String?
    let subscription: Bool?
    let image: String?
    let currency, isoCode: String?

    enum CodingKeys: String, CodingKey {
        case id, name, mobile, code, subscription, image, currency
        case isoCode = "iso_code"
    }
}

// MARK: - Offer
struct NewLiveAuctionOffer: Codable {
    let id, userID, cardID, auctionID: Int?
    let createdAt, updatedAt, deletedAt, price: String?
    let dollar, currency: String?
    let user: NewLiveAuctionUser?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case cardID = "card_id"
        case auctionID = "auction_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case price, dollar, currency, user
    }
}

// MARK: - User
struct NewLiveAuctionUser: Codable {
    let id: Int
    let name, mobile, phoneCode, isoCode: String?
    let image, fcmToken: String?
    let offset: Int?
    let ip, lastestToken: String?

    enum CodingKeys: String, CodingKey {
        case id, name, mobile
        case phoneCode = "phone_code"
        case isoCode = "iso_code"
        case image
        case fcmToken = "fcm_token"
        case offset, ip
        case lastestToken = "lastest_token"
    }
}

struct AddSaleAuctionDataModel: Codable {
    let data: NewLiveAuctionItem?
}
