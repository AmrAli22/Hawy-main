//
//  SubCategoryModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 07/09/2022.
//

import Foundation

// MARK: - SubCategoryModel
struct SubCategoryModel: Codable {
    let code: Int?
    let message: String?
    let item: [SubCategoryData]?
}

// MARK: - Item
struct SubCategoryData: Codable {
    let id: Int?
    let name, color, image: String?
}
