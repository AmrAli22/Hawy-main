//
//  NotificationModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 04/11/2022.
//

import Foundation


// MARK: - AddSaleAuctionModel
struct NotificationModel: Codable {
    let code: Int?
    let message: String?
    let item: [NotificationItem]?
}

// MARK: - Item
struct NotificationItem: Codable {
    let id: Int?
    let title, message, type: String?
    let seen: Int?
    let createdAt, image: String?
    let card: Int?
    let auction_id: Int?

    enum CodingKeys: String, CodingKey {
        case id, title, message, type, seen
        case createdAt = "created_at"
        case image, card, auction_id
    }
}
