//
//  UploadImagesAndVideoModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 08/09/2022.
//

import Foundation

// MARK: - UploadImagesAndVideoModel
struct UploadImagesAndVideoModel: Codable {
    let code: Int?
    let message: String?
    let item: UploadImagesAndVideoData?
}

// MARK: - Item
struct UploadImagesAndVideoData: Codable {
    let mainImage, videos: String?
    let images: [String]?

    enum CodingKeys: String, CodingKey {
        case mainImage = "main_image"
        case videos, images
    }
}

// MARK: - Image
struct Image: Codable {
    let id: Int?
    let file: String?
}
