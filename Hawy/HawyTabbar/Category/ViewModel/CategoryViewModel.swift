//
//  CategoryViewModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 07/09/2022.
//

import Foundation
import Combine

protocol CategoryViewModelProtocol: AnyObject {
    
    var categoryModel: CategoryModel? { get }
    var categoryModelPublisher: Published<CategoryModel?>.Publisher { get }
    
    var categoryData: [CategoryData]? { get }
    var categoryDataPublisher: Published<[CategoryData]?>.Publisher { get }
    
    var loadState: CurrentValueSubject<Bool, Never> { get set }
    var reloadingState: CurrentValueSubject<Bool, Never> { get set }
    
    var textPhoneSubject: CurrentValueSubject<String ,Never> { get set }
    var textPasswordSubject: CurrentValueSubject<String ,Never> { get set }
    
    var isError: String { get set }
    var isErrorPublisher: Published<String>.Publisher { get }
    
    var startGoToHomePage: Bool { get }
    var startGoToHomePagePublisher: Published<Bool>.Publisher { get }
    
    func getCategory() async throws -> CategoryModel
    
}

class CategoryViewModel: CategoryViewModelProtocol {
    
    var loadinState = CurrentValueSubject<ViewModelStatus, Never>(.dismissAlert)
    var reloadingState = CurrentValueSubject<Bool, Never>(false)
    var loadState = CurrentValueSubject<Bool, Never>(false)
    
    @Published var categoryModel: CategoryModel?
    var categoryModelPublisher: Published<CategoryModel?>.Publisher{$categoryModel}
    
    @Published var categoryData: [CategoryData]?
    var categoryDataPublisher: Published<[CategoryData]?>.Publisher{$categoryData}
    
    @Published var isError: String = ""
    var isErrorPublisher: Published<String>.Publisher{$isError}
    
    @Published var startGoToHomePage: Bool = false
    var startGoToHomePagePublisher: Published<Bool>.Publisher{$startGoToHomePage}
    
    var textPhoneSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    var textPasswordSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    
    //Combine networking
    var apiDelegate: CategoryAPIProtocol?
    
    var subscriptions = Set<AnyCancellable>()
    
    private var categoryAPI: CategoryAPIProtocol?
    
    var subscriber = Set<AnyCancellable>()
    
    init(categoryAPI : CategoryAPIProtocol = CategoryAPI()) {
        self.categoryAPI = categoryAPI
    }
    
    func getCategory() async throws -> CategoryModel {
        
        let category: CategoryModel = try await withCheckedThrowingContinuation({ continuation in
            self.loadinState.send(.loadStart)
            self.loadState.send(true)
            let categoryAPI: CategoryAPIProtocol = CategoryAPI()
            categoryAPI.category().sink { [weak self] (completion) in
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
                self.categoryModel = data
                self.categoryData = data.item
                continuation.resume(returning: data)
                self.reloadingState.send(true)
            }.store(in: &subscriber)
        })
        return category
        
    }
    
}
