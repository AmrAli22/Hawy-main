//
//  StockAuctionModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 07/10/2022.
//

import Foundation
// MARK: - AddSaleAuctionModel
struct StockAuctionModel: Codable {
    let code: Int?
    let message: String?
    let item: [StockAuctionItem]?
}

// MARK: - Item
struct StockAuctionItem: Codable {
    var isExpanded: Bool = false
    let id: Int?
    let itemDescription, day: String?
    let startDate, endDate: Int?
    let type, status, numberOfUsers, numberOfCards: String?
    let numberOfJoinedCards, usersRemainNumber: Int?
    let startPrice: String?
    let subscribePrice: String?
    let cards: [StockAuctionCard]?
    let startColor, endColor: String?
    let bidCounter: Int?
    let category_id: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case itemDescription = "description"
        case day
        case startDate = "start_date"
        case endDate = "end_date"
        case type, status, category_id
        case numberOfUsers = "number_of_users"
        case numberOfCards = "number_of_cards"
        case numberOfJoinedCards = "number_of_joined_cards"
        case usersRemainNumber = "users_remain_number"
        case startPrice = "start_price"
        case subscribePrice = "subscribe_price"
        case cards
        case startColor = "start_color"
        case endColor = "end_color"
        case bidCounter = "bid_counter"
    }
}

// MARK: - Card
struct StockAuctionCard: Codable {
    let id, auctionID: Int?
    let name: String?
    let price: String?
    let motherName, fatherName, age, status: String?
    let startDate, endDate: Int?
    let bidMaxPrice: String?
    let bidCounter: Int?
    let notes: String?
    let categoryID: Int?
    let categoryName, mainImage, video: String?
    let images: [String]?
    let owners, inoculations: [MyCardsInoculation]?
    let owner: StockAuctionOwner?
    let purchasedTo: MyCardsOwner?

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
        case categoryID = "category_id"
        case categoryName = "category_name"
        case mainImage = "main_image"
        case video, images, owners, inoculations, owner
        case purchasedTo = "purchased_to"
    }
}

// MARK: - Owner
struct StockAuctionOwner: Codable {
    let id: Int?
    let name, mobile, code: String?
    let subscription: Bool?
    let image: String?
}
