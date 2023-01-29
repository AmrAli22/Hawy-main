//
//  SaleAuctionViewModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 25/09/2022.
//

import Foundation
import Combine

protocol SaleAuctionViewModelProtocol: AnyObject {
    
    var saleAuctionsModel: MyAuctionModel? { get }
    var saleAuctionsModelPublisher: Published<MyAuctionModel?>.Publisher { get }
    
    var loadState: CurrentValueSubject<Bool, Never> { get set }
    var reloadingState: CurrentValueSubject<Bool, Never> { get set }
    
    var textPhoneSubject: CurrentValueSubject<String ,Never> { get set }
    var textPasswordSubject: CurrentValueSubject<String ,Never> { get set }
    
    var isError: String { get set }
    var isErrorPublisher: Published<String>.Publisher { get }
    
    var startGoToHomePage: Bool { get }
    var startGoToHomePagePublisher: Published<Bool>.Publisher { get }
    
    func myAuctions(type: String?) async throws -> MyAuctionModel
    
}

class SaleAuctionViewModel: SaleAuctionViewModelProtocol {
    
    var loadinState = CurrentValueSubject<ViewModelStatus, Never>(.dismissAlert)
    var reloadingState = CurrentValueSubject<Bool, Never>(false)
    var loadState = CurrentValueSubject<Bool, Never>(false)
    
    @Published var saleAuctionsModel: MyAuctionModel?
    var saleAuctionsModelPublisher: Published<MyAuctionModel?>.Publisher{$saleAuctionsModel}
    
    @Published var isError: String = ""
    var isErrorPublisher: Published<String>.Publisher{$isError}
    
    @Published var startGoToHomePage: Bool = false
    var startGoToHomePagePublisher: Published<Bool>.Publisher{$startGoToHomePage}
    
    var textPhoneSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    var textPasswordSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    
    //Combine networking
    var apiDelegate: SaleAuctionAPIProtocol?
    
    var subscriptions = Set<AnyCancellable>()
    
    init(saleAuctionAPI : SaleAuctionAPIProtocol = SaleAuctionAPI()) {
        self.saleAuctionAPI = saleAuctionAPI
    }
    
    private var saleAuctionAPI: SaleAuctionAPIProtocol?
    
    var subscriber = Set<AnyCancellable>()
    
    func myAuctions(type: String?) async throws -> MyAuctionModel {
        
        let myAuctions: MyAuctionModel = try await withCheckedThrowingContinuation({ continuation in
            self.loadinState.send(.loadStart)
            self.loadState.send(true)
            let myAuctionsAPI: SaleAuctionAPIProtocol = SaleAuctionAPI()
            myAuctionsAPI.myAuctions(type: type).sink { [weak self] (completion) in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.loadinState.send(.dismissAlert)
                    self.loadState.send(false)
                    print("oops got an error \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                    
                case .finished:
                    print("nothing much to do here => finished => done")
                }
            } receiveValue: { [weak self] (responsse) in
                guard let self = self else { return }
                guard let data = responsse else {return}
                self.loadinState.send(.dismissAlert)
                self.loadState.send(false)
                self.saleAuctionsModel = data
                continuation.resume(returning: data)
                self.reloadingState.send(true)
            }.store(in: &subscriber)
        })
        return myAuctions
        
    }
    
}
