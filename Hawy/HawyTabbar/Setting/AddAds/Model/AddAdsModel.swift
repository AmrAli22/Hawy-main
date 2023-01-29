//
//  AddAdsModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 05/10/2022.
//

import Foundation

// MARK: - AddSaleAuctionModel
struct AddAdsModel: Codable {
    let code: Int?
    let message: String?
    let item: AddAdsItem?
}

// MARK: - Item
struct AddAdsItem: Codable {
    let id: Int?
    let adTitle, adDescription: String?
    let userID: Int?
    let userName: String?
    let cardID: Int?
    let cardName, cardImage, startColor, endColor: String?
    let srartDate, endDate, paymentMethod: String?
    let price: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case adTitle = "ad_title"
        case adDescription = "ad_description"
        case userID = "user_id"
        case userName = "user_name"
        case cardID = "card_id"
        case cardName = "card_name"
        case cardImage = "card_image"
        case startColor = "start_color"
        case endColor = "end_color"
        case srartDate = "srart_date"
        case endDate = "end_date"
        case price
        case paymentMethod = "payment_method"
    }
}
