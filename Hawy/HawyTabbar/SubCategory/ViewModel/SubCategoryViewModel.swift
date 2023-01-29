//
//  SubCategoryViewModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 07/09/2022.
//

import Foundation
import Combine

protocol SubCategoryViewModelProtocol: AnyObject {
    
    var subCategoryModel: SubCategoryModel? { get }
    var subCategoryModelPublisher: Published<SubCategoryModel?>.Publisher { get }
    
    var subCategoryData: [SubCategoryData]? { get }
    var subCategoryDataPublisher: Published<[SubCategoryData]?>.Publisher { get }
    
    var loadState: CurrentValueSubject<Bool, Never> { get set }
    var reloadingState: CurrentValueSubject<Bool, Never> { get set }
    
    var textPhoneSubject: CurrentValueSubject<String ,Never> { get set }
    var textPasswordSubject: CurrentValueSubject<String ,Never> { get set }
    
    var isError: String { get set }
    var isErrorPublisher: Published<String>.Publisher { get }
    
    var startGoToHomePage: Bool { get }
    var startGoToHomePagePublisher: Published<Bool>.Publisher { get }
    
    func getSubCategory(categoryId: Int?) async throws -> SubCategoryModel
    
}

class SubCategoryViewModel: SubCategoryViewModelProtocol {
    
    var loadinState = CurrentValueSubject<ViewModelStatus, Never>(.dismissAlert)
    var reloadingState = CurrentValueSubject<Bool, Never>(false)
    var loadState = CurrentValueSubject<Bool, Never>(false)
    
    @Published var subCategoryModel: SubCategoryModel?
    var subCategoryModelPublisher: Published<SubCategoryModel?>.Publisher{$subCategoryModel}
    
    @Published var subCategoryData: [SubCategoryData]?
    var subCategoryDataPublisher: Published<[SubCategoryData]?>.Publisher{$subCategoryData}
    
    @Published var isError: String = ""
    var isErrorPublisher: Published<String>.Publisher{$isError}
    
    @Published var startGoToHomePage: Bool = false
    var startGoToHomePagePublisher: Published<Bool>.Publisher{$startGoToHomePage}
    
    var textPhoneSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    var textPasswordSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    
    //Combine networking
    var apiDelegate: SubCategoryAPIProtocol?
    
    var subscriptions = Set<AnyCancellable>()
    
    private var subCategoryAPI: SubCategoryAPIProtocol?
    
    var subscriber = Set<AnyCancellable>()
    
    init(subCategoryAPI : SubCategoryAPIProtocol = SubCategoryAPI()) {
        self.subCategoryAPI = subCategoryAPI
    }
    
    func getSubCategory(categoryId: Int?) async throws -> SubCategoryModel {
        
        let subCategory: SubCategoryModel = try await withCheckedThrowingContinuation({ continuation in
            self.loadinState.send(.loadStart)
            self.loadState.send(true)
            let subCategoryAPI: SubCategoryAPIProtocol = SubCategoryAPI()
            subCategoryAPI.category(categoryId: categoryId).sink { [weak self] (completion) in
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
                self.subCategoryModel = data
                self.subCategoryData = data.item
                continuation.resume(returning: data)
                self.reloadingState.send(true)
            }.store(in: &subscriber)
        })
        return subCategory
        
    }
    
}
