//
//  LiveAuctionDateCheck.swift
//  Hawy
//
//  Created by ahmed abu elregal on 22/10/2022.
//

import Foundation

// MARK: - AddSaleAuctionModel
struct LiveAuctionDateCheckModel: Codable {
    let code: Int?
    let message: String?
    let item: [LiveAuctionDateCheckModelItem]?
}

// MARK: - Item
struct LiveAuctionDateCheckModelItem: Codable {
    let id, auctionID: Int?
    let day, timeFrom, timeTo: String?
    let available: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case auctionID = "auction_id"
        case day
        case timeFrom = "time_from"
        case timeTo = "time_to"
        case available
    }
}
