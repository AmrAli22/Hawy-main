//
//  MyCardsModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 24/09/2022.
//

import Foundation
// MARK: - MyCardsModel
struct MyCardsModel: Codable {
    let code: Int?
    let message: String?
    let item: DataItem?
}

// MARK: - Item
struct DataItem: Codable {
    let maxSelection: String?
    let cards: [MyCardsItem]?

    enum CodingKeys: String, CodingKey {
        case maxSelection = "max_selection"
        case cards
    }
}

// MARK: - Item
struct MyCardsItem: Codable {
    let id, auctionID: Int?
    let name, motherName, fatherName: String?
    var price: String?
    let age, status: String?
    let startDate, endDate: Int?
    let notes: String?
    let categoryID: Int?
    let categoryName, mainImage, video: String?
    let images: [String]?
    let owners, inoculations: [MyCardsInoculation]?
    let owner: MyCardsOwner?
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
        case notes
        case categoryID = "category_id"
        case categoryName = "category_name"
        case mainImage = "main_image"
        case video, images, owners, inoculations, owner
        case purchasedTo = "purchased_to"
    }
}

// MARK: - Inoculation
struct MyCardsInoculation: Codable {
    let id: Int?
    let name: String?
}

// MARK: - Owner
struct MyCardsOwner: Codable {
    let id: Int?
    let name, mobile, code: String?
    let subscription: Bool?
    let image: String?
}
