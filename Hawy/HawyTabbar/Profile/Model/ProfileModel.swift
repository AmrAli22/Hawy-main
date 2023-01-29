//
//  ProfileModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 02/10/2022.
//

import Foundation

// MARK: - AddSaleAuctionModel
struct ProfileModel: Codable {
    let code: Int?
    let message: String?
    let item: ProfileItem?
}

// MARK: - Item
struct ProfileItem: Codable {
    let id: Int?
    let name, mobile, image, code: String?
    let subscription: Bool?
    let iso_code: String?
    let currency: String?
}
