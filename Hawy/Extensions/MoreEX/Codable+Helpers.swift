//
//  Codable+Helpers.swift
//  aman
//
//  Created by Enas Abdallah on 04/01/2021.
//

import Foundation

extension Encodable {
    func asDictionary() -> [Int: Any] {
        let serialized = (try? JSONSerialization.jsonObject(with: self.encode(), options: .allowFragments)) ?? nil
        return serialized as? [Int: Any] ?? [Int: Any]()
    }
    
    func encode() -> Data {
        return (try? JSONEncoder().encode(self)) ?? Data()
    }
}

extension Data {
    func decode<T: Codable>(_ object: T.Type) -> T? {
        return (try? JSONDecoder().decode(T.self, from: self))
    }
}

extension Encodable {
    func asDictionary2() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
