//
//  MyAuctionsModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 24/09/2022.
//

import Foundation


//// MARK: - MyCardsModel
//struct MyAuctionModel: Codable {
//    let code: Int?
//    let message: String?
//    let item: [MyAuctionItem]?
//}
//
//// MARK: - Item
//struct MyAuctionItem: Codable {
//    let id: Int?
//    let name: String?
//    let startDate, endDate: Int?
//    let user: String?
//    let subscribePrice: Int?
//    let type, status: String?
//    let cards: [MyAuctionCard]?
//    let owner: MyAuctionOwner?
//    let startColor, endColor: String?
//    let bidCounter: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name
//        case startDate = "start_date"
//        case endDate = "end_date"
//        case user
//        case subscribePrice = "subscribe_price"
//        case type, status, cards, owner
//        case startColor = "start_color"
//        case endColor = "end_color"
//        case bidCounter = "bid_counter"
//    }
//}
//
//// MARK: - Card
//struct MyAuctionCard: Codable {
//    let id, auctionID: Int?
//    let name: String?
//    let price: Double?
//    let motherName, fatherName, age, status: String?
//    let startDate, endDate, bidCounter: Int?
//    let notes: String?
//    let categoryID: Int?
//    let categoryName, mainImage, video: String?
//    let images: [String]?
//    let owners, inoculations: [MyAuctionInoculation]?
//    let owner: MyAuctionOwner?
//    let purchasedTo: MyAuctionOwner?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case auctionID = "auction_id"
//        case name, price
//        case motherName = "mother_name"
//        case fatherName = "father_name"
//        case age, status
//        case startDate = "start_date"
//        case endDate = "end_date"
//        case bidCounter = "bid_counter"
//        case notes
//        case categoryID = "category_id"
//        case categoryName = "category_name"
//        case mainImage = "main_image"
//        case video, images, owners, inoculations, owner
//        case purchasedTo = "purchased_to"
//    }
//}
//
//// MARK: - Inoculation
//struct MyAuctionInoculation: Codable {
//    let id: Int?
//    let name: String?
//}
//
//// MARK: - Owner
//struct MyAuctionOwner: Codable {
//    let id: Int?
//    let name, mobile, code: String?
//    let subscription: Bool?
//    let image: String?
//}
////////////////
// MARK: - AddSaleAuctionModel
struct MyAuctionModel: Codable {
    let code: Int?
    let message: String?
    let item: [MyAuctionItem]?
}

// MARK: - Item
struct MyAuctionItem: Codable {
    var isExpanded: Bool = false
    let id: Int?
    let name: String?
    let startDate, endDate: Int?
    let user: String?
    let subscribePrice: String?
    let type, status: String?
    let cards: [MyAuctionCard]?
    let owner: MyAuctionOwner?
    let startColor, endColor: String?
    let bidCounter: Int?

    enum CodingKeys: String, CodingKey {
        case id, name
        case startDate = "start_date"
        case endDate = "end_date"
        case user
        case subscribePrice = "subscribe_price"
        case type, status, cards, owner
        case startColor = "start_color"
        case endColor = "end_color"
        case bidCounter = "bid_counter"
    }
}

// MARK: - Card
struct MyAuctionCard: Codable {
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
    let owners, inoculations: [MyAuctionInoculation]?
    let owner: MyAuctionOwner?
    let purchasedTo:  MyAuctionOwner?

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

// MARK: - Inoculation
struct MyAuctionInoculation: Codable {
    let id: Int?
    let name: String?
}

// MARK: - Owner
struct MyAuctionOwner: Codable {
    let id: Int?
    let name, mobile, code: String?
    let subscription: Bool?
    let image: String?
}


//// MARK: - MyAuctionModel
//struct MyAuctionModel: Codable {
//    let code: Int?
//    let message: String?
//    let item: [MyAuctionItem]?
//}
//
//// MARK: - Item
//struct MyAuctionItem: Codable {
//    let id: Int?
//    let name: String?
//    let startDate, endDate: Int?
//    let user, type, status: String?
//    let cards: [MyAuctionCard]?
//    let owner: MyAuctionOwner?
//    let startColor, endColor: String?
//    let bidCounter: Int
//
//    enum CodingKeys: String, CodingKey {
//        case id, name
//        case startDate = "start_date"
//        case endDate = "end_date"
//        case user, type, status, cards, owner
//        case startColor = "start_color"
//        case endColor = "end_color"
//        case bidCounter = "bid_counter"
//    }
//}
//
//// MARK: - Card
//struct MyAuctionCard: Codable {
//    let id, auctionID: Int?
//    let name, motherName, fatherName: String?
//    let price: Double?
//    let age, status: String?
//    let startDate, endDate: Int?
//    let notes: String?
//    let categoryID: Int?
//    let categoryName, mainImage, video: String?
//    let images: [String]?
//    let owners, inoculations: [MyAuctionInoculation]?
//    let owner: MyAuctionOwner?
//    //let purchasedTo: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case auctionID = "auction_id"
//        case name, price
//        case motherName = "mother_name"
//        case fatherName = "father_name"
//        case age, status
//        case startDate = "start_date"
//        case endDate = "end_date"
//        case notes
//        case categoryID = "category_id"
//        case categoryName = "category_name"
//        case mainImage = "main_image"
//        case video, images, owners, inoculations, owner
//        //case purchasedTo = "purchased_to"
//    }
//}
//
//// MARK: - Inoculation
//struct MyAuctionInoculation: Codable {
//    let id: Int?
//    let name: String?
//}
//
//// MARK: - Owner
//struct MyAuctionOwner: Codable {
//    let id: Int?
//    let name, mobile, code: String?
//    let subscription: Bool?
//    let image: String?
//}
