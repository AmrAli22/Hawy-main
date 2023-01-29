//
//  AdsModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 05/10/2022.
//

import Foundation

// MARK: - AddSaleAuctionModel
struct AdsModel: Codable {
    let code: Int?
    let message: String?
    let item: [AddAdsItem]?
}


