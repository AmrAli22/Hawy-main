//
//  AddSaleAuctionFromHomeViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 09/09/2022.
//

import UIKit
import Combine
import Alamofire

class AddSaleAuctionFromHomeViewController: BaseViewViewController, BottomPopupDelegate {
    
    @IBOutlet weak var scrollViewOutlet: UIScrollView!
    @IBOutlet weak var containerViewInScrollViewOutlet: UIView!
    
    @IBOutlet weak var cardsTableView: UITableView!
    @IBOutlet weak var cardsTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var auctionAddressView: UIView!
    @IBOutlet weak var auctionAddressTF: UITextField!
    
    @IBOutlet weak var auctionDateView: UIView!
    @IBOutlet weak var auctionDateTF: UITextField!
    
    @IBOutlet weak var auctionTimeView: UIView!
    @IBOutlet weak var auctionTimeTF: UITextField!
    
    
    @IBOutlet weak var addInitailPriceView: UIView!
    @IBOutlet weak var addInitailPriceTF: UITextField!
    @IBOutlet weak var currencyLabell: UILabel!
    
    lazy var label1: PaddedLabel = {
        let label = PaddedLabel()
        label.text = "Auction address".localized
        label.backgroundColor = DesignSystem.Colors.SecondBackground.color
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    lazy var label2: PaddedLabel = {
        let label = PaddedLabel()
        label.text = "Auction date".localized
        label.backgroundColor = DesignSystem.Colors.SecondBackground.color
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    lazy var label3: PaddedLabel = {
        let label = PaddedLabel()
        label.text = "Auction time".localized
        label.backgroundColor = DesignSystem.Colors.SecondBackground.color
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var label4: PaddedLabel = {
        let label = PaddedLabel()
        label.text = "Init price".localized
        label.backgroundColor = DesignSystem.Colors.SecondBackground.color
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryTF: UITextField!
    
    
    //Uidate picker
    let datePicker = UIDatePicker()
    
    //Uitime picker
    let timePicker = UIDatePicker()
    
    var cardsString = ""
    var timeStamp = 0.0
    
    var subscriber = Set<AnyCancellable>()
    
    private var viewModel = ProfileViewModel()
    
    var cardData = [AddCardFromHomeToAuctionModel]()
    
    var catID = -1
    var catName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyLabell.text = HelperConstant.getCurrency() ?? ""
        
        cardsTableView.register(UINib(nibName: "AddSaleAuctionFromHomeCarddsTableViewCell", bundle: nil), forCellReuseIdentifier: "AddSaleAuctionFromHomeCarddsTableViewCell")
        
        cardsTableView.tableFooterView = UIView()
        cardsTableView.separatorStyle = .none
        
        cardsTableView.delegate = self
        cardsTableView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        auctionAddressTF.delegate = self
        auctionDateTF.delegate = self
        auctionTimeTF.delegate = self
        
        auctionAddressView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
        auctionAddressView.layer.borderWidth = 1
        auctionAddressView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
        auctionAddressView.layer.cornerRadius = 15
        auctionAddressView.layer.masksToBounds = true
        label1.isHidden = true
        
        auctionDateView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
        auctionDateView.layer.borderWidth = 1
        auctionDateView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
        auctionDateView.layer.cornerRadius = 15
        auctionDateView.layer.masksToBounds = true
        label2.isHidden = true
        
        auctionTimeView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
        auctionTimeView.layer.borderWidth = 1
        auctionTimeView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
        auctionTimeView.layer.cornerRadius = 15
        auctionTimeView.layer.masksToBounds = true
        label3.isHidden = true
        
        addInitailPriceView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
        addInitailPriceView.layer.borderWidth = 1
        addInitailPriceView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
        addInitailPriceView.layer.cornerRadius = 15
        addInitailPriceView.layer.masksToBounds = true
        label4.isHidden = true
        
        categoryView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
        categoryView.layer.borderWidth = 1
        categoryView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
        categoryView.layer.cornerRadius = 15
        categoryView.layer.masksToBounds = true
        
        view.addSubview(label1)
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.topAnchor.constraint(equalTo: auctionAddressView.topAnchor, constant: -10).isActive = true
        label1.leadingAnchor.constraint(equalTo: auctionAddressView.leadingAnchor, constant: 15).isActive = true
        
        view.addSubview(label2)
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.topAnchor.constraint(equalTo: auctionDateView.topAnchor, constant: -10).isActive = true
        label2.leadingAnchor.constraint(equalTo: auctionDateView.leadingAnchor, constant: 15).isActive = true
        
        view.addSubview(label3)
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.topAnchor.constraint(equalTo: auctionTimeView.topAnchor, constant: -10).isActive = true
        label3.leadingAnchor.constraint(equalTo: auctionTimeView.leadingAnchor, constant: 15).isActive = true
        
        view.addSubview(label4)
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.topAnchor.constraint(equalTo: addInitailPriceView.topAnchor, constant: -10).isActive = true
        label4.leadingAnchor.constraint(equalTo: addInitailPriceView.leadingAnchor, constant: 15).isActive = true
        
        datePicker.datePickerMode = .date
        auctionDateTF.inputView = datePicker
        
        self.auctionDateTF.setInputViewDatePicker(target: self, selector: #selector(datePickerFormatter))
        
        timePicker.datePickerMode = .time
        auctionTimeTF.inputView = timePicker
        
        self.auctionTimeTF.setInputViewTimePicker(target: self, selector: #selector(timePickerFormatter))
        
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
        getProfileData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.cardsTableView.reloadData()
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
        if let datePicker = self.auctionDateTF.inputView as? UIDatePicker {
            
            datePicker.minimumDate = Date()
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            //dateformatter.dateFormat = "MM-dd-yyyy"
            //yyyy-MM-dd
            dateformatter.dateFormat = "dd-MM-yyyy"
            self.auctionDateTF.text = dateformatter.string(from: datePicker.date)
            
        }
        self.auctionDateTF.resignFirstResponder()
    }
    
    @objc func timePickerFormatter(){
        
        if let timePicker = self.auctionTimeTF.inputView as? UIDatePicker {
            
            let dateFormatter = DateFormatter()
            //timePicker.minimumDate = Date()
            dateFormatter.dateFormat = "hh:mm a"
            print("\(timePicker.date)") // 10:30 PM
            timePicker.frame.size = CGSize(width: 0, height: 250)
            let dateSelect = dateFormatter.string(from: timePicker.date)
            self.auctionTimeTF.text = dateSelect // 22:30
            timeStamp = timePicker.date.timeIntervalSince1970
            
        }
        self.auctionTimeTF.resignFirstResponder()
    }
    
//    func getTimeIntervalForDate()->(min : Date, max : Date){
//        
//        let calendar = Calendar.current
//        var minDateComponent = calendar.dateComponents([.hour], from: Date())
//        minDateComponent.hour = 09 // Start time
//        
//        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "h:mma"
//        let minDate = calendar.date(from: minDateComponent)
//        print(" min date : \(formatter.string(from: minDate!))")
//        
//        var maxDateComponent = calendar.dateComponents([.hour], from: date)
//        maxDateComponent.hour = 17 //EndTime
//        
//        
//        
//        let maxDate = calendar.date(from: maxDateComponent)
//        print(" max date : \(formatter.string(from: maxDate!))")
//        
//        
//        
//        return (minDate!,maxDate!)
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
    
    @IBAction func chooseCategoryButtonTapped(_ sender: Any) {
        
        let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "ChooseCategoryForAuctionViewController") as! ChooseCategoryForAuctionViewController
        
        VC.height = self.view.frame.height - 200
        VC.topCornerRadius = 8
        VC.presentDuration = 0.5
        VC.dismissDuration = 0.5
        VC.popupDelegate = self
        VC.returnBack = { [weak self] (value, selected) in
            guard let self = self else { return }
            self.categoryTF.text = value
            self.catID = selected
        }
        
        self.present(VC, animated: true, completion: nil)
        
    }
    
    @IBAction func chooseCardsButtonAction(_ sender: Any) {
        
        if catID == -1 {
            
            ToastManager.shared.showError(message: "Please, select category first".localized, view: self.view)
            
        }else {
            
            let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
            let VC = storyborad.instantiateViewController(withIdentifier: "AddSaleAuctionCardFromHomeViewController") as? AddSaleAuctionCardFromHomeViewController
            VC?.backData = { [weak self] (data, id) in
                guard let self = self else { return }
                self.cardData = data
                print(id)
                print(data)
                print(self.cardData)
                self.viewWillLayoutSubviews()
                self.cardsTableView.reloadData()
            }
            VC?.catID = catID
            VC?.type = 0
            navigationController?.pushViewController(VC!, animated: false)
            
        }
        
    }
    
    func performRequest() { //url: String, parameters: [String:Any]
        
        let url = "https://hawy-kw.com/api/auctions/sales/store"
        
        //cardData.append(contentsOf: [AddCardFromHomeToAuctionModel(id: 9, price: "100", name:), AddCardFromHomeToAuctionModel(id: 8, price: "120")])
        
        let dicArray = cardData.map{$0.toDictionary()}
        if let data = try? JSONSerialization.data(withJSONObject: dicArray, options: .prettyPrinted){
            print(data)
            let str = String(bytes: data, encoding: .utf8)
            print(str) //Prints a string of "\n\n"
        }
        print(dicArray)
        
        let finalTimeStamp = timeStamp //- Double(HelperConstant.getOffst() ?? 0)
        
        print(timeStamp)
        let param: [String: Any] = [
            
            //"email": "",
            "name" : auctionAddressTF.text ?? "",
            "day": auctionDateTF.text ?? "",
            "open_price": addInitailPriceTF.text?.replacedArabicDigitsWithEnglish ?? "",
            "start_time": finalTimeStamp,
            "cards": dicArray
            
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
                        let forgetPasswordRequest = try decoder.decode(AddSaleAuctionModel.self, from: data)
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
                            
                            
                            
                            VC?.type = 0
                            VC?.startDate = forgetPasswordRequest.item?.startDate ?? 0
                            VC?.endDate = forgetPasswordRequest.item?.endDate ?? 0
                            VC?.total = forgetPasswordRequest.item?.subscribePrice ?? "0.0"
                            
                            self.navigationController?.pushViewController(VC!, animated: true)
                            
                        }else{
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
    
    @IBAction func publishButtonAction(_ sender: Any) {
        
        guard auctionAddressTF.text?.isEmpty == false else {
            ToastManager.shared.showError(message: "Please, Enter your auction name".localized, view: self.view)
            return
        }
        
        guard auctionDateTF.text?.isEmpty == false else {
            ToastManager.shared.showError(message: "Please, Enter your auction date".localized, view: self.view)
            return
        }
        
        guard auctionTimeTF.text?.isEmpty == false else {
            ToastManager.shared.showError(message: "Please, Enter your auction time".localized, view: self.view)
            return
        }
        
        guard addInitailPriceTF.text?.isEmpty == false else {
            ToastManager.shared.showError(message: "Please, Enter your initial price".localized, view: self.view)
            return
        }
        
        guard cardData.isEmpty == false else {
            ToastManager.shared.showError(message: "Please, select your cards".localized, view: self.view)
            return
        }
        
        performRequest()
        
    }
    
}

extension AddSaleAuctionFromHomeViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.auctionAddressTF {
            auctionAddressView.backgroundColor = DesignSystem.Colors.SecondBackground.color
            auctionAddressView.layer.borderWidth = 1
            auctionAddressView.layer.borderColor = DesignSystem.Colors.PrimaryOrange.color.cgColor
            auctionAddressView.layer.cornerRadius = 15
            auctionAddressView.layer.masksToBounds = true
            label1.isHidden = false
            
        }else if textField == self.auctionDateTF {
            auctionDateView.backgroundColor = DesignSystem.Colors.SecondBackground.color
            auctionDateView.layer.borderWidth = 1
            auctionDateView.layer.borderColor = DesignSystem.Colors.PrimaryOrange.color.cgColor
            auctionDateView.layer.cornerRadius = 15
            auctionDateView.layer.masksToBounds = true
            label2.isHidden = false
        }else if textField == self.auctionTimeTF  {
            auctionTimeView.backgroundColor = DesignSystem.Colors.SecondBackground.color
            auctionTimeView.layer.borderWidth = 1
            auctionTimeView.layer.borderColor = DesignSystem.Colors.PrimaryOrange.color.cgColor
            auctionTimeView.layer.cornerRadius = 15
            auctionTimeView.layer.masksToBounds = true
            label3.isHidden = false
        }else {
            addInitailPriceView.backgroundColor = DesignSystem.Colors.SecondBackground.color
            addInitailPriceView.layer.borderWidth = 1
            addInitailPriceView.layer.borderColor = DesignSystem.Colors.PrimaryOrange.color.cgColor
            addInitailPriceView.layer.cornerRadius = 15
            addInitailPriceView.layer.masksToBounds = true
            label4.isHidden = false
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
            
        }else if textField == self.auctionDateTF {
            auctionDateView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
            auctionDateView.layer.borderWidth = 1
            auctionDateView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
            auctionDateView.layer.cornerRadius = 15
            auctionDateView.layer.masksToBounds = true
            label2.isHidden = true
        }else if textField == self.auctionTimeTF {
            auctionTimeView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
            auctionTimeView.layer.borderWidth = 1
            auctionTimeView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
            auctionTimeView.layer.cornerRadius = 15
            auctionTimeView.layer.masksToBounds = true
            label3.isHidden = true
        }else{
            addInitailPriceView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
            addInitailPriceView.layer.borderWidth = 1
            addInitailPriceView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
            addInitailPriceView.layer.cornerRadius = 15
            addInitailPriceView.layer.masksToBounds = true
            label4.isHidden = true
        }
        
    }
    
}

extension AddSaleAuctionFromHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
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

//var selectedDate2 = "" //Date()
//var selectedDate = Date()
//
//class AddSaleAuctionFromHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
//
//    @IBOutlet weak var monthLabel: UILabel!
//    @IBOutlet weak var collectionView: UICollectionView!
//
//    var totalSquares2 = [Date]()
//    var totalSquares = [CalendarDay]()
//    var current = ""
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setCellsView()
//        setWeekView()
//        setMonthView()
//        handleTodayDateAndCurrentTime()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        setWeekView()
//        setMonthView()
//    }
//
//    func handleTodayDateAndCurrentTime() {
//        let date = Date()
//        let df = DateFormatter()
//        df.dateFormat = "dd" //"yyyy-MM-dd HH:mm:ss"
//        let dateString = df.string(from: date)
//        current = dateString.replacedArabicDigitsWithEnglish
//
//    }
//
//    func setCellsView() {
//        let width = (collectionView.frame.size.width - 2) / 8
//        let height = (collectionView.frame.size.height - 2) / 8
//
//        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        flowLayout.itemSize = CGSize(width: width, height: height)
//    }
//
//    func setWeekView() {
//        totalSquares.removeAll()
//
//        var current = CalendarHelper().sundayForDate(date: selectedDate)
//        let nextSunday = CalendarHelper().addDays(date: current, days: 7)
//
//        while (current < nextSunday) {
//            totalSquares2.append(current)
//            current = CalendarHelper().addDays(date: current, days: 1)
//        }
//
//        monthLabel.text = CalendarHelper().monthString(date: selectedDate)
//        + " " + CalendarHelper().yearString(date: selectedDate)
//        collectionView.reloadData()
//    }
//
//    func setMonthView() {
//        totalSquares.removeAll()
//
//        let daysInMonth = CalendarHelper().daysInMonth(date: selectedDate)
//        let firstDayOfMonth = CalendarHelper().firstOfMonth(date: selectedDate)
//        let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)
//
//        let prevMonth = CalendarHelper().minusMonth(date: selectedDate)
//        let daysInPrevMonth = CalendarHelper().daysInMonth(date: prevMonth)
//
//        var count: Int = 1
//
//        while(count <= 42) {
//            let calendarDay = CalendarDay()
//            if count <= startingSpaces {
//                let prevMonthDay = daysInPrevMonth - startingSpaces + count
//                calendarDay.day = String(prevMonthDay)
//                calendarDay.month = CalendarDay.Month.previous
//            }else if count - startingSpaces > daysInMonth {
//                calendarDay.day = String(count - daysInMonth - startingSpaces)
//                calendarDay.month = CalendarDay.Month.next
//            }else {
//                calendarDay.day = String(count - startingSpaces)
//                calendarDay.month = CalendarDay.Month.current
//            }
//            totalSquares.append(calendarDay)
//            count += 1
//        }
//
//        monthLabel.text = CalendarHelper().monthString(date: selectedDate)
//        + " " + CalendarHelper().yearString(date: selectedDate)
//        collectionView.reloadData()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        totalSquares.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
//
//        let calendarDay = totalSquares[indexPath.item]
//
//        cell.dayOfMonth.text = calendarDay.day
//
//        if(calendarDay.month == CalendarDay.Month.current) {
//            cell.dayOfMonth.textColor = UIColor.black
//
//            if(cell.dayOfMonth.text == current) {
//                cell.dayOfMonth.backgroundColor = DesignSystem.Colors.PrimaryBlue.color
//            }else {
//                cell.dayOfMonth.backgroundColor = UIColor.white
//            }
//
//        }else {
//            cell.dayOfMonth.textColor = UIColor.gray
//
//            if(cell.dayOfMonth.text == current) {
//                cell.dayOfMonth.backgroundColor = UIColor.white
//            }else {
//                cell.dayOfMonth.backgroundColor = UIColor.white
//            }
//        }
//
//        return cell
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        let calendarDay = totalSquares[indexPath.item]
//        if(calendarDay.month == CalendarDay.Month.current) {
//
//            current = calendarDay.day
//            print("selectedDate = \(current)")
//            collectionView.reloadData()
//
//        } else {
//            print("not current month")
//        }
//
//    }
//
//    @IBAction func previousWeek(_ sender: Any) {
//        //selectedDate = CalendarHelper().addDays(date: selectedDate, days: -7)
//        //setWeekView()
//        selectedDate = CalendarHelper().minusMonth(date: selectedDate)
//        setMonthView()
//        collectionView.reloadData()
//    }
//
//    @IBAction func nextWeek(_ sender: Any) {
//        //selectedDate = CalendarHelper().addDays(date: selectedDate, days: 7)
//        //setWeekView()
//        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
//        setMonthView()
//        collectionView.reloadData()
//    }
//
//    override open var shouldAutorotate: Bool {
//        return false
//    }
//
//
//}
