//
//  AuctionStatusModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 07/10/2022.
//

import Foundation


// MARK: - AddSaleAuctionModel
struct AuctionStatusModel: Codable {
    let code: Int?
    let message: String?
    let item: AuctionStatusItem?
}

// MARK: - Item
struct AuctionStatusItem: Codable {
    let status: String?
}
