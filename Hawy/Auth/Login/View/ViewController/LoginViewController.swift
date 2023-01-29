//
//  LoginViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 07/08/2022.
//

import UIKit
import Combine
import LocalAuthentication
import Alamofire

class Country {
    var countryCode: String?
    var name: String?
    var currencyCode: String?
    var currencySymbol: String?
    var extensionCode: String?
    var flag: String?
}

class LoginViewController: BaseViewViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameViewTF: UIView!
    @IBOutlet weak var phoneViewTF: UIView!
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var countyCodeTF: UITextField!
    
    lazy var label: PaddedLabel = {
        let label = PaddedLabel()
        label.text = "User Name".localized
        label.backgroundColor = DesignSystem.Colors.SecondBackground.color
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    lazy var label2: PaddedLabel = {
        let label = PaddedLabel()
        label.text = "Phone".localized
        label.backgroundColor = DesignSystem.Colors.SecondBackground.color
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    lazy var label3: PaddedLabel = {
        let label = PaddedLabel()
        label.text = "Code".localized
        label.backgroundColor = DesignSystem.Colors.SecondBackground.color
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    
    let pickerView = UIPickerView()
    
    var list: [Country] = [Country]()
    
    var countryCode: String?
    
    var isoCode = ""
    
    private var viewModel = LoginViewModel()
    var subscriber = Set<AnyCancellable>()
    
    private var viewModelOTP = OTPViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        nameTF.delegate = self
        phoneTF.delegate = self
        countyCodeTF.delegate = self
        
        nameViewTF.backgroundColor = DesignSystem.Colors.PrimaryGray.color
        nameViewTF.layer.borderWidth = 1
        nameViewTF.layer.borderColor = DesignSystem.Colors.PrimaryGray.color.cgColor
        nameViewTF.layer.cornerRadius = 15
        nameViewTF.layer.masksToBounds = true
        label.isHidden = true
        
        phoneViewTF.backgroundColor = DesignSystem.Colors.PrimaryGray.color
        phoneViewTF.layer.borderWidth = 1
        phoneViewTF.layer.borderColor = DesignSystem.Colors.PrimaryGray.color.cgColor
        phoneViewTF.layer.cornerRadius = 15
        phoneViewTF.layer.masksToBounds = true
        label2.isHidden = true
        label3.isHidden = true
        
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: nameViewTF.topAnchor, constant: -10).isActive = true
        label.leadingAnchor.constraint(equalTo: nameViewTF.leadingAnchor, constant: 15).isActive = true
        
        view.addSubview(label2)
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.topAnchor.constraint(equalTo: phoneViewTF.topAnchor, constant: -10).isActive = true
        label2.leadingAnchor.constraint(equalTo: phoneViewTF.leadingAnchor, constant: 15).isActive = true
        
        view.addSubview(label3)
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.topAnchor.constraint(equalTo: phoneViewTF.topAnchor, constant: -10).isActive = true
        label3.leadingAnchor.constraint(equalTo: phoneViewTF.leadingAnchor, constant: 15).isActive = true
        
        configuration()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        countyCodeTF.inputView = pickerView
        pickerView.selectRow(127, inComponent: 0, animated: false)
        
        sinkToLoading()
        sinkToLogin()
        
        sinkToLoadingOTP()
        sinkToOTP()
        
        phoneViewTF.semanticContentAttribute = .forceLeftToRight
        
        print(isoCode)
        
    }
    
    func configuration() {
        for code in NSLocale.isoCountryCodes  {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: AppLocalization.currentAppleLanguage()).displayName(forKey: NSLocale.Key.identifier, value: id)
            
            let locale = NSLocale.init(localeIdentifier: id)
            
            let countryCode = locale.object(forKey: NSLocale.Key.countryCode)
            let currencyCode = locale.object(forKey: NSLocale.Key.currencyCode)
            let currencySymbol = locale.object(forKey: NSLocale.Key.currencySymbol)
            
            if name != nil {
                let model = Country()
                model.name = name
                model.countryCode = countryCode as? String
                model.currencyCode = currencyCode as? String
                model.currencySymbol = currencySymbol as? String
                model.flag = String.flag(for: code)
                model.extensionCode = NSLocale().extensionCode(countryCode: model.countryCode)
                list.append(model)
            }
        }
        self.isoCode = list[127].countryCode ?? ""
        self.countryCode = "+" + "\(list[127].extensionCode ?? "")"
        self.countyCodeTF.text = "\(list[127].flag ?? "") \( list[127].extensionCode ?? "")"
        self.pickerView.reloadAllComponents()
    }
    
    @objc
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nameTF {
            dismissKeyboard()
        }else if textField == self.phoneTF {
            dismissKeyboard()
        }else {
            dismissKeyboard()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.nameTF {
            nameViewTF.backgroundColor = DesignSystem.Colors.SecondBackground.color
            nameViewTF.layer.borderWidth = 1
            nameViewTF.layer.borderColor = DesignSystem.Colors.PrimaryOrange.color.cgColor
            nameViewTF.layer.cornerRadius = 15
            nameViewTF.layer.masksToBounds = true
            label.isHidden = false
            
        }else if textField == self.phoneTF {
            phoneViewTF.backgroundColor = DesignSystem.Colors.SecondBackground.color
            phoneViewTF.layer.borderWidth = 1
            phoneViewTF.layer.borderColor = DesignSystem.Colors.PrimaryOrange.color.cgColor
            phoneViewTF.layer.cornerRadius = 15
            phoneViewTF.layer.masksToBounds = true
            label2.isHidden = false
        }else if textField == self.countyCodeTF {
            phoneViewTF.backgroundColor = DesignSystem.Colors.SecondBackground.color
            phoneViewTF.layer.borderWidth = 1
            phoneViewTF.layer.borderColor = DesignSystem.Colors.PrimaryOrange.color.cgColor
            phoneViewTF.layer.cornerRadius = 15
            phoneViewTF.layer.masksToBounds = true
            label3.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.nameTF {
            nameViewTF.backgroundColor = DesignSystem.Colors.PrimaryGray.color
            nameViewTF.layer.borderWidth = 1
            nameViewTF.layer.borderColor = DesignSystem.Colors.PrimaryGray.color.cgColor
            nameViewTF.layer.cornerRadius = 15
            nameViewTF.layer.masksToBounds = true
            label.isHidden = true
        }else if textField == self.phoneTF {
            phoneViewTF.backgroundColor = DesignSystem.Colors.PrimaryGray.color
            phoneViewTF.layer.borderWidth = 1
            phoneViewTF.layer.borderColor = DesignSystem.Colors.PrimaryGray.color.cgColor
            phoneViewTF.layer.cornerRadius = 15
            phoneViewTF.layer.masksToBounds = true
            label2.isHidden = true
        }else if textField == self.countyCodeTF {
            phoneViewTF.backgroundColor = DesignSystem.Colors.PrimaryGray.color
            phoneViewTF.layer.borderWidth = 1
            phoneViewTF.layer.borderColor = DesignSystem.Colors.PrimaryGray.color.cgColor
            phoneViewTF.layer.cornerRadius = 15
            phoneViewTF.layer.masksToBounds = true
            label3.isHidden = true
        }
    }
    
    func sinkToLoadingOTP() {
//        self.viewModel.loadinState
//            .sink { [weak self] state in
//                self?.handleActivityIndicator(state: state)
//            }.store(in: &subscriber)
        self.viewModelOTP.loadState
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
        viewModelOTP.otpModelPublisher.sink { [weak self] result in
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
                
                //HelperConstant.savePhoneFaceId(phoneFaceId: self.finalPhone ?? "")
                //print(HelperConstant.getPhoneFaceId())
                
                //HelperConstant.saveIsoCodeFaceId(isoCodeFaceId: self.isoCode.lowercased() ?? "")
                //print(HelperConstant.getIsoCodeFaceId())
                //
                //HelperConstant.saveCountryCodeFaceId(countryCodeFaceId: self.countryCode ?? "")
                //print(HelperConstant.getCountryCodeFaceId())
                
                
                
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
    
    func sinkToLogin() {
        viewModel.loginModelPublisher.sink { [weak self] result in
            guard let self = self else { return }
            if result?.code == 200 {
                
                if result?.item?.verify == true {
                    
                    let stroyboard = UIStoryboard(name: "HawyTabbar", bundle: nil) //HawyTabbar //Subscriptions
                    let VC = stroyboard.instantiateViewController(withIdentifier: "HawyTabbarController") as? HawyTabbarController //HawyTabbarController //SubscriptionsViewController
                    
                    HelperConstant.saveNameFaceId(nameFaceId: self.nameTF.text ?? "")
                    print(HelperConstant.getCountryCodeFaceId())
                    
                    HelperConstant.saveToken(access_token: result?.item?.token ?? "")
                    print(HelperConstant.getToken())
                    
                    HelperConstant.saveUserId(userId: result?.item?.id ?? 0)
                    print(HelperConstant.getUserId())
                    
                    HelperConstant.saveCurrency(currency: result?.item?.currency ?? "K.D")
                    print(HelperConstant.getCurrency())
                    
                    HelperConstant.saveName(name: result?.item?.name ?? "no name")
                    print(HelperConstant.getName())
                    
                    HelperConstant.saveUserIdFaceId(userId: result?.item?.id ?? 0)
                    print(HelperConstant.getUserIdFaceId())
                    
                    HelperConstant.savePhoneFaceId(phoneFaceId: result?.item?.mobile ?? "")
                    print(HelperConstant.getPhoneFaceId())
                    
                    HelperConstant.saveIsoCodeFaceId(isoCodeFaceId: self.isoCode.lowercased() ?? "")
                    print(HelperConstant.getIsoCodeFaceId())
                    
                    HelperConstant.saveCountryCodeFaceId(countryCodeFaceId: self.countryCode ?? "")
                    print(HelperConstant.getCountryCodeFaceId())
                    
                    self.navigationController?.pushViewController(VC!, animated: true)
                    
                }else {
                    
                    let stroyboard = UIStoryboard(name: "Authentication", bundle: nil)
                    let VC = stroyboard.instantiateViewController(withIdentifier: "VeificationViewController") as? VeificationViewController
                    
                    HelperConstant.saveNameFaceId(nameFaceId: self.nameTF.text ?? "")
                    print(HelperConstant.getCountryCodeFaceId())
                    
                    VC?.isoCode = self.isoCode
                    VC?.phone = self.phoneTF.text ?? ""
                    VC?.countryCode = self.countryCode //countyCodeTF.text
                    VC?.homeOrNot = false
                    VC?.finalPhone = (self.countryCode ?? "") + (self.phoneTF.text ?? "")
                    VC?.name = self.nameTF.text
                    self.navigationController?.pushViewController(VC!, animated: true)
                    
                }
                
            }else if result?.code == 422 {
                ToastManager.shared.showError(message: result?.message ?? "", view: self.view)
            }
        }.store(in: &subscriber)
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        let stroyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let VC = stroyboard.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController
        navigationController?.pushViewController(VC!, animated: false)
    }
    @IBAction func loginButtonAction(_ sender: Any) {
        
        guard nameTF.text?.isEmpty == false else {
            ToastManager.shared.showError(message: "Please, Enter your name".localized, view: self.view)
            return
        }
        guard countyCodeTF.text?.isEmpty == false else {
            ToastManager.shared.showError(message: "Please, Enter your country code".localized, view: self.view)
            return
        }
        guard phoneTF.text?.isEmpty == false else {
            ToastManager.shared.showError(message: "Please, Enter your phone".localized, view: self.view)
            return
        }
        // check and guard for PhoneTF is Valid
        let fullPhone = (countryCode ?? "") + (phoneTF.text ?? "")
        guard fullPhone.replacedArabicDigitsWithEnglish.isValidPhone == true else {
            ToastManager.shared.showError(message: "Please, Enter a valid phone number".localized, view: self.view)
            return
        }
        
        Task {
            do {
                print(countryCode ?? "", phoneTF.text, fullPhone)
                let login = try await viewModel.sendLogin(mobile: phoneTF.text, name: nameTF.text, countryCode: countryCode, isoCode: isoCode.lowercased())
                print(login)
            }catch {
                // tell the user something went wrong, I hope
                debugPrint(error)
            }
        }
    }
    
    @IBAction func guestButtonAction(_ sender: Any) {
        
        UserDefaults.standard.setValue(nil, forKey: "access_token")
        UserDefaults.standard.setValue(nil, forKey: "userId")
        let stroyboard = UIStoryboard(name: "HawyTabbar", bundle: nil)
        let VC = stroyboard.instantiateViewController(withIdentifier: "HawyTabbarController") as? HawyTabbarController
        navigationController?.pushViewController(VC!, animated: true)
        
    }
    
    @IBAction func faceAndTouchIDButtonTapped(_ sender: UIButton) {
        
        let context = LAContext()
        var error: NSError? = nil
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            let reason = "please authorize with touch id for make login"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] (success, error) in
                
                DispatchQueue.main.async {
                    
                    guard success, error == nil else {
                        
                        // faild
                        let alert = UIAlertController(title: "Faild to Authenticate", message: "Please try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        self?.present(alert, animated: true)
                        return
                    }
                    
                    // show other screen
                    // success
                    
                    self?.getProfileData()
                    
                }
            }
            
        }else {
            // can not use
            
            let alert = UIAlertController(title: "Unavailable", message: "You can't use this feature", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            
        }
        
    }
    
    func getProfileData() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            //"Authorization": "Bearer \(HelperConstant.getToken() ?? "")"
        ]
        
        let param: [String: Any] = [
            "user_id" : HelperConstant.getUserIdFaceId() ?? 0,
            "mobile" : HelperConstant.getPhoneFaceId() ?? ""
        ]
        
        //showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/auth/user", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(ProfileModel.self, from: response.data!)
                
                if productResponse.code == 200 {
                    
                    Task {
                        do {
                            //print(countryCode, phone)
                            //let login = try await self.viewModel.sendLogin(mobile: HelperConstant.getPhoneFaceId(), name: HelperConstant.getNameFaceId(), countryCode: HelperConstant.getCountryCodeFaceId(), isoCode: HelperConstant.getIsoCodeFaceId())
                            //print(login)
                            
                            print(HelperConstant.getPhoneFaceId(), HelperConstant.getCountryCodeFaceId(), HelperConstant.getIsoCodeFaceId())
                            
                            let otp = try await self.viewModelOTP.sendOtp(mobile: HelperConstant.getPhoneFaceId(), otp: "1234", countryCode: HelperConstant.getCountryCodeFaceId(), isoCode: HelperConstant.getIsoCodeFaceId())
                            print(otp)
                            
                        }catch {
                            // tell the user something went wrong, I hope
                            debugPrint(error)
                        }
                        
                    }
                    
                }else if productResponse.code == 422 {
                    ToastManager.shared.showError(message: productResponse.message ?? "", view: self.view)
                }
                
                //self.hideIndecator()
            } catch {
                //self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
}

extension LoginViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(list[row].flag ?? "") \(list[row].name ?? "")"
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        countyCodeTF.text = "\(list[row].flag ?? "") \( list[row].extensionCode ?? "")"
        isoCode = list[row].countryCode ?? ""
        print(list[row].countryCode, list[row].currencyCode, list[row].currencySymbol, list[row].extensionCode)
        countryCode = "+" + "\(list[row].extensionCode ?? "")" //list[row].extensionCode
    }
    
}

class PaddedLabel: UILabel {
    override var intrinsicContentSize: CGSize {
        CGSize(width: super.intrinsicContentSize.width + 20, height: super.intrinsicContentSize.height)
    }
}

//MARK: Find the Country Code
extension NSLocale {
    func extensionCode(countryCode : String?) -> String? {
        let prefixCodes = ["AC" : "247", "AF": "93", "AE": "971", "AL": "355", "AN": "599", "AS":"1", "AD": "376", "AO": "244", "AI": "1", "AG":"1", "AR": "54","AM": "374", "AW": "297", "AU":"61", "AT": "43","AZ": "994", "BS": "1", "BH":"973", "BF": "226","BI": "257", "BD": "880", "BB": "1", "BY": "375", "BE":"32","BZ": "501", "BJ": "229", "BM": "1", "BT":"975", "BA": "387", "BW": "267", "BR": "55", "BG": "359", "BO": "591", "BL": "590", "BN": "673", "CC": "61", "CD":"243","CI": "225", "KH":"855", "CM": "237", "CA": "1", "CV": "238", "KY":"345", "CF":"236", "CH": "41", "CL": "56", "CN":"86","CX": "61", "CO": "57", "KM": "269", "CG":"242", "CK": "682", "CR": "506", "CU":"53", "CY":"537","CZ": "420", "DE": "49", "DK": "45", "DJ":"253", "DM": "1", "DO": "1", "DZ": "213", "EC": "593", "EG":"20", "ER": "291", "EE":"372","ES": "34", "ET": "251", "FM": "691", "FK": "500", "FO": "298", "FJ": "679", "FI":"358", "FR": "33", "GB":"44", "GF": "594", "GA":"241", "GS": "500", "GM":"220", "GE":"995","GH":"233", "GI": "350", "GQ": "240", "GR": "30", "GG": "44", "GL": "299", "GD":"1", "GP": "590", "GU": "1", "GT": "502", "GN":"224","GW": "245", "GY": "595", "HT": "509", "HR": "385", "HN":"504", "HU": "36", "HK": "852", "IR": "98", "IM": "44", "IL": "972", "IO":"246", "IS": "354", "IN": "91", "ID":"62", "IQ":"964", "IE": "353","IT":"39", "JM":"1", "JP": "81", "JO": "962", "JE":"44", "KP": "850", "KR": "82","KZ":"77", "KE": "254", "KI": "686", "KW": "965", "KG":"996","KN":"1", "LC": "1", "LV": "371", "LB": "961", "LK":"94", "LS": "266", "LR":"231", "LI": "423", "LT": "370", "LU": "352", "LA": "856", "LY":"218", "MO": "853", "MK": "389", "MG":"261", "MW": "265", "MY": "60","MV": "960", "ML":"223", "MT": "356", "MH": "692", "MQ": "596", "MR":"222", "MU": "230", "MX": "52","MC": "377", "MN": "976", "ME": "382", "MP": "1", "MS": "1", "MA":"212", "MM": "95", "MF": "590", "MD":"373", "MZ": "258", "NA":"264", "NR":"674", "NP":"977", "NL": "31","NC": "687", "NZ":"64", "NI": "505", "NE": "227", "NG": "234", "NU":"683", "NF": "672", "NO": "47","OM": "968", "PK": "92", "PM": "508", "PW": "680", "PF": "689", "PA": "507", "PG":"675", "PY": "595", "PE": "51", "PH": "63", "PL":"48", "PN": "872","PT": "351", "PR": "1","PS": "970", "QA": "974", "RO":"40", "RE":"262", "RS": "381", "RU": "7", "RW": "250", "SM": "378", "SA":"966", "SN": "221", "SC": "248", "SL":"232","SG": "65", "SK": "421", "SI": "386", "SB":"677", "SH": "290", "SD": "249", "SR": "597","SZ": "268", "SE":"46", "SV": "503", "ST": "239","SO": "252", "SJ": "47", "SY":"963", "TW": "886", "TZ": "255", "TL": "670", "TD": "235", "TJ": "992", "TH": "66", "TG":"228", "TK": "690", "TO": "676", "TT": "1", "TN":"216","TR": "90", "TM": "993", "TC": "1", "TV":"688", "UG": "256", "UA": "380", "US": "1", "UY": "598","UZ": "998", "VA":"379", "VE":"58", "VN": "84", "VG": "1", "VI": "1","VC":"1", "VU":"678", "WS": "685", "WF": "681", "YE": "967", "YT": "262","ZA": "27" , "ZM": "260", "ZW":"263", "AQ" : "672", "AX" : "358", "BQ" : "599", "BV": "55"]
        
        let countryDialingCode = prefixCodes[countryCode ?? "IN"] ?? nil
        return countryDialingCode
    }
}

extension String {
    
    static func flag(for code: String) -> String? {
        
        func isLowerCaseASCIIScaler(_ scaler: Unicode.Scalar) -> Bool {
            return scaler.value >= 0x16 && scaler.value <= 0x7A
        }
        func regionalIndecatorSymbol(for scaler: Unicode.Scalar) -> Unicode.Scalar {
            precondition(isLowerCaseASCIIScaler(scaler))
            return Unicode.Scalar(scaler.value + (0x1F1E6 - 0x61))!
        }
        
        let lowerCasedCode = code.lowercased()
        guard lowerCasedCode.count == 2 else { return nil }
        guard lowerCasedCode.unicodeScalars.reduce(true, { accum, scaler in
            accum && isLowerCaseASCIIScaler(scaler)
        }) else { return nil }
        
        let indicatorSymbole = lowerCasedCode.unicodeScalars.map ({ regionalIndecatorSymbol(for: $0) })
        return String(indicatorSymbole.map({ Character($0) }))
        
    }
    
}
