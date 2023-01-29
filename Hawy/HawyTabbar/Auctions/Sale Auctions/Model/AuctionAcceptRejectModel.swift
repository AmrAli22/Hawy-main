//
//  AuctionAcceptRejectModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 10/10/2022.
//

import Foundation

// MARK: - AddSaleAuctionModel
struct AuctionAcceptRejectModelModel: Codable {
    let code: Int?
    let message: String?
    let item: AuctionAcceptRejectModelItem?
}

// MARK: - Item
struct AuctionAcceptRejectModelItem: Codable {
    let id: Int?
    let name: String?
    let startDate, endDate: Int?
    let user: String?
    let subscribePrice: String?
    let type, status: String?
    let cards: [MyAuctionCard]?
    let owner: AuctionAcceptRejectModelOwner?
    let startColor, endColor: String?
    let bidCounter: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, cards
        case startDate = "start_date"
        case endDate = "end_date"
        case user
        case subscribePrice = "subscribe_price"
        case type, status, owner
        case startColor = "start_color"
        case endColor = "end_color"
        case bidCounter = "bid_counter"
    }
}

// MARK: - Owner
struct AuctionAcceptRejectModelOwner: Codable {
    let id: Int?
    let name, mobile, code: String?
    let subscription: Bool?
    let image: String?
}
