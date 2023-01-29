//
//  EditeProfileViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 25/08/2022.
//

import UIKit
import Alamofire

class EditeProfileViewController: BaseViewViewController, UITextFieldDelegate, BottomPopupDelegate {
    
    @IBOutlet weak var firstContainerView: UIView!
    
    @IBOutlet weak var nameViewTF: UIView!
    @IBOutlet weak var phoneViewTF: UIView!
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var countyCodeTF: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    
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
    
    var userImageData: Data?
    var image: String?
    
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
        
        phoneViewTF.semanticContentAttribute = .forceLeftToRight
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProfileData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        firstContainerView.roundCorners([.topLeft, .topRight], radius: 20)
    }
    
    func getProfileData() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")"
        ]
        
        showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/auth/profile?user_id=\(HelperConstant.getUserId() ?? 0)", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(ProfileModel.self, from: response.data!)
                
                if productResponse.message == "Unauthenticated." {
                    
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
                
                if productResponse.code == 200 {
                    print("success")
                    
                    self.userImage.loadImage(URLS.baseImageURL+(productResponse.item?.image ?? ""))
                    self.nameTF.text = productResponse.item?.name ?? ""
                    self.countyCodeTF.text = productResponse.item?.code  ?? ""
                    self.phoneTF.text = productResponse.item?.mobile ?? ""
                    self.isoCode = productResponse.item?.iso_code ?? ""
                    
                }
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    func updateUserImage() {
        
        let token = HelperConstant.getToken()
        print(token)
        
        let parameters: [String: Any] = [
            
            "name" : nameTF.text ?? "",
            "mobile" : phoneTF.text ?? "",
            "image_url": image ?? "",
            "iso_code": isoCode.lowercased()
            
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(token ?? "")"
        ]
        
        showIndecator()
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                
            }
            
            if(self.userImageData != nil ) {
                multipartFormData.append(self.userImageData ?? Data() , withName: "image_file", fileName: "image.jpg", mimeType: "image/jpg")
            }
            
        }, to: "https://hawy-kw.com/api/auth/profile/update" , headers: headers)
        .validate(statusCode: 200...500)
        .responseJSON { (response) in
            print(response)
            if let data = response.data {
                print(data)
                do {
                    let addPostResponse = try JSONDecoder().decode(ProfileModel.self, from: data)
                    
                    if addPostResponse.message == "Unauthenticated." {
                        
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
                    
                    if addPostResponse.code == 200 {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            self.getProfileData()
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    }else if let message = addPostResponse.message {
                        print(message)
                    }
                    self.hideIndecator()
                } catch {
                    print(error)
                    self.hideIndecator()
                }
            }
            
        }
        
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
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeImageButtonAction(_ sender: Any) {
        
        let storyborad = UIStoryboard(name: "Profile", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "ChangeImageProfileViewController") as! ChangeImageProfileViewController
        VC.height = 550 //self.view.frame.height - 100
        VC.topCornerRadius = 8
        VC.presentDuration = 0.5
        VC.dismissDuration = 0.5
        VC.popupDelegate = self
        VC.backData = { [weak self] (imageURL, imageLink, photoData) in
            guard let self = self else { return }
        
            print(imageURL, imageLink)
            
            self.image = imageLink
            self.userImage.loadImage(imageURL)
            self.userImageData = photoData //self.userImage.image?.jpegData(compressionQuality: 0.5)
        
        }
        
        //VC.delegateAction = self
        //        VC.dataBackClouser = { [weak self] selected, value in
        //            guard let self = self else { return }
        //            print(selected, value)
        //            self.selectedLanguage = selected
        //            self.valueLanguage = value
        //            self.myLanguagesTFOutlet.text = value.joined(separator: ",")
        //        }
        self.present(VC, animated: true, completion: nil)
        
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
//        guard nameTF.text?.isEmpty == false else {
//            ToastManager.shared.showError(message: "Please, Enter your name", view: self.view)
//            return
//        }
//        guard countyCodeTF.text?.isEmpty == false else {
//            ToastManager.shared.showError(message: "Please, Enter your country code", view: self.view)
//            return
//        }
//        guard phoneTF.text?.isEmpty == false else {
//            ToastManager.shared.showError(message: "Please, Enter your phone", view: self.view)
//            return
//        }
//        // check and guard for PhoneTF is Valid
//        let fullPhone = (countryCode ?? "") + (phoneTF.text ?? "")
//        guard fullPhone.replacedArabicDigitsWithEnglish.isValidPhone == true else {
//            ToastManager.shared.showError(message: "Please, Enter a valid phone number", view: self.view)
//            return
//        }
        
//        guard userImageData?.isEmpty == false else {
//            ToastManager.shared.showError(message: "Please, Enter a valid phone number", view: self.view)
//            return
//        }
        
        print("Full Phone Number is : \((countryCode ?? "") + (phoneTF.text ?? ""))")
        
        updateUserImage()
        
        
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
    
}

extension EditeProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        isoCode = list[row].countryCode ?? ""
        countyCodeTF.text = "\(list[row].flag ?? "") \( list[row].extensionCode ?? "")"
        countryCode = "+" + "\(list[row].extensionCode ?? "")"
    }
    
}
