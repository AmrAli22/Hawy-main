//
//  AddUserToAuctionVideoModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 27/10/2022.
//

import Foundation


// MARK: - AddSaleAuctionModel
struct RealTimeLiveModel: Codable {
    
    let id: Int?
    let name, mobile, image, code: String?
    let isSpeaker, raiseHand, subscription, video_status: Bool?
    let otp: String?
    let auctionID: Int?
    let cardID: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, mobile, image, code, video_status
        case isSpeaker = "is_speaker"
        case raiseHand = "raise_hand"
        case subscription, otp
        case auctionID = "auction_id"
        case cardID = "card_id"
    }
    
}

// MARK: - AddSaleAuctionModel
struct AddUserToAuctionVideoModel: Codable {
    let code: Int?
    let message: String?
    let item: AddUserToAuctionVideoItem?
}

// MARK: - Item
struct AddUserToAuctionVideoItem: Codable {
    let id: Int?
    let name, mobile, image, code: String?
    let isSpeaker, raiseHand, subscription: Bool?
    let otp: String?

    enum CodingKeys: String, CodingKey {
        case id, name, mobile, image, code
        case isSpeaker = "is_speaker"
        case raiseHand = "raise_hand"
        case subscription, otp
    }
}

// Video token
// MARK: - AddSaleAuctionModel
struct VideoTokenModel: Codable {
    let code: Int?
    let message: String?
    let item: VideoTokenItem?
}

// MARK: - Item
struct VideoTokenItem: Codable {
    let token, channelName: String?
    let currentUser, owner: VideoTokenCurrentUser?

    enum CodingKeys: String, CodingKey {
        case token, channelName
        case currentUser = "current_user"
        case owner
    }
}

// MARK: - CurrentUser
struct VideoTokenCurrentUser: Codable {
    let id: Int?
    let name, mobile, image, code: String?
    let isSpeaker, raiseHand, subscription, video_status: Bool?
    let otp: String?

    enum CodingKeys: String, CodingKey {
        case id, name, mobile, image, code
        case isSpeaker = "is_speaker"
        case raiseHand = "raise_hand"
        case subscription, otp, video_status
    }
}

//getAllRaiseRequests
// MARK: - AddSaleAuctionModel
struct AllRaiseRequestsVideoModel: Codable {
    let code: Int?
    let message: String?
    let item: [AllRaiseRequestsVideoItem]?
}

// MARK: - Item
struct AllRaiseRequestsVideoItem: Codable {
    let id: Int?
    let name, mobile, image, code: String?
    let isSpeaker, raiseHand, subscription: Bool?
    let otp: String?

    enum CodingKeys: String, CodingKey {
        case id, name, mobile, image, code
        case isSpeaker = "is_speaker"
        case raiseHand = "raise_hand"
        case subscription, otp
    }
}
