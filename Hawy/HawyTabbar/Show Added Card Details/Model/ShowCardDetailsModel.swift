//
//  ShowCardDetailsModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 03/10/2022.
//

import Foundation


// MARK: - AddSaleAuctionModel
struct ShowCardDetailsModel: Codable {
    let code: Int?
    let message: String?
    let item: ShowCardDetailsItem?
}

// MARK: - Item
struct ShowCardDetailsItem: Codable {
    let id, auctionID: Int?
    let name: String?
    let price: String?
    let motherName, fatherName, age, status: String?
    let startDate, endDate, bidCounter: Int?
    let bid_max_price: String?
    let notes: String?
    let categoryID: Int?
    let categoryName, mainImage, video: String?
    let documentation_number: String?
    let conductor_available: Bool?
    let images: [String]?
    let conducted_by: String?
    let conductor: ShowCardDetailsOwner?
    let owners, inoculations: [ShowCardDetailsInoculation]?
    let owner: ShowCardDetailsOwner?
    let purchasedTo: ShowCardDetailsOwner?
    let joinedUsers: [ShowCardDetailsJoinedUser]?

    enum CodingKeys: String, CodingKey {
        case id
        case auctionID = "auction_id"
        case name, price
        case motherName = "mother_name"
        case fatherName = "father_name"
        case age, status
        case startDate = "start_date"
        case endDate = "end_date"
        case bidCounter = "bid_counter"
        case notes
        case categoryID = "category_id"
        case categoryName = "category_name"
        case mainImage = "main_image"
        case video, images, owners, inoculations, owner, bid_max_price, conducted_by, conductor, documentation_number, conductor_available
        case purchasedTo = "purchased_to"
        case joinedUsers = "joined_users"
    }
}

// MARK: - Inoculation
struct ShowCardDetailsInoculation: Codable {
    let id: Int?
    let name: String?
}
// MARK: - JoinedUser
struct ShowCardDetailsJoinedUser: Codable {
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

// MARK: - Owner
struct ShowCardDetailsOwner: Codable {
    let id: Int?
    let name, mobile, code: String?
    let subscription: Bool?
    let image: String?
}
