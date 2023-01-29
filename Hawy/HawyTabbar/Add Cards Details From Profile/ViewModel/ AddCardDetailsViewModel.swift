//
//   AddCardDetailsViewModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 16/09/2022.
//

import Foundation
import Combine

protocol AddCardDetailsViewModelProtocol: AnyObject {
    
    var addCardDetailsModel: AddedCardDetailsModel? { get }
    var addCardDetailsModelPublisher: Published<AddedCardDetailsModel?>.Publisher { get }
    
    var loadState: CurrentValueSubject<Bool, Never> { get set }
    var reloadingState: CurrentValueSubject<Bool, Never> { get set }
    
    var textPhoneSubject: CurrentValueSubject<String ,Never> { get set }
    var textPasswordSubject: CurrentValueSubject<String ,Never> { get set }
    
    var isError: String { get set }
    var isErrorPublisher: Published<String>.Publisher { get }
    
    var startGoToHomePage: Bool { get }
    var startGoToHomePagePublisher: Published<Bool>.Publisher { get }
    
    func addedCardDetails(name: String?, mother_name: String?, father_name: String?, age: String?, main_image: String?, images: [String]?, video: String?, category_id: String?, notes: String?, status: String?, inoculations: [String]?, owners: [String]?, docNum: String?) async throws -> AddedCardDetailsModel
    
}

class AddCardDetailsViewModel: AddCardDetailsViewModelProtocol {
    
    var loadinState = CurrentValueSubject<ViewModelStatus, Never>(.dismissAlert)
    var reloadingState = CurrentValueSubject<Bool, Never>(false)
    var loadState = CurrentValueSubject<Bool, Never>(false)
    
    @Published var addCardDetailsModel: AddedCardDetailsModel?
    var addCardDetailsModelPublisher: Published<AddedCardDetailsModel?>.Publisher{$addCardDetailsModel}
    
    @Published var isError: String = ""
    var isErrorPublisher: Published<String>.Publisher{$isError}
    
    @Published var startGoToHomePage: Bool = false
    var startGoToHomePagePublisher: Published<Bool>.Publisher{$startGoToHomePage}
    
    var textPhoneSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    var textPasswordSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    
    //Combine networking
    var apiDelegate: AddCardDetailsAPIProtocol?
    
    var subscriptions = Set<AnyCancellable>()
    
    init(typeAdded : AddCardDetailsAPIProtocol = AddCardDetailsAPI()) {
        self.typeAdded = typeAdded
    }
    
    private var typeAdded: AddCardDetailsAPIProtocol?
    
    var subscriber = Set<AnyCancellable>()
    
    func addedCardDetails(name: String?, mother_name: String?, father_name: String?, age: String?, main_image: String?, images: [String]?, video: String?, category_id: String?, notes: String?, status: String?, inoculations: [String]?, owners: [String]?, docNum: String?) async throws -> AddedCardDetailsModel {
        
        print(name, mother_name, father_name, age,main_image, images, video, category_id, notes, inoculations, owners)
        
        let addedCardDetails: AddedCardDetailsModel = try await withCheckedThrowingContinuation({ continuation in
            self.loadinState.send(.loadStart)
            self.loadState.send(true)
            let typeAdded: AddCardDetailsAPIProtocol = AddCardDetailsAPI()
            typeAdded.addedCardDetails(name: name, mother_name: mother_name, father_name: father_name, age: age, main_image: main_image, images: images, video: video, category_id: category_id, notes: notes, status: status, inoculations: inoculations, owners: owners, docNum: docNum).sink { [weak self] (completion) in
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
                self.addCardDetailsModel = data
                self.loadinState.send(.dismissAlert)
                self.loadState.send(false)
                
                
                
                continuation.resume(returning: data)
                self.reloadingState.send(true)
            }.store(in: &subscriber)
        })
        return addedCardDetails
    }
    
}
