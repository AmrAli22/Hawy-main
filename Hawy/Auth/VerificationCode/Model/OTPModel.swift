//
//  OTPModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 03/09/2022.
//

import Foundation


// MARK: - OTPModel
struct OTPModel: Codable {
    let code: Int?
    let message: String?
    let data: OTPItem?
    
    enum CodingKeys: String, CodingKey {
        case code
        case message
        case data = "item"
    }
    
}

// MARK: - OTPItem
struct OTPItem: Codable {
    let id: Int?
    let name, mobile, countryCode, image: String?
    let token: String?
    let subscription: Bool?
    let currency: String?
    let verify: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case mobile
        case countryCode = "code"
        case image
        case token, subscription, currency, verify
    }
    
}
