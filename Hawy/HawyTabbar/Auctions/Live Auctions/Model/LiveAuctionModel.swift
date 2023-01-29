//
//  LiveAuctionModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 27/10/2022.
//

import Foundation

// MARK: - AddSaleAuctionModel
struct LiveAuctionModel: Codable {
    let code: Int?
    let message: String?
    let item: [LiveAuctionItem]?
}

// MARK: - Item
struct LiveAuctionItem: Codable {
    let id: Int?
    let name: String?
    let startDate, endDate: Int?
    let user, conductedBy, adminNumber: String?
    let subscribePrice: String?
    let type, status: String?
    let cards: [LiveAuctionCard]?
    let owner: LiveAuctionOwner?
    let startColor, endColor: String?
    let bidCounter: Int?
    let joinedUsers: [LiveAuctionJoinedUser]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case startDate = "start_date"
        case endDate = "end_date"
        case user
        case conductedBy = "conducted_by"
        case adminNumber = "admin_number"
        case subscribePrice = "subscribe_price"
        case type, status, cards, owner
        case startColor = "start_color"
        case endColor = "end_color"
        case bidCounter = "bid_counter"
        case joinedUsers = "joined_users"
    }
}

// MARK: - Card
struct LiveAuctionCard: Codable {
    let id, auctionID: Int?
    let name: String?
    let price: String?
    let motherName, fatherName, age, status: String?
    let startDate, endDate, bidCounter: Int?
    let bidMaxPrice: String?
    let notes, conductedBy: String?
    let categoryID: Int?
    let categoryName, mainImage, video: String?
    let images: [String]?
    let owners, inoculations: [MyCardsInoculation]?
    let joinedUsers: [LiveAuctionJoinedUser]?
    let owner, purchasedTo: LiveAuctionOwner?

    enum CodingKeys: String, CodingKey {
        case id
        case auctionID = "auction_id"
        case name, price
        case motherName = "mother_name"
        case fatherName = "father_name"
        case age, status
        case startDate = "start_date"
        case endDate = "end_date"
        case bidMaxPrice = "bid_max_price"
        case bidCounter = "bid_counter"
        case notes
        case conductedBy = "conducted_by"
        case categoryID = "category_id"
        case categoryName = "category_name"
        case mainImage = "main_image"
        case video, images, owners, inoculations
        case joinedUsers = "joined_users"
        case owner
        case purchasedTo = "purchased_to"
    }
}

// MARK: - Owner
struct LiveAuctionOwner: Codable {
    let id: Int?
    let name, mobile, code: String?
    let subscription: Bool?
    let image: String?
}

// MARK: - JoinedUser
struct LiveAuctionJoinedUser: Codable {
    let id: Int?
    let name, mobile, image, code: String?
    let isSpeaker, raiseHand, subscription: Bool?
    let otp: String?

    enum CodingKeys: String, CodingKey {
        case id, name, mobile, image, code
        case isSpeaker = "is_speaker"
        case raiseHand = "raise_hand"
        case subscription, otp
    }
}
