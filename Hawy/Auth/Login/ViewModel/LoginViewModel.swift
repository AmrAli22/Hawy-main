//
//  LoginViewModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 03/09/2022.
//

import Foundation
import Combine

protocol LoginViewModelProtocol: AnyObject {
    
    var loginModel: RegisterModel? { get }
    var loginModelPublisher: Published<RegisterModel?>.Publisher { get }
    
    var loadState: CurrentValueSubject<Bool, Never> { get set }
    var reloadingState: CurrentValueSubject<Bool, Never> { get set }
    
    var textPhoneSubject: CurrentValueSubject<String ,Never> { get set }
    var textPasswordSubject: CurrentValueSubject<String ,Never> { get set }
    
    var isError: String { get set }
    var isErrorPublisher: Published<String>.Publisher { get }
    
    var startGoToHomePage: Bool { get }
    var startGoToHomePagePublisher: Published<Bool>.Publisher { get }
    
    func sendLogin(mobile: String?, name: String?, countryCode: String?, isoCode: String?) async throws -> RegisterModel
    
}

class LoginViewModel: LoginViewModelProtocol {
    
    var loadinState = CurrentValueSubject<ViewModelStatus, Never>(.dismissAlert)
    var reloadingState = CurrentValueSubject<Bool, Never>(false)
    var loadState = CurrentValueSubject<Bool, Never>(false)
    
    @Published var loginModel: RegisterModel?
    var loginModelPublisher: Published<RegisterModel?>.Publisher{$loginModel}
    
    @Published var isError: String = ""
    var isErrorPublisher: Published<String>.Publisher{$isError}
    
    @Published var startGoToHomePage: Bool = false
    var startGoToHomePagePublisher: Published<Bool>.Publisher{$startGoToHomePage}
    
    var textPhoneSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    var textPasswordSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    
    //Combine networking
    var apiDelegate: LoginAPIProtocol?
    
    var subscriptions = Set<AnyCancellable>()
    
    init(loginAPI : LoginAPIProtocol = LoginAPI()) {
        self.loginAPI = loginAPI
    }
    
    private var loginAPI: LoginAPIProtocol?
    
    var subscriber = Set<AnyCancellable>()
    
    func sendLogin(mobile: String?, name: String?, countryCode: String?, isoCode: String?) async throws -> RegisterModel {
        
        let login: RegisterModel = try await withCheckedThrowingContinuation({ continuation in
            self.loadinState.send(.loadStart)
            self.loadState.send(true)
            let loginAPI: LoginAPIProtocol = LoginAPI()
            loginAPI.register(mobile: mobile, name: name, countryCode: countryCode, isoCode: isoCode).sink { [weak self] (completion) in
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
                self.loginModel = data
                continuation.resume(returning: data)
                self.reloadingState.send(true)
            }.store(in: &subscriber)
        })
        return login
        
    }
    
}
