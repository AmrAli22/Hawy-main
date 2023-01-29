//
//  HomeViewModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 07/09/2022.
//

import Foundation
import Combine

protocol HomeViewModelProtocol: AnyObject {
    
    var sliderModel: SliderModel? { get }
    var sliderModelPublisher: Published<SliderModel?>.Publisher { get }
    
    var sliderData: [SliderData]? { get }
    var sliderDataPublisher: Published<[SliderData]?>.Publisher { get }
    
    var loadState: CurrentValueSubject<Bool, Never> { get set }
    var reloadingState: CurrentValueSubject<Bool, Never> { get set }
    
    var textPhoneSubject: CurrentValueSubject<String ,Never> { get set }
    var textPasswordSubject: CurrentValueSubject<String ,Never> { get set }
    
    var isError: String { get set }
    var isErrorPublisher: Published<String>.Publisher { get }
    
    var startGoToHomePage: Bool { get }
    var startGoToHomePagePublisher: Published<Bool>.Publisher { get }
    
    func getSlider() async throws -> SliderModel
    
}

class HomeViewModel: HomeViewModelProtocol {
    
    var loadinState = CurrentValueSubject<ViewModelStatus, Never>(.dismissAlert)
    var reloadingState = CurrentValueSubject<Bool, Never>(false)
    var loadState = CurrentValueSubject<Bool, Never>(false)
    
    @Published var sliderModel: SliderModel?
    var sliderModelPublisher: Published<SliderModel?>.Publisher{$sliderModel}
    
    @Published var sliderData: [SliderData]?
    var sliderDataPublisher: Published<[SliderData]?>.Publisher{$sliderData}
    
    @Published var isError: String = ""
    var isErrorPublisher: Published<String>.Publisher{$isError}
    
    @Published var startGoToHomePage: Bool = false
    var startGoToHomePagePublisher: Published<Bool>.Publisher{$startGoToHomePage}
    
    var textPhoneSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    var textPasswordSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    
    //Combine networking
    var apiDelegate: HomeSliderAPIProtocol?
    
    var subscriptions = Set<AnyCancellable>()
    
    private var homeSliderAPI: HomeSliderAPIProtocol?
    
    var subscriber = Set<AnyCancellable>()
    
    init(homeSliderAPI : HomeSliderAPIProtocol = HomeSliderAPI()) {
        self.homeSliderAPI = homeSliderAPI
    }
    
    func getSlider() async throws -> SliderModel {
        
        let homeSlider: SliderModel = try await withCheckedThrowingContinuation({ continuation in
            self.loadinState.send(.loadStart)
            self.loadState.send(true)
            let subCategoryAPI: HomeSliderAPIProtocol = HomeSliderAPI()
            subCategoryAPI.homeSlider().sink { [weak self] (completion) in
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
                self.sliderModel = data
                self.sliderData = data.item
                continuation.resume(returning: data)
                self.reloadingState.send(true)
            }.store(in: &subscriber)
        })
        return homeSlider
        
    }
    
}
