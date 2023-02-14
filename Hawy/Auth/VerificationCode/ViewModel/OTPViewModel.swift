//
//  OTPViewModel.swift
//  Hawy
//
//  Created by ahmed abu elregal on 03/09/2022.
//

import Foundation
import Combine

protocol OTPViewModelProtocol: AnyObject {
    
    var otpModel: OTPModel? { get }
    var otpModelPublisher: Published<OTPModel?>.Publisher { get }
    
    var loadState: CurrentValueSubject<Bool, Never> { get set }
    var reloadingState: CurrentValueSubject<Bool, Never> { get set }
    
    var textPhoneSubject: CurrentValueSubject<String ,Never> { get set }
    var textPasswordSubject: CurrentValueSubject<String ,Never> { get set }
    
    var isError: String { get set }
    var isErrorPublisher: Published<String>.Publisher { get }
    
    var startGoToHomePage: Bool { get }
    var startGoToHomePagePublisher: Published<Bool>.Publisher { get }
    
    func sendOtp(mobile: String?, otp: String?, countryCode: String?, isoCode: String?) async throws -> OTPModel
    
}

class OTPViewModel: OTPViewModelProtocol {
    
    var loadinState = CurrentValueSubject<ViewModelStatus, Never>(.dismissAlert)
    var reloadingState = CurrentValueSubject<Bool, Never>(false)
    var loadState = CurrentValueSubject<Bool, Never>(false)
    
    @Published var otpModel: OTPModel?
    var otpModelPublisher: Published<OTPModel?>.Publisher{$otpModel}
    
    @Published var isError: String = ""
    var isErrorPublisher: Published<String>.Publisher{$isError}
    
    @Published var startGoToHomePage: Bool = false
    var startGoToHomePagePublisher: Published<Bool>.Publisher{$startGoToHomePage}
    
    var textPhoneSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    var textPasswordSubject: CurrentValueSubject<String, Never> = CurrentValueSubject<String,Never>("")
    
    //Combine networking
    var apiDelegate: OTPAPIProtocol?
    
    var subscriptions = Set<AnyCancellable>()
    
    private var otpAPI: OTPAPIProtocol?
    
    var subscriber = Set<AnyCancellable>()
    
    init(otpAPI : OTPAPIProtocol = OTPAPI()) {
        self.otpAPI = otpAPI
    }
    
    func sendOtp(mobile: String?, otp: String?, countryCode: String?, isoCode: String?) async throws -> OTPModel {
        
        let otp: OTPModel = try await withCheckedThrowingContinuation({ continuation in
            self.loadinState.send(.loadStart)
            self.loadState.send(true)
            let registerApi: OTPAPIProtocol = OTPAPI()
            
            registerApi.otp(mobile: mobile, otp: otp, countryCode: countryCode, isoCode: isoCode).sink { [weak self] (completion) in
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
                self.otpModel = data
                if data.code == 200 {
                    HelperConstant.saveToken(access_token: data.data?.token ?? "")
                    HelperConstant.saveUserId(userId: data.data?.id ?? 0)
                }
                continuation.resume(returning: data)
                self.reloadingState.send(true)
            }.store(in: &subscriber)
        })
        return otp
        
    }
}
