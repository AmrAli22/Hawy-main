//
//  TransferOwnershipCardViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 02/09/2022.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class TransferOwnershipCardViewController: BottomPopupViewController, UITextFieldDelegate {
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .ballClipRotatePulse, color: DesignSystem.Colors.PrimaryBlue.color, padding: 0)
    
    lazy var containerOfLoading: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.15)
        return view
        
    }()
    
    @IBOutlet weak var phoneViewTF: UIView!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var countyCodeTF: UITextField!
    
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
    
    var cardId: Int?
    
    var selected_Index : Int?
    var height: CGFloat?
    //var Delegate : AddNewAddress!
    //var delegateAction: delegate?
    //var delegYourAdderss: delegateAddress?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        phoneTF.delegate = self
        countyCodeTF.delegate = self
        
        phoneViewTF.backgroundColor = DesignSystem.Colors.PrimaryGray.color
        phoneViewTF.layer.borderWidth = 1
        phoneViewTF.layer.borderColor = DesignSystem.Colors.PrimaryGray.color.cgColor
        phoneViewTF.layer.cornerRadius = 15
        phoneViewTF.layer.masksToBounds = true
        label2.isHidden = true
        label3.isHidden = true
        
        view.addSubview(label2)
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.topAnchor.constraint(equalTo: phoneViewTF.topAnchor, constant: -10).isActive = true
        label2.leadingAnchor.constraint(equalTo: phoneViewTF.leadingAnchor, constant: 15).isActive = true
        
        view.addSubview(label3)
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.topAnchor.constraint(equalTo: phoneViewTF.topAnchor, constant: -10).isActive = true
        label3.leadingAnchor.constraint(equalTo: phoneViewTF.leadingAnchor, constant: 15).isActive = true
    
        pickerView.dataSource = self
        pickerView.delegate = self
        countyCodeTF.inputView = pickerView
        pickerView.selectRow(127, inComponent: 0, animated: false)
        
        configuration()
        
    }
    
    override func getPopupHeight() -> CGFloat {
        return height ?? CGFloat(450)
    }
    
    override func getPopupTopCornerRadius() -> CGFloat {
        return 35
    }
    
    override func getPopupPresentDuration() -> Double {
        return presentDuration ?? 1.0
    }
    
    override func getPopupDismissDuration() -> Double {
        return dismissDuration ?? 1.0
    }
    
    override func shouldPopupDismissInteractivelty() -> Bool {
        return shouldDismissInteractivelty ?? false
    }
    
    func showIndecator() {
        addLoaderToView(mainView: view, containerOfLoading: containerOfLoading, loading: loading)
    }
    
    func hideIndecator() {
        removeLoader(containerOfLoading: containerOfLoading, loading: loading)
    }
    
    func configuration() {
        for code in NSLocale.isoCountryCodes  {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_US").displayName(forKey: NSLocale.Key.identifier, value: id)
            
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
        self.countyCodeTF.text = "\(list[127].flag ?? "") \( list[127].extensionCode ?? "")"
        self.pickerView.reloadAllComponents()
    }
    
    @objc
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func performRequest() { //url: String, parameters: [String:Any]
        
        let url = "https://hawy-kw.com/api/auth/profile/cards/ownership"
        
        let param: [String: Any] = [
            
            "card_id" : cardId ?? 0,
            "mobile": phoneTF.text ?? "",
            "iso_code": isoCode.lowercased()
            
        ]
        
        print(param)
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator()
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers) // //URLEncoding.httpBody
            .validate(statusCode: 200...500)
        
            .responseJSON { response in
                
                print(param)
                print(headers)
                print(response)
                print(response.result)
                
                switch response.result {
                    
                case .success(let JSON):
                    
                    print("Validation Successful with response JSON \(JSON)")
                    
                    guard let data = response.data else { return }
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        let forgetPasswordRequest = try decoder.decode(ShowCardDetailsModel.self, from: data)
                        print(forgetPasswordRequest)
                        
                        if forgetPasswordRequest.message == "Unauthenticated." {
                            
                            let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
                                
                                
                                let story = UIStoryboard(name: "Authentication", bundle:nil)
                                let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                                UIApplication.shared.windows.first?.makeKeyAndVisible()
                                
                            }
                            //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
                            alert.addAction(okAction)
                            //alert.addAction(cancelAction)
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        
                        if forgetPasswordRequest.code == 200 {
                            
                            print("success")
                            let story = UIStoryboard(name: "HawyTabbar", bundle:nil)
                            let vc = story.instantiateViewController(withIdentifier: "HawyTabbarController") as! HawyTabbarController
                            vc.isAddCard = true
                            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                            
                        }else if forgetPasswordRequest.code == 422 {
                            
                            ToastManager.shared.showError(message: forgetPasswordRequest.message ?? "", view: self.view)
                            
                        }
                        
                        self.hideIndecator()
                    } catch let error {
                        self.hideIndecator()
                        print(error)
                        
                    }
                    
                case .failure(let error):
                    
                    print("Request failed with error \(error)")
                    
                }
                
            }
        
    }
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        
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
        
        print("Full Phone Number is : \((countryCode ?? "") + (phoneTF.text ?? ""))")
        performRequest()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.phoneTF {
            dismissKeyboard()
        }else {
            dismissKeyboard()
        }
        return true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.phoneTF {
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
        
        if textField == self.phoneTF {
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
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension TransferOwnershipCardViewController: BottomPopupDelegate {
    func bottomPopupViewLoaded() {
        print("bottomPopupViewLoaded")
        shouldDismissInteractivelty = false
    }
    
    func bottomPopupWillAppear() {
        print("bottomPopupWillAppear")
    }
    
    func bottomPopupDidAppear() {
        print("bottomPopupDidAppear")
    }
    
    func bottomPopupWillDismiss() {
        print("bottomPopupWillDismiss")
    }
    
    func bottomPopupDidDismiss() {
        print("bottomPopupDidDismiss")
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
}

extension TransferOwnershipCardViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        countryCode = list[row].extensionCode
    }
    
}
