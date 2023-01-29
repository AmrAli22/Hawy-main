//
//  BaseViewModelProtocol.swift
//  ModerConcurrency
//
//  Created by ahmed abu elregal on 01/08/2022.
//

import Foundation
import Combine

enum ViewModelStatus : Equatable {
    case loadStart
    case dismissAlert
}

protocol ViewModelBaseProtocol {
    var loadinState : CurrentValueSubject<ViewModelStatus, Never> { get set }
    var subscriber : Set<AnyCancellable> { get }
}
