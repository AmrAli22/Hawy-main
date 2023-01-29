//
//  AddedCardDetailsModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 16/09/2022.
//

import Foundation

// MARK: - TypeOfCardsModel
struct AddedCardDetailsModel: Codable {
    let code: Int?
    let message: String?
    let item: AddedCardDetailsItem?
}

// MARK: - Item
struct AddedCardDetailsItem: Codable {
    let id, auctionID: Int?
    let name, motherName, fatherName: String?
    let price: String?
    let age, status, notes, categoryID: String?
    let categoryName, mainImage: String?
    let video: String?
    let images: [String]?
    let documentation_number: String?
    let owners, inoculations: [AddedCardDetailsInoculation]?

    enum CodingKeys: String, CodingKey {
        case id
        case auctionID = "auction_id"
        case name, price
        case motherName = "mother_name"
        case fatherName = "father_name"
        case age, status, notes
        case categoryID = "category_id"
        case categoryName = "category_name"
        case mainImage = "main_image"
        case video, images, owners, inoculations, documentation_number
    }
}

// MARK: - Inoculation
struct AddedCardDetailsInoculation: Codable {
    let id: Int?
    let name: String?
}

struct FinalAddedCardDetailsItem: Codable {
    let name: String?
    let mother_name: String?
    let father_name: String?
    let age:  String?
    let main_image:  String?
    let images: [String]?
    let video: String?
    let category_id: Int?
    let notes:  String?
    let inoculations:  Data?
    let owners:  Data?
}
