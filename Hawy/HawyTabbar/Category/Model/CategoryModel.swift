//
//  CategoryModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 07/09/2022.
//

import Foundation
// MARK: - CategoryModel
struct CategoryModel: Codable {
    let code: Int?
    let message: String?
    let item: [CategoryData]?
}

// MARK: - Item
struct CategoryData: Codable {
    let id: Int?
    let name, color, image: String?
    let has_sub, has_subscription: Bool?
}
