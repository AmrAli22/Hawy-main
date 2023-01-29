//
//  Collection+String.swift
//  aman
//
//  Created by Enas Abdallah on 04/01/2021.
//

import UIKit

//Those 2 extensions are used to chunk a text in textfield to add a sepeator charachter between each number of charachters
//ex: credit card number entry: "1234-1234-1234-1234" (chunk size : 4, seperator: -)
extension Collection {
    public func chunk(n: Int) -> [SubSequence] {
        var res: [SubSequence] = []
        var i = startIndex
        var j: Index
        while i != endIndex {
            j = index(i, offsetBy: n, limitedBy: endIndex) ?? endIndex
            res.append(self[i..<j])
            i = j
        }
        return res
    }
}

extension String {
    func chunkFormatted(withChunkSize chunkSize: Int,
                        withSeparator separator: Character) -> String {
        return self.filter { $0 != separator }.chunk(n: chunkSize)
            .map{ String($0) }.joined(separator: String(separator))
    }
}
