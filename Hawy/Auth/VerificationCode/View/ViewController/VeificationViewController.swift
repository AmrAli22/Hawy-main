//
//  VeificationViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 07/08/2022.
//

import UIKit
import Alamofire
import Combine

class VeificationViewController: BaseViewViewController, UITextFieldDelegate {
    
    @IBOutlet weak var phoneTFOutlet: UILabel!
    @IBOutlet weak var no1: UITextField!
    @IBOutlet weak var firstLineImage: UIImageView!
    @IBOutlet weak var no2: UITextField!
    @IBOutlet weak var secondLineImage: UIImageView!
    @IBOutlet weak var no3: UITextField!
    @IBOutlet weak var thirdLineImage: UIImageView!
    @IBOutlet weak var no4: UITextField!
    @IBOutlet weak var fourthLineImage: UIImageView!
    @IBOutlet weak var timerDownLabelOutlet: UILabel!
    @IBOutlet weak var resendCodeButtonOutlet: UIButton!
    //@IBOutlet weak var timeDownLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var confirmButtonOutlet: UIButton!
    @IBOutlet weak var contaonerOfOTP: UIView!
    @IBOutlet weak var stackContaonerOfOTP: UIStackView!
    
    var code: String?
    var timer: Timer?
    var totalTime = 59
    
    var phone: String?
    var countryCode: String?
    
    var isoCode = ""
    
    var homeOrNot: Bool?
    
    var finalPhone: String?
    var name: String?
    
    private var viewModel = OTPViewModel()
    private var loginViewModel = LoginViewModel()
    var subscriber = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contaonerOfOTP.semanticContentAttribute = .forceLeftToRight
        stackContaonerOfOTP.semanticContentAttribute = .forceLeftToRight
        
        phoneTFOutlet.text = finalPhone ?? ""
        //---------------------------------------------------------------------------------------
        // Add a delegate of each UITextField or add it from storyboard as you prefer .
        //---------------------------------------------------------------------------------------
        [no1, no2, no3, no4].forEach {
            $0?.delegate = self
        }
        //---------------------------------------------------------------------------------------
        // For each UITextField add target action for ( editingChanged )
        //---------------------------------------------------------------------------------------
        [no1, no2, no3, no4].forEach {
            $0?.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        }
        //---------------------------------------------------------------------------------------
        // Add line as no1.becomeFirstResponder() to open keyboard for first field
        //---------------------------------------------------------------------------------------
        no1.becomeFirstResponder()
        firstLineImage.backgroundColor = DesignSystem.Colors.PrimaryBlack.color
        secondLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
        thirdLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
        fourthLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
        //---------------------------------------------------------------------------------------
        //----------------------------------------------------------------------------------
        // start counter function
        startOtpTimer()
        
        sinkToLoading()
        sinkToOTP()
        
        sinkToLoginLoading()
        sinkToLogin()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }
    
    //-------------------------------------------------------------------------------------------
    // Add method textFieldDidChange with @objc
    // When changed value in textField
    //-------------------------------------------------------------------------------------------
    @objc func textFieldDidChange(textField: UITextField) {
        let text = textField.text
        //-----------------------------------------------------------------------------------
        // when text lenght equal to 1
        //-----------------------------------------------------------------------------------
        if text?.count == 1 {
            switch textField {
            case no1:
                no2.becomeFirstResponder()
                firstLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
                secondLineImage.backgroundColor = DesignSystem.Colors.PrimaryBlack.color
                thirdLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
                fourthLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
            case no2:
                no3.becomeFirstResponder()
                firstLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
                secondLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
                thirdLineImage.backgroundColor = DesignSystem.Colors.PrimaryBlack.color
                fourthLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
            case no3:
                no4.becomeFirstResponder()
                firstLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
                secondLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
                thirdLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
                fourthLineImage.backgroundColor = DesignSystem.Colors.PrimaryBlack.color
            case no4:
                no4.becomeFirstResponder()
                firstLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
                secondLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
                thirdLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
                fourthLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
                self.dismissKeyboard()
                code = ("\(no1.text ?? "")" + "\(no2.text ?? "")" + "\(no3.text ?? "")" + "\(no4.text ?? "")").replacedArabicDigitsWithEnglish
                print("\(no1.text ?? "")" + "\(no2.text ?? "")" + "\(no3.text ?? "")" + "\(no4.text ?? "")")
                print(code ?? "")
                if self.homeOrNot == false {
                    Task {
                        do {
                            print(countryCode, phone, code, isoCode)
                            let otp = try await viewModel.sendOtp(mobile: phone, otp: code, countryCode: countryCode, isoCode: isoCode.lowercased())
                            print(otp)
                        }catch {
                            // tell the user something went wrong, I hope
                            debugPrint(error)
                        }
                    }
                }else {
                    //self.codeViewModel.code(phone: self.phone ?? "", password: self.code?.replacedArabicDigitsWithEnglish ?? "", type_id: 1)
                }
            default:
                break
            }
        }
        //-----------------------------------------------------------------------------------
        // when text lenght equal to 0
        //-----------------------------------------------------------------------------------
        if text?.count == 0 {
            switch textField {
            case no1:
                no1.becomeFirstResponder()
                firstLineImage.backgroundColor = DesignSystem.Colors.PrimaryBlack.color
                secondLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
                thirdLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
                fourthLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
            case no2:
                no1.becomeFirstResponder()
                firstLineImage.backgroundColor = DesignSystem.Colors.PrimaryBlack.color
                secondLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
                thirdLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
                fourthLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
            case no3:
                no2.becomeFirstResponder()
                firstLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
                secondLineImage.backgroundColor = DesignSystem.Colors.PrimaryBlack.color
                thirdLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
                fourthLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
            case no4:
                no3.becomeFirstResponder()
                firstLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
                secondLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
                thirdLineImage.backgroundColor = DesignSystem.Colors.PrimaryBlack.color
                fourthLineImage.backgroundColor = DesignSystem.Colors.PrimaryGray.color
            default:
                break
            }
        }
        else{
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return false
    }
    
    //-----------------------------------------------------------------------------------
    // For Close Keybored
    //-----------------------------------------------------------------------------------
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    //MARK:- SetUp startOtpTimer
    public func startOtpTimer() {
        self.totalTime = 59
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    //MARK:- SetUp updateTimer
    @objc func updateTimer() {
        print(totalTime)
        timerDownLabelOutlet.text = timeFormatted(totalTime) // will show timer
        if totalTime != 0 {
            totalTime -= 1  // decrease counter timer
            resendCodeButtonOutlet.isEnabled = false
            resendCodeButtonOutlet.setTitleColor(DesignSystem.Colors.PrimaryGray.color, for: .normal)
            //confirmCodeButtonOutlet.isEnabled = false
            timerDownLabelOutlet.isHidden = false
            //timeDownLabelHeight.constant = 35
            //topOfConformButton.constant = 55
        } else {
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
                resendCodeButtonOutlet.isEnabled = true
                resendCodeButtonOutlet.setTitleColor(DesignSystem.Colors.PrimaryBlack.color, for: .normal)
                //confirmCodeButtonOutlet.isEnabled = true
                timerDownLabelOutlet.isHidden = true
                //timeDownLabelHeight.constant = 0
                //topOfConformButton.constant = 35
            }
        }
    }
    //MARK:- SetUp timeFormatted
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func sinkToLoginLoading() {
//        self.viewModel.loadinState
//            .sink { [weak self] state in
//                self?.handleActivityIndicator(state: state)
//            }.store(in: &subscriber)
        self.viewModel.loadState
            .sink { [weak self] (state) in
                guard let self = self else { return }
                if state {
                    print("show Loading")
                    self.showIndecator()
                }else {
                    print("dismiss Loading")
                    self.hideIndecator()
                }
            }.store(in: &subscriber)
    }
    
    func sinkToLogin() {
        loginViewModel.loginModelPublisher.sink { [weak self] result in
            guard let self = self else { return }
            if result?.code == 200 {
                print("Success")
                self.startOtpTimer()
            }else if result?.code == 422 {
                ToastManager.shared.showError(message: result?.message ?? "", view: self.view)
            }
        }.store(in: &subscriber)
    }
    
    func sinkToLoading() {
//        self.viewModel.loadinState
//            .sink { [weak self] state in
//                self?.handleActivityIndicator(state: state)
//            }.store(in: &subscriber)
        self.viewModel.loadState
            .sink { [weak self] (state) in
                guard let self = self else { return }
                if state {
                    print("show Loading")
                    self.showIndecator()
                }else {
                    print("dismiss Loading")
                    self.hideIndecator()
                }
            }.store(in: &subscriber)
    }
    
    func sinkToOTP() {
        viewModel.otpModelPublisher.sink { [weak self] result in
            guard let self = self else { return }
            if result?.code == 200 {
                
                HelperConstant.saveToken(access_token: result?.data?.token ?? "")
                print(HelperConstant.getToken())
                
                HelperConstant.saveUserId(userId: result?.data?.id ?? 0)
                print(HelperConstant.getUserId())
                
                HelperConstant.saveCurrency(currency: result?.data?.currency ?? "K.D")
                print(HelperConstant.getCurrency())
                
                HelperConstant.saveName(name: result?.data?.name ?? "no name")
                print(HelperConstant.getName())
                
                HelperConstant.saveUserIdFaceId(userId: result?.data?.id ?? 0)
                print(HelperConstant.getUserIdFaceId())
                
                HelperConstant.savePhoneFaceId(phoneFaceId: result?.data?.mobile ?? "")
                print(HelperConstant.getPhoneFaceId())
                
                HelperConstant.saveIsoCodeFaceId(isoCodeFaceId: self.isoCode.lowercased() ?? "")
                print(HelperConstant.getIsoCodeFaceId())
                
                HelperConstant.saveCountryCodeFaceId(countryCodeFaceId: self.countryCode ?? "")
                print(HelperConstant.getCountryCodeFaceId())
                
                
                
                if result?.data?.subscription == true {
                    
                    let stroyboard = UIStoryboard(name: "HawyTabbar", bundle: nil) //HawyTabbar //Subscriptions
                    let VC = stroyboard.instantiateViewController(withIdentifier: "HawyTabbarController") as? HawyTabbarController //HawyTabbarController //SubscriptionsViewController
                    self.navigationController?.pushViewController(VC!, animated: true)
                    
                }else {
                    let stroyboard = UIStoryboard(name: "Subscriptions", bundle: nil) //HawyTabbar //Subscriptions
                    let VC = stroyboard.instantiateViewController(withIdentifier: "SubscriptionsViewController") as? SubscriptionsViewController //HawyTabbarController //SubscriptionsViewController
                    self.navigationController?.pushViewController(VC!, animated: true)
                }
                
            }else if result?.code == 422 {
                ToastManager.shared.showError(message: result?.message ?? "", view: self.view)
            }
        }.store(in: &subscriber)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resendButtonTapped(_ sender: Any) {
        
        Task {
            do {
                print(countryCode, phone)
                let login = try await loginViewModel.sendLogin(mobile: phone, name: name, countryCode: countryCode, isoCode: isoCode.lowercased())
                print(login)
            }catch {
                // tell the user something went wrong, I hope
                debugPrint(error)
            }
        }
        
    }
    
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
        guard self.no1.text?.isEmpty == false else {
            print("no1 is empty")
            ToastManager.shared.showError(message: "please Enter Full Code Number".localized, view: self.view)
            return
        }
        
        guard self.no2.text?.isEmpty == false else {
            print("no2 is empty")
            ToastManager.shared.showError(message: "please Enter Full Code Number".localized, view: self.view)
            return
        }
        
        guard self.no3.text?.isEmpty == false else {
            print("no3 is empty")
            ToastManager.shared.showError(message: "please Enter Full Code Number".localized, view: self.view)
            return
        }
        
        guard self.no4.text?.isEmpty == false else {
            print("no4 is empty")
            ToastManager.shared.showError(message: "please Enter Full Code Number".localized, view: self.view)
            return
        }
        
        Task {
            do {
                print(countryCode, phone, code, isoCode)
                
                
                let otp = try await viewModel.sendOtp(mobile: phone, otp: code, countryCode: countryCode, isoCode: isoCode.lowercased())
                print(otp)
            }catch {
                // tell the user something went wrong, I hope
                debugPrint(error)
            }
        }
    }
    
}


