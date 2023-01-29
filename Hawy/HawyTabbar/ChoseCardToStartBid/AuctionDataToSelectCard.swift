// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let auctionDataToSelectCard = try? JSONDecoder().decode(AuctionDataToSelectCard.self, from: jsonData)

import Foundation

// MARK: - AuctionDataToSelectCard
struct AuctionDataToSelectCard: Codable {
    var code: Int?
    var message: String?
    var item: AuctionDataToSelectCardItem?
}

// MARK: - Item
struct AuctionDataToSelectCardItem: Codable {
    var id: Int?
    var name: String?
    var startDate, endDate: Int?
    var user, conductedBy, adminNumber, subscribePrice: String?
    var currency, type, status, openPrice: String?
    var categoryID: Int?
    var cards: [Card]?
    var owner: Owner?
    var startColor, endColor: String?
    var bidCounter: Int?
    var joinedUsers: [JoinedUser]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case startDate = "start_date"
        case endDate = "end_date"
        case user
        case conductedBy = "conducted_by"
        case adminNumber = "admin_number"
        case subscribePrice = "subscribe_price"
        case currency, type, status
        case openPrice = "open_price"
        case categoryID = "category_id"
        case cards, owner
        case startColor = "start_color"
        case endColor = "end_color"
        case bidCounter = "bid_counter"
        case joinedUsers = "joined_users"
    }
}

// MARK: - Card
struct Card: Codable {
    var isExpanded: Bool = false
    var id, auctionID: Int?
    var type, name, price, motherName: String?
    var fatherName, age, status: String?
    var selectorStatus: Bool?
    var auctionStatus: String?
    var liveAuctionStatus: String?
    var startDate, endDate: Int?
    var currency, bidMaxPrice: String?
    var bidCounter: Int?
    var notes: String?
    var conductedBy: String?
    var conductorAvailable: Bool? // if true conductor is here
    var documentationNumber: String?
    var conductor: Owner?
    var categoryID: Int?
    var categoryName, mainImage: String?
    var video: String?
    var images: [String]?
    var owners: [Owner]?
    var inoculations: [String]?
    var joinedUsers: [JoinedUser]?
    var owner: Owner?
    var purchasedTo: Owner?
    var offer: Offer?

    enum CodingKeys: String, CodingKey {
        case id
        case auctionID = "auction_id"
        case type, name, price
        case motherName = "mother_name"
        case fatherName = "father_name"
        case age, status
        case selectorStatus = "selector_status"
        case auctionStatus = "auction_status"
        case liveAuctionStatus = "live_auction_status"
        case startDate = "start_date"
        case endDate = "end_date"
        case currency
        case bidMaxPrice = "bid_max_price"
        case bidCounter = "bid_counter"
        case notes
        case conductedBy = "conducted_by"
        case conductorAvailable = "conductor_available"
        case documentationNumber = "documentation_number"
        case conductor
        case categoryID = "category_id"
        case categoryName = "category_name"
        case mainImage = "main_image"
        case video, images, owners, inoculations
        case joinedUsers = "joined_users"
        case owner
        case purchasedTo = "purchased_to"
        case offer
    }
}

// MARK: - JoinedUser
struct JoinedUser: Codable {
    var id: Int?
    var name, mobile, image, code: String?
    var isSpeaker, raiseHand, videoStatus, subscription: Bool?
    var otp, currency, isoCode: String?
    var verify: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, mobile, image, code
        case isSpeaker = "is_speaker"
        case raiseHand = "raise_hand"
        case videoStatus = "video_status"
        case subscription, otp, currency
        case isoCode = "iso_code"
        case verify
    }
}

// MARK: - Offer
struct Offer: Codable {
    var id, userID, cardID, auctionID: Int?
    var createdAt, updatedAt: String?
    var deletedAt: String?
    var price, dollar, currency: String?
    var user: User?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case cardID = "card_id"
        case auctionID = "auction_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case price, dollar, currency, user
    }
}

// MARK: - User
struct User: Codable {
    var id: Int?
    var name, mobile, phoneCode, isoCode: String?
    var image: String?
    var fcmToken: String?
    var offset: Int?
    var ip: String?
    var lastestToken: String?

    enum CodingKeys: String, CodingKey {
        case id, name, mobile
        case phoneCode = "phone_code"
        case isoCode = "iso_code"
        case image
        case fcmToken = "fcm_token"
        case offset, ip
        case lastestToken = "lastest_token"
    }
}

// MARK: - Owner
struct Owner: Codable {
    var id: Int?
    var name, mobile, code: String?
    var subscription: Bool?
    var image, currency: String?

    enum CodingKeys: String, CodingKey {
        case id, name, mobile, code, subscription, image, currency
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
