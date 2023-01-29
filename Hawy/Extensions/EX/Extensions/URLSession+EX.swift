//
//  URLSession+EX.swift
//  ModerConcurrency
//
//  Created by ahmed abu elregal on 03/08/2022.
//

import Foundation

extension URLSession {
    func data(from url: URL) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation({ continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let data = data,
                    let response = response
                else {
                    continuation.resume(throwing: APIError.noData)
                    return
                }
                
                continuation.resume(returning: (data, response))
                return
            }
            .resume()
        })
    }
}
