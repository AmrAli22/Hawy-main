//
//  TypeAddedModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 31/08/2022.
//

import Foundation

// MARK: - TypeOfCardsModel
struct TypeOfCardsModel: Codable {
    let code: Int?
    let message: String?
    let item: [TypeOfCardsItem]?
    var isExpanded: Bool? = false
    
}

// MARK: - Item
struct TypeOfCardsItem: Codable {
    let id: Int?
    let name, color, image: String?
    var isExpanded: Bool? = false
    let sub: [TypeOfCardsSub]?
}

struct TypeOfCardsSub: Codable {
    let id: Int?
    let name, color, image: String?
}

