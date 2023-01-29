//
//  AddAdsFromProfileViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 05/10/2022.
//

import UIKit
import Combine
import Alamofire

class AddAdsFromProfileViewController: BaseViewViewController {
    
    @IBOutlet weak var scrollViewOutlet: UIScrollView!
    @IBOutlet weak var containerViewInScrollViewOutlet: UIView!
    
    @IBOutlet weak var cardsTableView: UITableView!
    @IBOutlet weak var cardsTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var auctionAddressView: UIView!
    @IBOutlet weak var auctionAddressTF: UITextField!
    
    @IBOutlet weak var auctionContentView: UIView!
    @IBOutlet weak var auctionContentTF: UITextField!
    
    //@IBOutlet weak var auctionTimeView: UIView!
    //@IBOutlet weak var auctionTimeTF: UITextField!
    
    lazy var label1: PaddedLabel = {
        let label = PaddedLabel()
        label.text = "Ad address".localized
        label.backgroundColor = DesignSystem.Colors.SecondBackground.color
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    lazy var label2: PaddedLabel = {
        let label = PaddedLabel()
        label.text = "Ad content".localized
        label.backgroundColor = DesignSystem.Colors.SecondBackground.color
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
//    lazy var label3: PaddedLabel = {
//        let label = PaddedLabel()
//        label.text = "Auction time"
//        label.backgroundColor = DesignSystem.Colors.SecondBackground.color
//        label.textColor = UIColor.lightGray
//        label.textAlignment = .center
//        return label
//    }()
    
    //Uidate picker
    let datePicker = UIDatePicker()
    
    //Uitime picker
    let timePicker = UIDatePicker()
    
    var cardsString = ""
    var timeStamp = 0.0
    
    var subscriber = Set<AnyCancellable>()
    
    private var viewModel = ProfileViewModel()
    
    var cardData = [AddCardFromHomeToAuctionModel]()
    //var backData: ((Int) -> Void)?
    var catId: Int?
    var cardName: String?
    var cardImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardsTableView.register(UINib(nibName: "AddSaleAuctionFromHomeCarddsTableViewCell", bundle: nil), forCellReuseIdentifier: "AddSaleAuctionFromHomeCarddsTableViewCell")
        
        cardsTableView.tableFooterView = UIView()
        cardsTableView.separatorStyle = .none
        
        cardsTableView.delegate = self
        cardsTableView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        auctionAddressTF.delegate = self
        auctionContentTF.delegate = self
        //auctionTimeTF.delegate = self
        
        auctionAddressView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
        auctionAddressView.layer.borderWidth = 1
        auctionAddressView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
        auctionAddressView.layer.cornerRadius = 15
        auctionAddressView.layer.masksToBounds = true
        label1.isHidden = true
        
        auctionContentView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
        auctionContentView.layer.borderWidth = 1
        auctionContentView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
        auctionContentView.layer.cornerRadius = 15
        auctionContentView.layer.masksToBounds = true
        label2.isHidden = true
        
//        auctionTimeView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
//        auctionTimeView.layer.borderWidth = 1
//        auctionTimeView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
//        auctionTimeView.layer.cornerRadius = 15
//        auctionTimeView.layer.masksToBounds = true
//        label3.isHidden = true
        
        view.addSubview(label1)
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.topAnchor.constraint(equalTo: auctionAddressView.topAnchor, constant: -10).isActive = true
        label1.leadingAnchor.constraint(equalTo: auctionAddressView.leadingAnchor, constant: 15).isActive = true
        
        view.addSubview(label2)
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.topAnchor.constraint(equalTo: auctionContentView.topAnchor, constant: -10).isActive = true
        label2.leadingAnchor.constraint(equalTo: auctionContentView.leadingAnchor, constant: 15).isActive = true
        
//        view.addSubview(label3)
//        label3.translatesAutoresizingMaskIntoConstraints = false
//        label3.topAnchor.constraint(equalTo: auctionTimeView.topAnchor, constant: -10).isActive = true
//        label3.leftAnchor.constraint(equalTo: auctionTimeView.leftAnchor, constant: 15).isActive = true
        
        datePicker.datePickerMode = .date
        //auctionDateTF.inputView = datePicker
        
        //self.auctionDateTF.setInputViewDatePicker(target: self, selector: #selector(datePickerFormatter))
        
        timePicker.datePickerMode = .time
//        auctionTimeTF.inputView = timePicker
//
//        self.auctionTimeTF.setInputViewTimePicker(target: self, selector: #selector(timePickerFormatter))
        
        //        Task {
        //            do {
        //                let myCards = try await viewModel.profileMyCards(type: "profile")
        //                print(myCards)
        //            }catch {
        //                // tell the user something went wrong, I hope
        //                debugPrint(error)
        //            }
        //        }
        
        sinkToLoading()
        sinkToProfileMyAuctionsModelPublisher()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.cardsTableView.reloadData()
        getProfileData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            
            self.scrollViewOutlet.roundCorners([.topLeft, .topRight], radius: 20)
            self.containerViewInScrollViewOutlet.roundCorners([.topLeft, .topRight], radius: 20)
            
            self.cardsTableViewHeight.constant = self.cardsTableView.contentSize.height
            
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        
        DispatchQueue.main.async {
            
            self.cardsTableViewHeight.constant = self.cardsTableView.contentSize.height
            
        }
    }
    
    @objc func datePickerFormatter() {
        if let datePicker = self.auctionContentTF.inputView as? UIDatePicker {
            
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            //dateformatter.dateFormat = "MM-dd-yyyy"
            //yyyy-MM-dd
            dateformatter.dateFormat = "dd-MM-yyyy"
            self.auctionContentTF.text = dateformatter.string(from: datePicker.date)
            
        }
        self.auctionContentTF.resignFirstResponder()
    }
    
//    @objc func timePickerFormatter(){
//
//        if let timePicker = self.auctionTimeTF.inputView as? UIDatePicker {
//
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "hh:mm a"
//            print("\(timePicker.date)") // 10:30 PM
//            let dateSelect = dateFormatter.string(from: timePicker.date)
//            self.auctionTimeTF.text = dateSelect // 22:30
//            timeStamp = timePicker.date.timeIntervalSince1970 / 1000
//
//        }
//        self.auctionTimeTF.resignFirstResponder()
//    }
    
    @objc
    func dismissKeyboard() {
        self.view.endEditing(true)
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
    
    func sinkToProfileMyAuctionsModelPublisher() {
        viewModel.profileMyCardsModelPublisher.sink { [weak self] (result) in
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
                //self.cardData = result?.item ?? []
            }
        }.store(in: &subscriber)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chooseCardsButtonAction(_ sender: Any) {
        
        let storyborad = UIStoryboard(name: "HawyTabbar", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "AddCardAdFromProfileViewController") as? AddCardAdFromProfileViewController
        VC?.backData = { [weak self] (data, cardID, cardNAme, cardIMage) in
            guard let self = self else { return }
            self.cardData = data
            self.catId = cardID
            self.cardName = cardNAme
            self.cardImage = cardIMage
            //self.cardData.removeAll()
            self.cardData.append(AddCardFromHomeToAuctionModel(name: self.cardName, price: "", id: self.catId, image: self.cardImage))
            print(data)
            print(self.cardData)
            print(self.catId)
            print(self.cardName)
            print(self.cardImage)
            self.viewWillLayoutSubviews()
            self.cardsTableView.reloadData()
        }
        VC?.titleLabel = "Add ads".localized
        navigationController?.pushViewController(VC!, animated: false)
        
    }
    
    func performRequest() { //url: String, parameters: [String:Any]
        
        let url = "https://hawy-kw.com/api/auth/profile/ads/store"
        
        //cardData.append(contentsOf: [AddCardFromHomeToAuctionModel(id: 9, price: "100", name:), AddCardFromHomeToAuctionModel(id: 8, price: "120")])
        
//        let dicArray = cardData.map{$0.toDictionary()}
//        if let data = try? JSONSerialization.data(withJSONObject: dicArray, options: .prettyPrinted){
//            print(data)
//            let str = String(bytes: data, encoding: .utf8)
//            print(str) //Prints a string of "\n\n"
//        }
//        print(dicArray)
        
        
//        print(timeStamp)
        print(catId)
        let param: [String: Any] = [
            
            //"email": "",
            "name" : auctionAddressTF.text ?? "",
            "description": auctionContentTF.text ?? "",
            "card_id": catId ?? 0
            
        ]
        print(param)
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        print(headers)
        
        showIndecator()
        //AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers) // //URLEncoding.httpBody
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            
            print(response)
            //.responseJSON { response in
                
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
                        let forgetPasswordRequest = try decoder.decode(AddAdsModel.self, from: data)
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
//                            let story = UIStoryboard(name: "HawyTabbar", bundle:nil)
//                            let vc = story.instantiateViewController(withIdentifier: "HawyTabbarController") as! HawyTabbarController
//                            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
//                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                            
                            let stroyboard = UIStoryboard(name: "Subscriptions", bundle: nil)
                            let VC = stroyboard.instantiateViewController(withIdentifier: "AuctionAdsPAymentViewController") as? AuctionAdsPAymentViewController
                            
                            VC?.type = 3
                            VC?.startdateAd = forgetPasswordRequest.item?.srartDate ?? ""
                            VC?.enddateAd = forgetPasswordRequest.item?.endDate ?? ""
                            VC?.adPrice = forgetPasswordRequest.item?.price ?? 0.0
                            
                            self.navigationController?.pushViewController(VC!, animated: true)
                            
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
    
    @IBAction func publishButtonAction(_ sender: Any) {
        
        guard catId != nil else {
            ToastManager.shared.showError(message: "Please, Add card for ad".localized, view: self.view)
            return
            
        }
        guard auctionAddressTF.text?.isEmpty == false else {
            
            ToastManager.shared.showError(message: "Please, type title".localized, view: self.view)
            return
            
        }
        guard auctionContentTF.text?.isEmpty == false else {
            
            ToastManager.shared.showError(message: "Please, type ad content".localized, view: self.view)
            return
            
        }
        performRequest()
        
    }
    
}

extension AddAdsFromProfileViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.auctionAddressTF {
            auctionAddressView.backgroundColor = DesignSystem.Colors.SecondBackground.color
            auctionAddressView.layer.borderWidth = 1
            auctionAddressView.layer.borderColor = DesignSystem.Colors.PrimaryOrange.color.cgColor
            auctionAddressView.layer.cornerRadius = 15
            auctionAddressView.layer.masksToBounds = true
            label1.isHidden = false
            
        }else if textField == self.auctionContentTF {
            auctionContentView.backgroundColor = DesignSystem.Colors.SecondBackground.color
            auctionContentView.layer.borderWidth = 1
            auctionContentView.layer.borderColor = DesignSystem.Colors.PrimaryOrange.color.cgColor
            auctionContentView.layer.cornerRadius = 15
            auctionContentView.layer.masksToBounds = true
            label2.isHidden = false
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == self.auctionAddressTF {
            auctionAddressView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
            auctionAddressView.layer.borderWidth = 1
            auctionAddressView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
            auctionAddressView.layer.cornerRadius = 15
            auctionAddressView.layer.masksToBounds = true
            label1.isHidden = true
            
        }else if textField == self.auctionContentTF {
            auctionContentView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
            auctionContentView.layer.borderWidth = 1
            auctionContentView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
            auctionContentView.layer.cornerRadius = 15
            auctionContentView.layer.masksToBounds = true
            label2.isHidden = true
        }
        
    }
    
}

extension AddAdsFromProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
        cardsTableView.layoutIfNeeded()
        
        DispatchQueue.main.async {
            let firstAnimation = AnimationFactory.makeSlideIn(duration: 0.5, delayFactor: 0.05)
            let secondAnimation = AnimationFactory.makeFade(duration: 0.5, delayFactor: 0.05)
            let thirdAnimation = AnimationFactory.makeMoveUpWithBounce(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
            let fourthAnimation = AnimationFactory.makeMoveUpWithFade(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
            //
            let animator = Animator(animation: firstAnimation)
            animator.animate(cell: cell, at: indexPath, in: tableView)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cardData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = cardsTableView.dequeueReusableCell(withIdentifier: "AddSaleAuctionFromHomeCarddsTableViewCell", for: indexPath) as? AddSaleAuctionFromHomeCarddsTableViewCell else { return UITableViewCell() }
        
        let item = cardData[indexPath.row]
        
        cell.titleLabel.text = item.name
        cell.priceLabel.text = ""
        cell.cardImage.loadImage(URLS.baseImageURL+(item.image ?? ""))
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        cardData.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete".localized) { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            let item = self.cardData[indexPath.row]
            self.cardData.remove(at: indexPath.row)
            if let index2 = self.cardData.firstIndex(of: AddCardFromHomeToAuctionModel(name: item.name, price: item.price, id: item.id, image: item.image)) {
                self.cardData.remove(at: index2)
                print("cardData is : \(self.cardData)")
                
            }
            self.cardsTableView.beginUpdates()
            self.cardsTableView.deleteRows(at: [indexPath], with: .automatic)
            self.cardsTableView.endUpdates()
            self.viewWillLayoutSubviews()
            self.cardsTableView.layoutIfNeeded()
            completionHandler(true)
            
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
        
    }
    
}
