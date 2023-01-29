//
//  TypeAddedDetailsCardViewModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 16/09/2022.
//

import Foundation
import Combine

protocol TypeAddedDetailsCardViewModelProtocol: AnyObject {
    
    var typeAddedModel: TypeOfCardsModel? { get }
    var typeAddedModelPublisher: Published<TypeOfCardsModel?>.Publisher { get }
    
    var typeOfCardsItem: [TypeOfCardsItem]? { get }
    var typeOfCardsItemPublisher: Published<[TypeOfCardsItem]?>.Publisher { get }
    
    var typeOfCardsSub: [TypeOfCardsItem]? { get }
    var typeOfCardsSubPublisher: Published<[TypeOfCardsItem]?>.Publisher { get }
    
    var loadState: CurrentValueSubject<Bool, Never> { get set }
    var reloadingState: CurrentValueSubject<Bool, Never> { get set }
    
    var textPhoneSubject: CurrentValueSubject<String ,Never> { get set }
    var textPasswordSubject: CurrentValueSubject<String ,Never> { get set }
    
    var isError: String { get set }
    var isErrorPublisher: Published<String>.Publisher { get }
    
    var startGoToHomePage: Bool { get }
    var startGoToHomePagePublisher: Published<Bool>.Publisher { get }
    
    func getcategoryAndSub() async throws -> TypeOfCardsModel
    
}

class TypeAddedDetailsCardViewModel: TypeAddedDetailsCardViewModelProtocol {
    
    var loadinState = CurrentValueSubject<ViewModelStatus, Never>(.dismissAlert)
    var reloadingState = CurrentValueSubject<Bool, Never>(false)
    var loadState = CurrentValueSubject<Bool, Never>(false)
    
    @Published var typeAddedModel: TypeOfCardsModel?
    var typeAddedModelPublisher: Published<TypeOfCardsModel?>.Publisher{$typeAddedModel}
    
    @Published var typeOfCardsItem: [TypeOfCardsItem]?
    var typeOfCardsItemPublisher: Published<[TypeOfCardsItem]?>.Publisher{$typeOfCardsItem}
    
    @Published var typeOfCardsSub: [TypeOfCardsItem]?
    var typeOfCardsSubPublisher: Published<[TypeOfCardsItem]?>.Publisher{$typeOfCardsSub}
    
    @Published var isError: String = ""
    var isErrorPublisher: Published<String>.Publisher{$isError}
    
    @Published var startGoToHomePage: Bool = false
    var startGoToHomePagePublisher: Published<Bool>.Publisher{$startGoToHomePage}
    
    var textPhoneSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    var textPasswordSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    
    //Combine networking
    var apiDelegate: TypeAddedCardAPIProtocol?
    
    var subscriptions = Set<AnyCancellable>()
    
    init(typeAdded : TypeAddedCardAPIProtocol = TypeAddedCardAPI()) {
        self.typeAdded = typeAdded
    }
    
    private var typeAdded: TypeAddedCardAPIProtocol?
    
    var subscriber = Set<AnyCancellable>()
    
    func getcategoryAndSub() async throws -> TypeOfCardsModel {
        let categoryAndSub: TypeOfCardsModel = try await withCheckedThrowingContinuation({ continuation in
            self.loadinState.send(.loadStart)
            self.loadState.send(true)
            let typeAdded: TypeAddedCardAPIProtocol = TypeAddedCardAPI()
            typeAdded.getcategoryAndSub().sink { [weak self] (completion) in
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
                guard let item = data.item else {return}
                
                self.loadinState.send(.dismissAlert)
                self.loadState.send(false)
                self.typeAddedModel = data
                self.typeOfCardsItem = item
                
//                for subCategory in item {
//                    self.typeOfCardsSub.append(contentsOf: subCategory.sub)
//                }
                
                continuation.resume(returning: data)
                self.reloadingState.send(true)
            }.store(in: &subscriber)
        })
        return categoryAndSub
    }
    
}

