//
//  PopularQuestionsModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 04/10/2022.
//

import Foundation
// MARK: - AddSaleAuctionModel
struct PopularQuestionsModel: Codable {
    let code: Int?
    let message: String?
    let item: [PopularQuestionsItem]?
}

// MARK: - Item
struct PopularQuestionsItem: Codable {
    let id: Int?
    let name, answer: String?
    
    var expand:Bool? = false
    
}
