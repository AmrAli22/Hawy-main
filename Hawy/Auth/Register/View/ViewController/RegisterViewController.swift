//
//  RegisterViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 07/08/2022.
//

import UIKit
import Combine

class RegisterViewController: BaseViewViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameViewTF: UIView!
    @IBOutlet weak var phoneViewTF: UIView!
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var countyCodeTF: UITextField!
    @IBOutlet weak var checkBoxButtonOutlet: UIButton!{
        didSet{
            checkBoxButtonOutlet.setImage(UIImage(named:"TOGGLE"), for: .normal)
            checkBoxButtonOutlet.setImage(UIImage(named:"TOGGLE-1"), for: .selected)
        }
        
    }
    
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
    
    var checkCheck: Bool? = false
    
    var countryCode: String?
    
    var isoCode = ""
    
    private var viewModel = RegisterViewModel()
    var subscriber = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        sinkToRegister()
        
        phoneViewTF.semanticContentAttribute = .forceLeftToRight
        
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
        self.countyCodeTF.text = "\(list[127].flag ?? "") \( list[127].extensionCode ?? "")"
        self.countryCode = "+" + "\(list[127].extensionCode ?? "")"
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
    
    func sinkToRegister() {
        viewModel.registerModelPublisher.sink { [weak self] result in
            guard let self = self else { return }
            if result?.code == 200 {
                let stroyboard = UIStoryboard(name: "Authentication", bundle: nil)
                let VC = stroyboard.instantiateViewController(withIdentifier: "VeificationViewController") as? VeificationViewController
                VC?.phone = (self.countryCode ?? "") + (self.phoneTF.text ?? "")
                VC?.countryCode = self.countyCodeTF.text
                VC?.isoCode = self.isoCode
                VC?.homeOrNot = false
                self.navigationController?.pushViewController(VC!, animated: true)
            }else if result?.code == 422 {
                ToastManager.shared.showError(message: result?.message ?? "", view: self.view)
            }
        }.store(in: &subscriber)
    }
    @IBAction func termsButtonTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
        navigationController?.pushViewController(VC, animated: true)
        
    }
    
    @IBAction func checkBoxButtonAction(_ sender: UIButton) {
        sender.checkboxAnimation {
            if sender.isSelected == false {
                print("Un check")
                print("false")
                self.checkCheck = false
                //here you can also track the Checked, UnChecked state with sender.isSelected
                print(sender.isSelected)
            }else{
                print("check")
                print("True")
                self.checkCheck = true
                //here you can also track the Checked, UnChecked state with sender.isSelected
                print(sender.isSelected)
            }
        }
        
    }
    
    
    @IBAction func loginButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
    @IBAction func registerButtonAction(_ sender: Any) {
        
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
        
        guard checkCheck == true else {
            ToastManager.shared.showError(message: "Please, Accept terms and conditions".localized, view: self.view)
            return
        }
        
        Task {
            do {
                let register = try await viewModel.sendRegister(mobile: phoneTF.text, name: nameTF.text, countryCode: countryCode, isoCode: isoCode.lowercased())
                print(register)
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
    
    @IBAction func temsConditionButtonAction(_ sender: Any) {
        
//        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
//        let VC = storyboard.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
//        navigationController?.pushViewController(VC, animated: true)
        
    }
    
    
}

extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        countryCode = "+" + "\(list[row].extensionCode ?? "")"
    }
    
}
