//
//  RegisterModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 03/09/2022.
//

import Foundation
// MARK: - RegisterModel
struct RegisterModel: Codable {
    let code: Int?
    let message: String?
    let item: OTPItem? // OTPItem //Item
}

// MARK: - Item
struct Item: Codable {
    let mobileNumber, countryCode: String?
    let otp: Int?
    let verify: Bool?

    enum CodingKeys: String, CodingKey {
        case mobileNumber = "mobile_number"
        case otp, verify
        case countryCode = "code"
    }
}
