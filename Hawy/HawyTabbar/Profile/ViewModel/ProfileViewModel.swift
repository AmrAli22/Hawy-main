//
//  ProfileViewModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 24/09/2022.
//

import Foundation
import Combine

protocol ProfileViewModelProtocol: AnyObject {
    
    var profileMyAuctionsModel: MyAuctionModel? { get }
    var profileMyAuctionsModelPublisher: Published<MyAuctionModel?>.Publisher { get }
    
    var profileMyAuctionsData: [MyAuctionItem]? { get }
    var profileMyAuctionsDataPublisher: Published<[MyAuctionItem]?>.Publisher { get }
    
    var profileMyCardsModel: MyCardsModel? { get }
    var profileMyCardsModelPublisher: Published<MyCardsModel?>.Publisher { get }

    var profileMyCardsData: [MyCardsItem]? { get }
    var profileMyCardsDataPublisher: Published<[MyCardsItem]?>.Publisher { get }
    
    var profileAvatarModel: AvatarModel? { get }
    var profileAvatarModelPublisher: Published<AvatarModel?>.Publisher { get }
    
    var loadState: CurrentValueSubject<Bool, Never> { get set }
    var reloadingState: CurrentValueSubject<Bool, Never> { get set }
    
    var textPhoneSubject: CurrentValueSubject<String ,Never> { get set }
    var textPasswordSubject: CurrentValueSubject<String ,Never> { get set }
    
    var isError: String { get set }
    var isErrorPublisher: Published<String>.Publisher { get }
    
    var startGoToHomePage: Bool { get }
    var startGoToHomePagePublisher: Published<Bool>.Publisher { get }
    
    func myAuctions(type: String?) async throws -> MyAuctionModel
    func profileMyCards(type: String?, id: Int?) async throws -> MyCardsModel
    func avatar() async throws -> AvatarModel
    
}

class ProfileViewModel: ProfileViewModelProtocol {
    
    var loadinState = CurrentValueSubject<ViewModelStatus, Never>(.dismissAlert)
    var reloadingState = CurrentValueSubject<Bool, Never>(false)
    var loadState = CurrentValueSubject<Bool, Never>(false)
    
    @Published var profileMyAuctionsModel: MyAuctionModel?
    var profileMyAuctionsModelPublisher: Published<MyAuctionModel?>.Publisher{$profileMyAuctionsModel}
    
    @Published var profileMyAuctionsData: [MyAuctionItem]?
    var profileMyAuctionsDataPublisher: Published<[MyAuctionItem]?>.Publisher{$profileMyAuctionsData}
    
    @Published var profileMyCardsModel: MyCardsModel?
    var profileMyCardsModelPublisher: Published<MyCardsModel?>.Publisher{$profileMyCardsModel}
    
    @Published var profileMyCardsData: [MyCardsItem]?
    var profileMyCardsDataPublisher: Published<[MyCardsItem]?>.Publisher{$profileMyCardsData}
    
    @Published var profileAvatarModel: AvatarModel?
    var profileAvatarModelPublisher: Published<AvatarModel?>.Publisher{$profileAvatarModel}
    
    @Published var isError: String = ""
    var isErrorPublisher: Published<String>.Publisher{$isError}
    
    @Published var startGoToHomePage: Bool = false
    var startGoToHomePagePublisher: Published<Bool>.Publisher{$startGoToHomePage}
    
    var textPhoneSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    var textPasswordSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    
    //Combine networking
    var apiDelegate: ProfileMyAuctionAPIProtocol?
    
    var subscriptions = Set<AnyCancellable>()
    
    init(profileAPI : ProfileMyAuctionAPIProtocol = ProfileMyAuctionAPI()) {
        self.profileAPI = profileAPI
    }
    
    private var profileAPI: ProfileMyAuctionAPIProtocol?
    
    var subscriber = Set<AnyCancellable>()
    
    func myAuctions(type: String?) async throws -> MyAuctionModel {
        
        let myAuctions: MyAuctionModel = try await withCheckedThrowingContinuation({ continuation in
            self.loadinState.send(.loadStart)
            self.loadState.send(true)
            let myAuctionsAPI: ProfileMyAuctionAPIProtocol = ProfileMyAuctionAPI()
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
                guard let items = data.item else { return }
                
                self.isError = responsse?.message ?? ""
                
                self.loadinState.send(.dismissAlert)
                self.loadState.send(false)
                self.profileMyAuctionsModel = data
                self.profileMyAuctionsData = items
                continuation.resume(returning: data)
                self.reloadingState.send(true)
            }.store(in: &subscriber)
        })
        return myAuctions
        
    }
    
    func profileMyCards(type: String?, id: Int?) async throws -> MyCardsModel {
        
        let myCards: MyCardsModel = try await withCheckedThrowingContinuation({ continuation in
            self.loadinState.send(.loadStart)
            self.loadState.send(true)
            let myCardsAPI: ProfileMyAuctionAPIProtocol = ProfileMyAuctionAPI()
            myCardsAPI.profileMyCards(type: type, id: id).sink { [weak self] (completion) in
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
                guard let cards = data.item?.cards else { return }
                
                self.isError = responsse?.message ?? ""
                
                self.loadinState.send(.dismissAlert)
                self.loadState.send(false)
                self.profileMyCardsModel = data
                self.profileMyCardsData = cards
                continuation.resume(returning: data)
                self.reloadingState.send(true)
            }.store(in: &subscriber)
        })
        return myCards
        
    }
    
    func avatar() async throws -> AvatarModel {
        
        let avatar: AvatarModel = try await withCheckedThrowingContinuation({ continuation in
            self.loadinState.send(.loadStart)
            self.loadState.send(true)
            let myAvatar: ProfileMyAuctionAPIProtocol = ProfileMyAuctionAPI()
            myAvatar.avatar().sink { [weak self] (completion) in
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
                
                self.isError = responsse?.message ?? ""
                
                self.loadinState.send(.dismissAlert)
                self.loadState.send(false)
                self.profileAvatarModel = data
                continuation.resume(returning: data)
                self.reloadingState.send(true)
            }.store(in: &subscriber)
        })
        return avatar
        
    }
    
}
