//
//  SubscriptionModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 25/10/2022.
//

import Foundation

// MARK: - AddSaleAuctionModel
struct SubmitSubscriptionModel: Codable {
    let code: Int?
    let message: String?
}

// MARK: - AddSaleAuctionModel
struct SubscriptionModel: Codable {
    let code: Int?
    let message: String?
    let item: [SubscriptionItem]?
}

// MARK: - Item
struct SubscriptionItem: Codable {
    let id: Int?
    let name, itemDescription, star, currency: String?
    let price: String?
    let expiredDate: String?
    let categoryNumber: String?
    let categoeies: [SubscriptionCategoey]?

    enum CodingKeys: String, CodingKey {
        case id, name, currency
        case itemDescription = "description"
        case star, price
        case expiredDate = "expired_date"
        case categoryNumber = "category_number"
        case categoeies
    }
}

// MARK: - Categoey
struct SubscriptionCategoey: Codable {
    let id: Int?
    let name, color, image: String?
    let hasSub, hasSubscription: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, color, image
        case hasSub = "has_sub"
        case hasSubscription = "has_subscription"
    }
}
