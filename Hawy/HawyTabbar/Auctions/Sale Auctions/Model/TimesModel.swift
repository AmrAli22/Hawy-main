//
//  TimesModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 07/10/2022.
//

import Foundation

// MARK: - AddSaleAuctionModel
struct TimesModel: Codable {
    let code: Int?
    let message: String?
    let item: [TimesItem]?
}

// MARK: - Item
struct TimesItem: Codable {
    let id, price: Int?
    let name: String?
}

// MARK: - AddSaleAuctionModel
struct ExtendTimesModel: Codable {
    let code: Int?
    let message: String?
    //let item: [TimesItem]?
}
