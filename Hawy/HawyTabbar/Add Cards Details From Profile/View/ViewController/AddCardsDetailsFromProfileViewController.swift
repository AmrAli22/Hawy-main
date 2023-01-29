//
//  AddCardsDetailsFromProfileViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 30/08/2022.
//

import UIKit
import Combine
import SwiftUI
import Alamofire

struct ADDVacce: Equatable, Codable {
    var vacc: String?
    static func == (lhs: ADDVacce, rhs: ADDVacce) -> Bool {
        return lhs.vacc == rhs.vacc
    }
}

struct ADDPrope: Equatable, Codable {
    var prope: String?
    static func == (lhs: ADDPrope, rhs: ADDPrope) -> Bool {
        return lhs.prope == rhs.prope
    }
}

class AddCardsDetailsFromProfileViewController: BaseViewViewController, UITextFieldDelegate, BottomPopupDelegate {
    
    @IBOutlet weak var scrollViewOutlet: UIScrollView!
    @IBOutlet weak var containerViewInScrollViewOutlet: UIView!
    
    @IBOutlet weak var orderDetailTableView: UITableView!
    @IBOutlet weak var orderDetailTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ddProoertyTableView: UITableView!
    @IBOutlet weak var ddProoertyTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var animalNameView: UIView!
    @IBOutlet weak var animalNameTF: UITextField!
    
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var typeTF: UITextField!
    
    @IBOutlet weak var fatherNameView: UIView!
    @IBOutlet weak var fatherNameTF: UITextField!
    
    @IBOutlet weak var motherNameView: UIView!
    @IBOutlet weak var motherNameTF: UITextField!
    
    @IBOutlet weak var ageView: UIView!
    @IBOutlet weak var ageTF: UITextField!
    
    @IBOutlet weak var docNumView : UIView!
    @IBOutlet weak var docNumTF: UITextField!
    
    @IBOutlet weak var addVaccenationView: UIView!
    @IBOutlet weak var addProductTFOutlet: UITextField!
    @IBOutlet weak var addVaccenationButtonOutlet: UIButton!
    @IBOutlet weak var minusVaccenationButtonOutlet: UIButton!
    @IBOutlet weak var vaccenationPlusImage: UIImageView!
    @IBOutlet weak var vaccenationMinusImage: UIImageView!
    
    @IBOutlet weak var addPropertyView: UIView!
    @IBOutlet weak var addPropertyTFOutlet: UITextField!
    @IBOutlet weak var addPropertyButtonOutlet: UIButton!
    @IBOutlet weak var minusPropertyButtonOutlet: UIButton!
    @IBOutlet weak var propertyPlusImage: UIImageView!
    @IBOutlet weak var propertyMinusImage: UIImageView!
    
    @IBOutlet weak var ownerNameView: UIView!
    @IBOutlet weak var ownerNameTF: UITextField!
    @IBOutlet weak var noteTF: TextViewWithPlaceholder!
    
    lazy var label1: PaddedLabel = {
        let label = PaddedLabel()
        label.text = "Animal Name".localized
        label.backgroundColor = DesignSystem.Colors.SecondBackground.color
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    lazy var label2: PaddedLabel = {
        let label = PaddedLabel()
        label.text = "Type".localized
        label.backgroundColor = DesignSystem.Colors.SecondBackground.color
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    lazy var label3: PaddedLabel = {
        let label = PaddedLabel()
        label.text = "Father Name".localized
        label.backgroundColor = DesignSystem.Colors.SecondBackground.color
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    lazy var label4: PaddedLabel = {
        let label = PaddedLabel()
        label.text = "Mother Name".localized
        label.backgroundColor = DesignSystem.Colors.SecondBackground.color
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    lazy var label5: PaddedLabel = {
        let label = PaddedLabel()
        label.text = "Age".localized
        label.backgroundColor = DesignSystem.Colors.SecondBackground.color
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    lazy var label6: PaddedLabel = {
        let label = PaddedLabel()
        label.text = "Vaccination Name".localized
        label.backgroundColor = DesignSystem.Colors.SecondBackground.color
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    lazy var label7: PaddedLabel = {
        let label = PaddedLabel()
        label.text = "Add Owner".localized
        label.backgroundColor = DesignSystem.Colors.SecondBackground.color
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    lazy var label8: PaddedLabel = {
        let label = PaddedLabel()
        label.text = "Owner Name".localized
        label.backgroundColor = DesignSystem.Colors.SecondBackground.color
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var label9: PaddedLabel = {
        let label = PaddedLabel()
        label.text = "Doc number".localized
        label.backgroundColor = DesignSystem.Colors.SecondBackground.color
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    
    var addVacce = [ADDVacce]()
    var addPrope = [ADDPrope]()
    var orderName = [String]()
    var propertyName = [String]()
    var index = 0
    var select = true
    
    var returnBack: ((String, Int) -> Void)?
    var catID: String?
    var inoculations: String?
    var owners: String?
    var inocData: Data?
    var ownData: Data?
    
    var mainImmage: String?
    var video: String?
    var images: [String]?
    
    private var viewModel = AddCardDetailsViewModel()
    var subscriber = Set<AnyCancellable>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderDetailTableView.tableFooterView = UIView()
        orderDetailTableView.separatorStyle = .none
        
        ddProoertyTableView.tableFooterView = UIView()
        ddProoertyTableView.separatorStyle = .none
        
        orderDetailTableView.register(UINib(nibName: "VaccinationNameTableViewCell", bundle: nil), forCellReuseIdentifier: "VaccinationNameTableViewCell")
        ddProoertyTableView.register(UINib(nibName: "AddProoertyTableViewCell", bundle: nil), forCellReuseIdentifier: "AddProoertyTableViewCell")
        
        orderDetailTableView.delegate = self
        orderDetailTableView.dataSource = self
        
        ddProoertyTableView.delegate = self
        ddProoertyTableView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        animalNameTF.delegate = self
        typeTF.delegate = self
        fatherNameTF.delegate = self
        motherNameTF.delegate = self
        ageTF.delegate = self
        addProductTFOutlet.delegate = self
        addPropertyTFOutlet.delegate = self
        ownerNameTF.delegate = self
        docNumTF.delegate = self
        
        animalNameView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
        animalNameView.layer.borderWidth = 1
        animalNameView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
        animalNameView.layer.cornerRadius = 15
        animalNameView.layer.masksToBounds = true
        label1.isHidden = true
        
        typeView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
        typeView.layer.borderWidth = 1
        typeView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
        typeView.layer.cornerRadius = 15
        typeView.layer.masksToBounds = true
        label2.isHidden = true
        
        fatherNameView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
        fatherNameView.layer.borderWidth = 1
        fatherNameView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
        fatherNameView.layer.cornerRadius = 15
        fatherNameView.layer.masksToBounds = true
        label3.isHidden = true
        
        motherNameView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
        motherNameView.layer.borderWidth = 1
        motherNameView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
        motherNameView.layer.cornerRadius = 15
        motherNameView.layer.masksToBounds = true
        label4.isHidden = true
        
        ageView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
        ageView.layer.borderWidth = 1
        ageView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
        ageView.layer.cornerRadius = 15
        ageView.layer.masksToBounds = true
        label5.isHidden = true
        
        docNumView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
        docNumView.layer.borderWidth = 1
        docNumView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
        docNumView.layer.cornerRadius = 15
        docNumView.layer.masksToBounds = true
        label9.isHidden = true
        
        addVaccenationView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
        addVaccenationView.layer.borderWidth = 1
        addVaccenationView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
        addVaccenationView.layer.cornerRadius = 15
        addVaccenationView.layer.masksToBounds = true
        label6.isHidden = true
        addVaccenationButtonOutlet.isEnabled = false
        minusVaccenationButtonOutlet.isEnabled = false
        
        addPropertyView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
        addPropertyView.layer.borderWidth = 1
        addPropertyView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
        addPropertyView.layer.cornerRadius = 15
        addPropertyView.layer.masksToBounds = true
        label7.isHidden = true
        addPropertyButtonOutlet.isEnabled = false
        minusPropertyButtonOutlet.isEnabled = false
        
        ownerNameView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
        ownerNameView.layer.borderWidth = 1
        ownerNameView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
        ownerNameView.layer.cornerRadius = 15
        ownerNameView.layer.masksToBounds = true
        label8.isHidden = true
        
        view.addSubview(label1)
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.topAnchor.constraint(equalTo: animalNameView.topAnchor, constant: -10).isActive = true
        label1.leadingAnchor.constraint(equalTo: animalNameView.leadingAnchor, constant: 15).isActive = true
        
        view.addSubview(label2)
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.topAnchor.constraint(equalTo: typeView.topAnchor, constant: -10).isActive = true
        label2.leadingAnchor.constraint(equalTo: typeView.leadingAnchor, constant: 15).isActive = true
        
        view.addSubview(label3)
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.topAnchor.constraint(equalTo: fatherNameView.topAnchor, constant: -10).isActive = true
        label3.leadingAnchor.constraint(equalTo: fatherNameView.leadingAnchor, constant: 15).isActive = true
        
        view.addSubview(label4)
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.topAnchor.constraint(equalTo: motherNameView.topAnchor, constant: -10).isActive = true
        label4.leadingAnchor.constraint(equalTo: motherNameView.leadingAnchor, constant: 15).isActive = true
        
        view.addSubview(label5)
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.topAnchor.constraint(equalTo: ageView.topAnchor, constant: -10).isActive = true
        label5.leadingAnchor.constraint(equalTo: ageView.leadingAnchor, constant: 15).isActive = true
        
        view.addSubview(label6)
        label6.translatesAutoresizingMaskIntoConstraints = false
        label6.topAnchor.constraint(equalTo: addVaccenationView.topAnchor, constant: -10).isActive = true
        label6.leadingAnchor.constraint(equalTo: addVaccenationView.leadingAnchor, constant: 15).isActive = true
        
        view.addSubview(label7)
        label7.translatesAutoresizingMaskIntoConstraints = false
        label7.topAnchor.constraint(equalTo: addPropertyView.topAnchor, constant: -10).isActive = true
        label7.leadingAnchor.constraint(equalTo: addPropertyView.leadingAnchor, constant: 15).isActive = true
        
        view.addSubview(label8)
        label8.translatesAutoresizingMaskIntoConstraints = false
        label8.topAnchor.constraint(equalTo: ownerNameView.topAnchor, constant: -10).isActive = true
        label8.leadingAnchor.constraint(equalTo: ownerNameView.leadingAnchor, constant: 15).isActive = true
        
        view.addSubview(label9)
        label9.translatesAutoresizingMaskIntoConstraints = false
        label9.topAnchor.constraint(equalTo: docNumView.topAnchor, constant: -10).isActive = true
        label9.leadingAnchor.constraint(equalTo: docNumView.leadingAnchor, constant: 15).isActive = true
        
        sinkToLoading()
        sinkToReloading()
        sinkToGetCatAndSub()
        
        getProfileData()
        
        noteTF.placeholderText = "Type your note".localized
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            
            self.scrollViewOutlet.roundCorners([.topLeft, .topRight], radius: 20)
            self.containerViewInScrollViewOutlet.roundCorners([.topLeft, .topRight], radius: 20)
            
            self.orderDetailTableViewHeight.constant = self.orderDetailTableView.contentSize.height
            
            self.ddProoertyTableViewHeight.constant = self.ddProoertyTableView.contentSize.height
            
        }
    }
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        
        DispatchQueue.main.async {
            
            self.orderDetailTableViewHeight.constant = self.orderDetailTableView.contentSize.height
            
            self.ddProoertyTableViewHeight.constant = self.ddProoertyTableView.contentSize.height
            
        }
    }
    
    func getProfileData() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")"
        ]
        
        //showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/auth/profile?user_id=20", method: .get, parameters: nil, headers: headers)
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
                
                //self.hideIndecator()
            } catch {
                //self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
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
    
    func sinkToReloading() {

        self.viewModel.reloadingState
            .sink { [weak self] (state) in
                if state {
                    //self?.typesTableView.reloadData()
                }
            }.store(in: &subscriber)
    }
    
    func sinkToGetCatAndSub() {
        viewModel.addCardDetailsModelPublisher.sink { [weak self] (result) in
            guard let self = self else { return }
            
            if result?.message == "Unauthenticated." {
                
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
            
            if result?.code == 200 {
               print(result)
                
//                let storyborad = UIStoryboard(name: "Profile", bundle: nil)
//                let VC = storyborad.instantiateViewController(withIdentifier: "ShowAddedCardDetailsViewController") as? ShowAddedCardDetailsViewController
//                self.navigationController?.pushViewController(VC!, animated: false)
                
//                let stroyboard = UIStoryboard(name: "Subscriptions", bundle: nil)
//                let VC = stroyboard.instantiateViewController(withIdentifier: "PaymetViewController") as? PaymetViewController
//                self.navigationController?.pushViewController(VC!, animated: true)
                
                let story = UIStoryboard(name: "HawyTabbar", bundle:nil)
                let vc = story.instantiateViewController(withIdentifier: "HawyTabbarController") as! HawyTabbarController
                vc.isAddCard = true
                UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                UIApplication.shared.windows.first?.makeKeyAndVisible()
                
            }
        }.store(in: &subscriber)
    }
    
    @objc
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func add(_ sender: Any) {
        
        guard addProductTFOutlet.text?.isEmpty == false else { return }
        if let text = addProductTFOutlet.text {
            //orderName.append(text)
            orderName.insert(text, at: 0)
            addVacce.append(ADDVacce(vacc: text))
            let indexPath = IndexPath(row: orderName.count - 1, section: 0)
            orderDetailTableView.beginUpdates()
            orderDetailTableView.insertRows(at: [indexPath], with: .automatic)
            orderDetailTableView.endUpdates()
            addProductTFOutlet.text = ""
            orderDetailTableView.reloadData()
            //self.orderDetailTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            print(addVacce.toDictionary4())
            print(orderName.toDictionary4())
            let cookieHeader = orderName.toDictionary4().map { "\(String($0.0))" + ":" + "\($0.1)" }.joined(separator: ", ")
            print("{\(cookieHeader)}")
            //inoculations = "{\(cookieHeader)}"
            print(orderName)
            
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted

            let jsonData = try? jsonEncoder.encode(orderName.toDictionary4())
            inocData = jsonData
            if let jsonString = String(data: jsonData ?? Data(), encoding: .utf8) {
                print(jsonString)
                inoculations = jsonString
            }
            
        }
        
        func convertToDecode(vacc: ADDVacce) {
            let orderToApi = try? vacc.asDictionary2()
            print(orderToApi)
            
        }
        
    }
    
    @IBAction func minusVaccenationButtonAction(_ sender: Any) {
        
        addVaccenationView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
        addVaccenationView.layer.borderWidth = 1
        addVaccenationView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
        addVaccenationView.layer.cornerRadius = 15
        addVaccenationView.layer.masksToBounds = true
        label6.isHidden = true
        addProductTFOutlet.text = ""
        addProductTFOutlet.resignFirstResponder()
        addVaccenationButtonOutlet.isEnabled = false
        minusVaccenationButtonOutlet.isEnabled = false
        vaccenationPlusImage.image = UIImage(named: "plus")
        vaccenationMinusImage.image = UIImage(named: "minus")
        
    }
    
    @IBAction func addPropertyButtonAction(_ sender: Any) {
        
        guard addPropertyTFOutlet.text?.isEmpty == false else { return }
        if let text = addPropertyTFOutlet.text {
            //propertyName.append(text)
            propertyName.insert(text, at: 0)
            addPrope.append(ADDPrope(prope: text))
            let indexPath = IndexPath(row: propertyName.count - 1, section: 0)
            ddProoertyTableView.beginUpdates()
            ddProoertyTableView.insertRows(at: [indexPath], with: .automatic)
            ddProoertyTableView.endUpdates()
            addPropertyTFOutlet.text = ""
            
            self.ddProoertyTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            
            print(addPrope.toDictionary4())
            print(propertyName.toDictionary4())
            let cookieHeader2 = propertyName.toDictionary4().map { "\(String($0.0))" + ":" + "\($0.1)" }.joined(separator: ", ")
            print("{\(cookieHeader2)}")
            //owners = "{\(cookieHeader2)}"
            
            print(propertyName)
            
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted

            let jsonData = try? jsonEncoder.encode(propertyName.toDictionary4())
            ownData = jsonData
            
            if let jsonString = String(data: jsonData ?? Data(), encoding: .utf8) {
                print(jsonString)
                owners = jsonString
            }
            
        }
        
    }
    
    @IBAction func minusPropertyButtonAction(_ sender: Any) {
        
        addPropertyView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
        addPropertyView.layer.borderWidth = 1
        addPropertyView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
        addPropertyView.layer.cornerRadius = 15
        addPropertyView.layer.masksToBounds = true
        label7.isHidden = true
        addPropertyTFOutlet.text = ""
        addPropertyTFOutlet.resignFirstResponder()
        addPropertyButtonOutlet.isEnabled = false
        minusPropertyButtonOutlet.isEnabled = false
        propertyPlusImage.image = UIImage(named: "plus")
        propertyMinusImage.image = UIImage(named: "minus")
        
    }
    
    @IBAction func typeButtonAction(_ sender: Any) {
        let storyborad = UIStoryboard(name: "Profile", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "TypeAddedDetailsCardViewController") as! TypeAddedDetailsCardViewController
        VC.height = self.view.frame.height - 200
        VC.topCornerRadius = 8
        VC.presentDuration = 0.5
        VC.dismissDuration = 0.5
        VC.popupDelegate = self
        VC.returnBack = { [weak self] (value, selected) in
            guard let self = self else { return }
            self.typeTF.text = value
            self.catID = selected
        }
        self.present(VC, animated: true, completion: nil)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
//        guard animalNameTF.text?.isEmpty == false else {
//            ToastManager.shared.showError(message: "Please, Enter animal name", view: self.view)
//            return
//        }
//        
//        guard motherNameTF.text?.isEmpty == false else {
//            ToastManager.shared.showError(message: "Please, Enter mother name", view: self.view)
//            return
//        }
//        
//        guard fatherNameTF.text?.isEmpty == false else {
//            ToastManager.shared.showError(message: "Please, Enter father name", view: self.view)
//            return
//        }
//        
//        guard ageTF.text?.isEmpty == false else {
//            ToastManager.shared.showError(message: "Please, Enter the age", view: self.view)
//            return
//        }
        
        guard catID?.isEmpty == false else {
            ToastManager.shared.showError(message: "Please, Enter card type".localized, view: self.view)
            return
        }
        
//        guard orderName.isEmpty == false else {
//            ToastManager.shared.showError(message: "Please, Enter vaccination name", view: self.view)
//            return
//        }
//        
//        guard propertyName.isEmpty == false else {
//            ToastManager.shared.showError(message: "Please, Enter owner name", view: self.view)
//            return
//        }
        
        Task {
            
            do {
                
                animalNameTF.resignFirstResponder()
                typeTF.resignFirstResponder()
                fatherNameTF.resignFirstResponder()
                motherNameTF.resignFirstResponder()
                ageTF.resignFirstResponder()
                addProductTFOutlet.resignFirstResponder()
                addPropertyTFOutlet.resignFirstResponder()
                ownerNameTF.resignFirstResponder()
                docNumTF.resignFirstResponder()
                
                print(self.mainImmage)
                print(self.video)
                print(self.images)
                
                let getCatAndSub = try await viewModel.addedCardDetails(name: animalNameTF.text, mother_name: motherNameTF.text, father_name: fatherNameTF.text, age: ageTF.text, main_image: mainImmage, images: images, video: video, category_id: catID, notes: noteTF.text, status: "active", inoculations: orderName, owners: propertyName, docNum: docNumTF.text)
                print(getCatAndSub)
                
            }catch {
                // tell the user something went wrong, I hope
                debugPrint(error)
            }
            
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        for index in 0...orderName.count {
            
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = orderDetailTableView.cellForRow(at: indexPath) as? VaccinationNameTableViewCell {
                if textField == cell.vaccinationNameTFOutlet {
                    if cell.vaccinationNameTFOutlet.tag == index {
//                        if orderName.count > 0 {
//                            orderName[index] = cell.vaccinationNameTFOutlet.text ?? ""
//                        }
                        cell.select()
                    }
                    
                }
            }
        }
        
        for index in 0...propertyName.count {
            
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = ddProoertyTableView.cellForRow(at: indexPath) as? AddProoertyTableViewCell {
                if textField == cell.vaccinationNameTFOutlet {
                    if cell.vaccinationNameTFOutlet.tag == index {
//                        if propertyName.count > 0 {
//                            propertyName[index] = cell.vaccinationNameTFOutlet.text ?? ""
//                        }
                        cell.select()
                    }
                    
                }
            }
        }
        
        if textField == self.animalNameTF {
            animalNameView.backgroundColor = DesignSystem.Colors.SecondBackground.color
            animalNameView.layer.borderWidth = 1
            animalNameView.layer.borderColor = DesignSystem.Colors.PrimaryOrange.color.cgColor
            animalNameView.layer.cornerRadius = 15
            animalNameView.layer.masksToBounds = true
            label1.isHidden = false
            
        }else if textField == self.typeTF {
            typeView.backgroundColor = DesignSystem.Colors.SecondBackground.color
            typeView.layer.borderWidth = 1
            typeView.layer.borderColor = DesignSystem.Colors.PrimaryOrange.color.cgColor
            typeView.layer.cornerRadius = 15
            typeView.layer.masksToBounds = true
            label2.isHidden = false
        }else if textField == self.fatherNameTF {
            fatherNameView.backgroundColor = DesignSystem.Colors.SecondBackground.color
            fatherNameView.layer.borderWidth = 1
            fatherNameView.layer.borderColor = DesignSystem.Colors.PrimaryOrange.color.cgColor
            fatherNameView.layer.cornerRadius = 15
            fatherNameView.layer.masksToBounds = true
            label3.isHidden = false
        }else if textField == self.motherNameTF {
            motherNameView.backgroundColor = DesignSystem.Colors.SecondBackground.color
            motherNameView.layer.borderWidth = 1
            motherNameView.layer.borderColor = DesignSystem.Colors.PrimaryOrange.color.cgColor
            motherNameView.layer.cornerRadius = 15
            motherNameView.layer.masksToBounds = true
            label4.isHidden = false
        }else if textField == self.ageTF {
            ageView.backgroundColor = DesignSystem.Colors.SecondBackground.color
            ageView.layer.borderWidth = 1
            ageView.layer.borderColor = DesignSystem.Colors.PrimaryOrange.color.cgColor
            ageView.layer.cornerRadius = 15
            ageView.layer.masksToBounds = true
            label5.isHidden = false
        }else if textField == self.addProductTFOutlet {
            addVaccenationView.backgroundColor = DesignSystem.Colors.SecondBackground.color
            addVaccenationView.layer.borderWidth = 1
            addVaccenationView.layer.borderColor = DesignSystem.Colors.PrimaryOrange.color.cgColor
            addVaccenationView.layer.cornerRadius = 15
            addVaccenationView.layer.masksToBounds = true
            label6.isHidden = false
            addVaccenationButtonOutlet.isEnabled = true
            minusVaccenationButtonOutlet.isEnabled = true
            vaccenationPlusImage.image = UIImage(named: "Search results for Add - Flaticon-1")
            vaccenationMinusImage.image = UIImage(named: "Search results for Add - Flaticon-2")
        }else if textField == self.addPropertyTFOutlet {
            addPropertyView.backgroundColor = DesignSystem.Colors.SecondBackground.color
            addPropertyView.layer.borderWidth = 1
            addPropertyView.layer.borderColor = DesignSystem.Colors.PrimaryOrange.color.cgColor
            addPropertyView.layer.cornerRadius = 15
            addPropertyView.layer.masksToBounds = true
            label7.isHidden = false
            addPropertyButtonOutlet.isEnabled = true
            minusPropertyButtonOutlet.isEnabled = true
            propertyPlusImage.image = UIImage(named: "Search results for Add - Flaticon-1")
            propertyMinusImage.image = UIImage(named: "Search results for Add - Flaticon-2")
        }else if textField == self.ownerNameTF {
            ownerNameView.backgroundColor = DesignSystem.Colors.SecondBackground.color
            ownerNameView.layer.borderWidth = 1
            ownerNameView.layer.borderColor = DesignSystem.Colors.PrimaryOrange.color.cgColor
            ownerNameView.layer.cornerRadius = 15
            ownerNameView.layer.masksToBounds = true
            label8.isHidden = false
        }else if textField == self.docNumTF {
            docNumView.backgroundColor = DesignSystem.Colors.SecondBackground.color
            docNumView.layer.borderWidth = 1
            docNumView.layer.borderColor = DesignSystem.Colors.PrimaryOrange.color.cgColor
            docNumView.layer.cornerRadius = 15
            docNumView.layer.masksToBounds = true
            label9.isHidden = false
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        for index in 0...addVacce.count {
            
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = orderDetailTableView.cellForRow(at: indexPath) as? VaccinationNameTableViewCell {
                if textField == cell.vaccinationNameTFOutlet {
                    if cell.vaccinationNameTFOutlet.tag == index {
                        if orderName.count > 0 {
                            //orderName[index] = cell.vaccinationNameTFOutlet.text ?? ""
                            //addVacce[index] = cell.vaccinationNameTFOutlet.text ?? ""
                        }
                        //orderName[index] = cell.vaccinationNameTFOutlet.text ?? ""
                        cell.unSelect()
                    }
                }
            }
        }
        print(orderName)
        
        for index in 0...addPrope.count {
            
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = ddProoertyTableView.cellForRow(at: indexPath) as? AddProoertyTableViewCell {
                if textField == cell.vaccinationNameTFOutlet {
                    if cell.vaccinationNameTFOutlet.tag == index {
                        if propertyName.count > 0 {
                            //propertyName[index] = cell.vaccinationNameTFOutlet.text ?? ""
                            //addPrope[index] = cell.vaccinationNameTFOutlet.text
                        }
                        //propertyName[index] = cell.vaccinationNameTFOutlet.text ?? ""
                        cell.unSelect()
                    }
                }
            }
        }
        print(propertyName)
        
        
        if textField == self.animalNameTF {
            animalNameView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
            animalNameView.layer.borderWidth = 1
            animalNameView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
            animalNameView.layer.cornerRadius = 15
            animalNameView.layer.masksToBounds = true
            label1.isHidden = true
            
        }else if textField == self.typeTF {
            typeView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
            typeView.layer.borderWidth = 1
            typeView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
            typeView.layer.cornerRadius = 15
            typeView.layer.masksToBounds = true
            label2.isHidden = true
        }else if textField == self.fatherNameTF {
            fatherNameView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
            fatherNameView.layer.borderWidth = 1
            fatherNameView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
            fatherNameView.layer.cornerRadius = 15
            fatherNameView.layer.masksToBounds = true
            label3.isHidden = true
        }else if textField == self.motherNameTF {
            motherNameView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
            motherNameView.layer.borderWidth = 1
            motherNameView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
            motherNameView.layer.cornerRadius = 15
            motherNameView.layer.masksToBounds = true
            label4.isHidden = true
        }else if textField == self.ageTF {
            ageView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
            ageView.layer.borderWidth = 1
            ageView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
            ageView.layer.cornerRadius = 15
            ageView.layer.masksToBounds = true
            label5.isHidden = true
        }else if textField == self.addProductTFOutlet {
            addVaccenationView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
            addVaccenationView.layer.borderWidth = 1
            addVaccenationView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
            addVaccenationView.layer.cornerRadius = 15
            addVaccenationView.layer.masksToBounds = true
            label6.isHidden = true
            addVaccenationButtonOutlet.isEnabled = false
            minusVaccenationButtonOutlet.isEnabled = false
            vaccenationPlusImage.image = UIImage(named: "plus")
            vaccenationMinusImage.image = UIImage(named: "minus")
        }else if textField == self.addPropertyTFOutlet {
            addPropertyView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
            addPropertyView.layer.borderWidth = 1
            addPropertyView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
            addPropertyView.layer.cornerRadius = 15
            addPropertyView.layer.masksToBounds = true
            label7.isHidden = true
            addPropertyButtonOutlet.isEnabled = false
            minusPropertyButtonOutlet.isEnabled = false
            propertyPlusImage.image = UIImage(named: "plus")
            propertyMinusImage.image = UIImage(named: "minus")
        }else if textField == self.ownerNameTF {
            ownerNameView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
            ownerNameView.layer.borderWidth = 1
            ownerNameView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
            ownerNameView.layer.cornerRadius = 15
            ownerNameView.layer.masksToBounds = true
            label8.isHidden = true
        }else if textField == self.docNumTF {
            docNumView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
            docNumView.layer.borderWidth = 1
            docNumView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
            docNumView.layer.cornerRadius = 15
            docNumView.layer.masksToBounds = true
            label9.isHidden = true
        }
        
    }
    
}

extension AddCardsDetailsFromProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
        orderDetailTableView.layoutIfNeeded()
        ddProoertyTableView.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == orderDetailTableView {
            return addVacce.count
        }else {
            return addPrope.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == orderDetailTableView {
            guard let cell = orderDetailTableView.dequeueReusableCell(withIdentifier: "VaccinationNameTableViewCell", for: indexPath) as? VaccinationNameTableViewCell else { return UITableViewCell() }
            let item = addVacce[indexPath.row]
            cell.vaccinationNameTFOutlet.text = item.vacc //orderName[indexPath.row]
            cell.vaccinationNameTFOutlet.delegate = self
            cell.vaccinationNameTFOutlet.tag = indexPath.row
            
            cell.AddAction = { [weak self] in
                guard let self = self else { return }
                self.orderName[indexPath.row] = cell.vaccinationNameTFOutlet.text ?? ""
                //item.vacc = cell.vaccinationNameTFOutlet.text ?? ""
                if let index2 = self.addVacce.firstIndex(of: ADDVacce(vacc: item.vacc ?? "")) {
                    self.addVacce[index2].vacc = cell.vaccinationNameTFOutlet.text ?? ""
                    print("addVacce is : \(self.addVacce)")
                    
                }
                print("addVacce is : \(self.addVacce)")
                print("orderName is : \(self.orderName)")
            }
            
            cell.DeleteAction = { [weak self] in
                guard let self = self else { return }
                self.orderName.remove(at: indexPath.row)
                if let index2 = self.addVacce.firstIndex(of: ADDVacce(vacc: item.vacc ?? "")) {
                    self.addVacce.remove(at: index2)
                    print("addVacce is : \(self.addVacce)")
                    
                }
                self.orderDetailTableView.beginUpdates()
                self.orderDetailTableView.deleteRows(at: [indexPath], with: .automatic)
                self.orderDetailTableView.endUpdates()
                self.addProductTFOutlet.text = ""
                self.viewWillLayoutSubviews()
                self.orderDetailTableView.layoutIfNeeded()
                self.orderDetailTableView.reloadData()
                
//                if let index = self.orderName.firstIndex(where: {$0 == cell.vaccinationNameTFOutlet.text}) {
//                    self.orderName.remove(at: index)
//                    self.orderDetailTableView.beginUpdates()
//                    let indexPath = IndexPath(row: index, section: 0)
//                    self.orderDetailTableView.deleteRows(at: [indexPath], with: .fade)
//                    self.orderDetailTableView.endUpdates()
//                    self.orderDetailTableView.reloadData()
//                    
//                }
                
            }
            
            return cell
            
        }else {
            guard let cell = ddProoertyTableView.dequeueReusableCell(withIdentifier: "AddProoertyTableViewCell", for: indexPath) as? AddProoertyTableViewCell else { return UITableViewCell() }
            
            let item = addPrope[indexPath.row]
            cell.vaccinationNameTFOutlet.text = item.prope
            cell.vaccinationNameTFOutlet.delegate = self
            cell.vaccinationNameTFOutlet.tag = indexPath.row
            
            cell.AddAction = { [weak self] in
                guard let self = self else { return }
                self.propertyName[indexPath.row] = cell.vaccinationNameTFOutlet.text ?? ""
                //item.prope = cell.vaccinationNameTFOutlet.text ?? ""
                if let index2 = self.addPrope.firstIndex(of: ADDPrope(prope: item.prope ?? "")) {
                    self.addPrope[index2].prope = cell.vaccinationNameTFOutlet.text ?? ""
                    print("addPrope is : \(self.addPrope)")
                    
                }
                print("addPrope is : \(self.addPrope)")
                print("propertyName is : \(self.propertyName)")
            }
            
            cell.DeleteAction = { [weak self] in
                guard let self = self else { return }
                self.propertyName.remove(at: indexPath.row)
                if let index2 = self.addPrope.firstIndex(of: ADDPrope(prope: item.prope ?? "")) {
                    self.addPrope.remove(at: index2)
                    print("addPrope is : \(self.addPrope)")
                    
                }
                self.ddProoertyTableView.beginUpdates()
                self.ddProoertyTableView.deleteRows(at: [indexPath], with: .automatic)
                self.ddProoertyTableView.endUpdates()
                self.addPropertyTFOutlet.text = ""
                self.viewWillLayoutSubviews()
                self.ddProoertyTableView.layoutIfNeeded()
                self.ddProoertyTableView.reloadData()
            }
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if tableView == orderDetailTableView {
            orderName.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        }else {
            propertyName.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if tableView == orderDetailTableView {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete".localized) { [weak self] (action, view, completionHandler) in
                guard let self = self else { return }
                let item = self.addVacce[indexPath.row]
                self.orderName.remove(at: indexPath.row)
                if let index2 = self.addVacce.firstIndex(of: ADDVacce(vacc: item.vacc ?? "")) {
                    self.addVacce.remove(at: index2)
                    print("addVacce is : \(self.addVacce)")
                    
                }
                self.orderDetailTableView.beginUpdates()
                self.orderDetailTableView.deleteRows(at: [indexPath], with: .automatic)
                self.orderDetailTableView.endUpdates()
                self.viewWillLayoutSubviews()
                self.orderDetailTableView.layoutIfNeeded()
                completionHandler(true)
                
            }
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }else {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete".localized) { [weak self] (action, view, completionHandler) in
                guard let self = self else { return }
                let item = self.addPrope[indexPath.row]
                self.propertyName.remove(at: indexPath.row)
                if let index2 = self.addPrope.firstIndex(of: ADDPrope(prope: item.prope ?? "")) {
                    self.addPrope.remove(at: index2)
                    print("addPrope is : \(self.addPrope)")
                    
                }
                self.ddProoertyTableView.beginUpdates()
                self.ddProoertyTableView.deleteRows(at: [indexPath], with: .automatic)
                self.ddProoertyTableView.endUpdates()
                self.viewWillLayoutSubviews()
                self.ddProoertyTableView.layoutIfNeeded()
                completionHandler(true)
                
            }
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        
    }
    
}

extension Array {

    func toDictionary4() -> [String: Element] {
        self.enumerated().reduce(into: [String: Element]()) { $0[String($1.offset)] = $1.element }
    }
    
}
