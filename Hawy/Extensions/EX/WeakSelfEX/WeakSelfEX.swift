//
//  WeakSelfEX.swift
//  EverDeliever
//
//  Created by Ahmed on 3/13/22.
//

import Foundation

protocol Weakifible: class { }

extension NSObject: Weakifible { }

extension Weakifible {
    
    func weakify<T>(_ code: @escaping (Self, T) -> Void) -> (T) -> Void {
        return {
            /* Begin boilerplate */
            [weak self] (data) in
            guard let self = self else { return }
            /* End boilerplate */
            code(self, data)
        }
    }
    
}
