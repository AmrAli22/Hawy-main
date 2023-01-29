//
//  AddCardFromHomeToAuctionModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 25/09/2022.
//

import Foundation

struct AddCardFromHomeToAuctionModel: Equatable, Codable {
    
    let name: String?
    let price: String?
    let id: Int?
    let image: String?
    
    var asDictionary : [String:Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
          guard let label = label else { return nil }
          return (label, value)
        }).compactMap { $0 })
        return dict
      }
    
    func toDictionary() -> [String : Any] {
        let dict: [String : Any] = ["id": id ?? 0,
                                    "price": price ?? "",
                                    "name": name ?? "",
                                    "image": image ?? ""
        ]
        return dict
    }
    
}

// MARK: - AddSaleAuctionModel
struct AddSaleAuctionModel: Codable {
    let code: Int?
    let message: String?
    let item: AddSaleAuctionItem?
}

// MARK: - Item
struct AddSaleAuctionItem: Codable {
    let id: Int?
    let name: String?
    let startDate, endDate: Int?
    let user: String?
    let conducted_by: String?
    let subscribePrice: String?
    let type, status: String?
    let cards: [AddSaleAuctionCard]?
    let owner: AddSaleAuctionOwner?
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
        case conducted_by
    }
}

// MARK: - Card
struct AddSaleAuctionCard: Codable {
    let id, auctionID: Int?
    let name: String?
    let price: String?
    let motherName, fatherName, age, status: String?
    let startDate, endDate, bidCounter: Int?
    let bidMaxPrice: String?
    let notes: String?
    let categoryID: Int?
    let conductor_available: Bool?
    let categoryName, mainImage: String?
    let conducted_by: String?
    let video: String?
    let images: [String]?
    let owners, inoculations: [AddSaleAuctionInoculation]?
    let owner: AddSaleAuctionOwner?
    let purchasedTo: AddSaleAuctionOwner?
    let type: String?
    let conductor : Owner

    enum CodingKeys: String, CodingKey {
        case id
        case auctionID = "auction_id"
        case name, price
        case motherName = "mother_name"
        case fatherName = "father_name"
        case age, status
        case startDate = "start_date"
        case endDate = "end_date"
        case bidCounter = "bid_counter"
        case notes
        case categoryID = "category_id"
        case categoryName = "category_name"
        case mainImage = "main_image"
        case bidMaxPrice = "bid_max_price"
        case video, images, owners, inoculations, owner
        case purchasedTo = "purchased_to"
        case conducted_by, conductor_available, type
        case conductor = "conductor"
    }
}

// MARK: - Inoculation
struct AddSaleAuctionInoculation: Codable {
    let id: Int?
    let name: String?
}

// MARK: - Owner
struct AddSaleAuctionOwner: Codable {
    let id: Int?
    let name, mobile, code: String?
    let subscription: Bool?
    let image: String?
}
