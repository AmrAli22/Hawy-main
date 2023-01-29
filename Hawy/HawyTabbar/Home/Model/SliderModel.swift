//
//  SliderModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 07/09/2022.
//

import Foundation
// MARK: - SliderModel
struct SliderModel: Codable {
    let code: Int?
    let message: String?
    let item: [SliderData]?
}

// MARK: - Item
struct SliderData: Codable {
    let id: Int?
    let auction_id: Int?
    let card_id: Int?
    let name, itemDescription, color, type: String?
    let image, date: String?
    let start_color: String?
    let end_color: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case itemDescription = "description"
        case color, type, image, date, start_color, end_color, auction_id, card_id
    }
}

// MARK: - SliderModel
struct SliderAuctionModel: Codable {
    let code: Int?
    let message: String?
    let item: [SliderAuctionData]?
}

// MARK: - Item
struct SliderAuctionData: Codable {
    let id: Int?
    let auction_id: Int?
    let card_id: Int?
    let name, itemDescription, color, type: String?
    let image, date: String?
    let start_color: String?
    let end_color: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case itemDescription = "description"
        case color, type, image, date, start_color, end_color, auction_id, card_id
    }
}
