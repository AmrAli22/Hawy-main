//
//  PublishLiveAuctionViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 14/10/2022.
//

import UIKit
import Combine
import Alamofire
import FSCalendar

class PublishLiveAuctionViewController: BaseViewViewController, BottomPopupDelegate {
    
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
    @IBOutlet weak var containerViewOfOptions: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var modallelView: UIView!
    
    @IBOutlet weak var auctionInitialPriceView: UIView!
    @IBOutlet weak var initialPriceTF: UITextField!
    
    @IBOutlet weak var timesCollectionView: UICollectionView!
    @IBOutlet weak var spoiltAdminImage: UIImageView!
    @IBOutlet weak var spoiltMeImage: UIImageView!
    @IBOutlet weak var currencyLabell: UILabel!
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryTF: UITextField!
    
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
    
    @IBOutlet weak var calender: UIView!
//    var calendar: FSCalendar!
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    var catID = -1
    var catName = ""
    
    //Uidate picker
    let datePicker = UIDatePicker()
    
    //Uitime picker
    let timePicker = UIDatePicker()
    
    var cardsString = ""
    var timeStamp : Int64 = 0
    
    var subscriber = Set<AnyCancellable>()
    
    private var viewModel = ProfileViewModel()
    
    var cardData = [AddCardFromHomeToAuctionModel]()
    
    var timesData = [LiveAuctionDateCheckModelItem]()
    
    var liveCardId: Int?
    
    var index = -1
    
    var timeId: Int?
    
    var adminAndMe = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyLabell.text = HelperConstant.getCurrency() ?? ""
        
        cardsTableView.register(UINib(nibName: "AddSaleAuctionFromHomeCarddsTableViewCell", bundle: nil), forCellReuseIdentifier: "AddSaleAuctionFromHomeCarddsTableViewCell")
        
        cardsTableView.tableFooterView = UIView()
        cardsTableView.separatorStyle = .none
        
        cardsTableView.delegate = self
        cardsTableView.dataSource = self
        
        timesCollectionView.delegate = self
        timesCollectionView.dataSource = self
        
        self.view.bringSubviewToFront(self.containerViewOfOptions)
        self.view.bringSubviewToFront(self.timeView)
        self.view.bringSubviewToFront(self.modallelView)
        
        timeView.isHidden = true
        containerViewOfOptions.isHidden = true
        modallelView.isHidden = false
        
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
        
        auctionInitialPriceView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
        auctionInitialPriceView.layer.borderWidth = 1
        auctionInitialPriceView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
        auctionInitialPriceView.layer.cornerRadius = 15
        auctionInitialPriceView.layer.masksToBounds = true
        
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
        
//        calendar = FSCalendar(frame: CGRect(x: 0.0, y: 10, width: calender.frame.size.width, height: 250))
//        calender.addSubview(calendar)
//        calendar.scrollDirection = .vertical
//        calendar.locale = Locale(identifier: AppLocalization.currentAppleLanguage())
//        calendar.scope = .month
//
//        calendar.appearance.todayColor = DesignSystem.Colors.PrimaryBlue.color
//        calendar.appearance.titleTodayColor = .white
//        calendar.appearance.titleDefaultColor = DesignSystem.Colors.PrimaryBlue.color
//        calendar.appearance.headerTitleColor = .black
//        calendar.appearance.weekdayTextColor = .black
//        calendar.delegate = self
//        calendar.dataSource = self
//        calendar.allowsSelection = true
        
        //datePicker.datePickerMode = .date
        //auctionDateTF.inputView = datePicker
        
        //self.auctionDateTF.setInputViewDatePicker(target: self, selector: #selector(datePickerFormatter))
        
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
        if #available(iOS 14.0, *) {
            setupDatePickerView()
        } else {
            // Fallback on earlier versions
        }
        sinkToLoading()
        sinkToProfileMyAuctionsModelPublisher()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.cardsTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {


            self.scrollViewOutlet.roundCornersWithMask([.topLeading, .topTrailing], radius: 20)
            //self.containerViewInScrollViewOutlet.roundCornersWithMask([.topLeading, .topTrailing], radius: 20)
            //self.timeView.roundCornersWithMask([.topLeading, .topTrailing], radius: 20)
            self.modallelView.roundCornersWithMask([.topLeading, .topTrailing], radius: 20)

            //self.cardsTableViewHeight.constant = self.cardsTableView.contentSize.height

        }
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        
        DispatchQueue.main.async {
            
            self.cardsTableViewHeight.constant = self.cardsTableView.contentSize.height
            
        }
        
    }
    
    var datePickerView = UIDatePicker()
    var selectedDate = Date()
    
    // date picker
    @available(iOS 14.0, *)
    private func setupDatePickerView() {
        datePickerView.datePickerMode = .date
        datePickerView.preferredDatePickerStyle = .inline
        datePickerView.minimumDate = Date()
        datePickerView.tintColor = DesignSystem.Colors.PrimaryBlue.color
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = DesignSystem.Colors.PrimaryBlue.color
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "confirm".localized, style: .done, target: self, action: #selector(dateDoneTapped))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        
        timeStamp = Int64(datePickerView.date.addingTimeInterval(7200).timeIntervalSince1970)
        print(timeStamp)
        
        auctionDateTF.inputView = datePickerView
        auctionDateTF.inputAccessoryView = toolBar
        //auctionDateTF.tintColor = UIColor.clear
    }
    
    @objc private func dateDoneTapped() {
        
        //text = datePickerView.date.dateToString
        
        print(timeStamp)
        performDateCheck(date: timeStamp, type: adminAndMe)
        
    }
    
    @objc func datePickerFormatter() {
        if let datePicker = self.auctionDateTF.inputView as? UIDatePicker {
            
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            //dateformatter.dateFormat = "MM-dd-yyyy"
            //yyyy-MM-dd
            dateformatter.dateFormat = "dd-MM-yyyy"
            
//            let date = Date()
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "MM-dd-yyyy"
//            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//            dateFormatter.timeZone = TimeZone(abbreviation: "CAT")
        //    print(dateFormatter.string(from: date))
            
            
            
            self.auctionDateTF.text = dateFormatter.string(from: datePicker.date)
            
        }
        self.auctionDateTF.resignFirstResponder()
    }
    
    @objc func timePickerFormatter(){
        
        if let timePicker = self.auctionTimeTF.inputView as? UIDatePicker {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            print("\(timePicker.date)") // 10:30 PM
            timePicker.frame.size = CGSize(width: 0, height: 250)
            let dateSelect = dateFormatter.string(from: timePicker.date)
            self.auctionTimeTF.text = dateSelect // 22:30
            //timeStamp = timePicker.date.timeIntervalSince1970
            
        }
        self.auctionTimeTF.resignFirstResponder()
    }
    
    @objc
    func dismissKeyboard() {
        self.view.endEditing(true)
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
    
    @IBAction func hideViewButtonTapped(_ sender: Any) {
        //scrollViewOutlet.isHidden = false
        timeView.isHidden = true
        containerViewOfOptions.isHidden = true
        modallelView.isHidden = false
    }
    
    @IBAction func showViewButtonTapped(_ sender: Any) {
//        //self.performTimes(times: self.auctionDateTF.text ?? "")
//        //scrollViewOutlet.isHidden = true
//        timeView.isHidden = false
//        containerViewOfOptions.isHidden = false
//        modallelView.isHidden = false
        
        if adminAndMe == "" {
            
            
            
        }else {
            
            let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
            let VC = storyborad.instantiateViewController(withIdentifier: "LiveAuctionTmesViewController") as? LiveAuctionTmesViewController
            
            VC?.timeDate = timeStamp //self.auctionDateTF.text
            
            VC?.modalPresentationStyle = .overCurrentContext
            VC?.modalTransitionStyle = .crossDissolve
            
            VC?.backData = { dateId, dateFromTo in
                
                print(dateId)
                print(dateFromTo)
                
                self.auctionTimeTF.text = dateFromTo
                self.timeId = dateId
                
            }
            VC?.spoiling = adminAndMe
            
            present(VC!, animated: true, completion: nil)
            
        }
        
        
        
    }
    
    @IBAction func hideModallelButtonTapped(_ sender: Any) {
        //scrollViewOutlet.isHidden = false
        timeView.isHidden = true
        containerViewOfOptions.isHidden = true
        modallelView.isHidden = true
    }
    
    @IBAction func showModallelButtonTapped(_ sender: Any) {
        //scrollViewOutlet.isHidden = true
        timeView.isHidden = true
        containerViewOfOptions.isHidden = true
        modallelView.isHidden = true
        
        let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "SpoilingViewController") as? SpoilingViewController
        
        
        VC?.modalPresentationStyle = .overCurrentContext
        VC?.modalTransitionStyle = .crossDissolve
        
        VC?.backdata = { spoiling in
            self.adminAndMe = spoiling
        }
        
        present(VC!, animated: true, completion: nil)
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func spoiltAdminButtonTapped(_ sender: Any) {
        
        spoiltAdminImage.image = UIImage(named: "TOGGLE-1")
        spoiltMeImage.image = UIImage(named: "TOGGLE")
        
        adminAndMe = "admin"
        
    }
    
    @IBAction func spoiltmeButtonTapped(_ sender: Any) {
        
        spoiltAdminImage.image = UIImage(named: "TOGGLE")
        spoiltMeImage.image = UIImage(named: "TOGGLE-1")
        
        adminAndMe = "me"
        
    }
    
    @IBAction func chooseSpoiltButtonTapped(_ sender: Any) {
        
        timeView.isHidden = true
        containerViewOfOptions.isHidden = true
        modallelView.isHidden = true
        
    }
    
    @IBAction func chooseCategoryButtonTapped(_ sender: Any) {
        
        let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "ChooseCategoryForAuctionViewController") as! ChooseCategoryForAuctionViewController
        VC.isBeforeAuc = true
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
            VC?.maxCards = 100
            VC?.live = true
            VC?.backData = { [weak self] (data, id) in
                guard let self = self else { return }
                self.cardData = data
                self.liveCardId = id
                print(self.liveCardId)
                print(data)
                print(self.cardData)
                self.viewWillLayoutSubviews()
                self.cardsTableView.reloadData()
            }
            VC?.catID = catID
            VC?.type = 1
            navigationController?.pushViewController(VC!, animated: false)
            
        }
        
    }
    
    func performRequest() { //url: String, parameters: [String:Any]
        
        let url = "https://hawy-kw.com/api/auctions/live/store"
        
        let dicArray = cardData.map{$0.toDictionary()}
        if let data = try? JSONSerialization.data(withJSONObject: dicArray, options: .prettyPrinted){
            print(data)
            let str = String(bytes: data, encoding: .utf8)
            print(str) //Prints a string of "\n\n"
        }
        print(dicArray)
        
        print(timeStamp)
        let param: [String: Any] = [
            
            "speaker": adminAndMe,
            "time_id": timeId ?? 0,
            "name" : auctionAddressTF.text ?? "",
            "open_price": initialPriceTF.text?.replacedArabicDigitsWithEnglish ?? "",
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
                        let forgetPasswordRequest = try decoder.decode(AddLiveAuctionModel.self, from: data)
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
                            
                            VC?.type = 1
                            VC?.startDate = forgetPasswordRequest.item?.startDate ?? 0
                            VC?.endDate = forgetPasswordRequest.item?.endDate ?? 0
                            VC?.total = forgetPasswordRequest.item?.subscribePrice ?? "0.0"
                            
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
    
    func performDateCheck(date: Int64?, type: String?) { //url: String, parameters: [String:Any]
        
        let url = "https://hawy-kw.com/api/auctions/live/check/date?date=\(date ?? 0)&type=\(type ?? "")"
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")"
        ]
        
        showIndecator()
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers) // //URLEncoding.httpBody
            .validate(statusCode: 200...500)
        
            .responseJSON { response in
                
                print(headers)
                print(response)
                print(response.result)
                
                switch response.result {
                    
                case .success(let JSON):
                    
                    print("Validation Successful with response JSON \(JSON)")
                    
                    guard let data = response.data else { return }
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        let forgetPasswordRequest = try decoder.decode(LiveAuctionDateCheckModel.self, from: data)
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
                            print(self.datePickerView.date.timeIntervalSince1970)
//                            if forgetPasswordRequest.item?.first?.available == true {
//
//                                let dateformatter = DateFormatter()
//                                dateformatter.dateStyle = .medium
//                                dateformatter.dateFormat = "yyyy-MM-dd"
//                                self.auctionDateTF.text = dateformatter.string(from: self.datePickerView.date)
//                                self.auctionDateTF.resignFirstResponder()
//                                print(self.datePickerView.date.timeIntervalSince1970)
//                                self.performTimes(times: self.auctionDateTF.text ?? "")
//
//                            }
                            
                            let dateformatter = DateFormatter()
                            dateformatter.dateStyle = .medium
                            dateformatter.dateFormat = "yyyy-MM-dd"
                            self.auctionDateTF.text = dateformatter.string(from: self.datePickerView.date)
                            self.auctionDateTF.resignFirstResponder()
                            print(self.datePickerView.date.timeIntervalSince1970)
                            self.performTimes(times: self.auctionDateTF.text ?? "", type: self.adminAndMe)
                            
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
    
    func performTimes(times: String?, type: String?) { //url: String, parameters: [String:Any]
        
        let url = "https://hawy-kw.com/api/auctions/live/time/list?date=\(times ?? "")&type=\(type ?? "")"
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")"
        ]
        
        showIndecator()
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers) // //URLEncoding.httpBody
            .validate(statusCode: 200...500)
        
            .responseJSON { response in
                
                print(headers)
                print(response)
                print(response.result)
                
                switch response.result {
                    
                case .success(let JSON):
                    
                    print("Validation Successful with response JSON \(JSON)")
                    
                    guard let data = response.data else { return }
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        let forgetPasswordRequest = try decoder.decode(LiveAuctionDateCheckModel.self, from: data)
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
                            
                            self.timesData = forgetPasswordRequest.item ?? []
                            self.timesCollectionView.reloadData()
                            
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

        guard cardData.isEmpty == false else {
            ToastManager.shared.showError(message: "Please, select your cards".localized, view: self.view)
            return
        }
        
        guard initialPriceTF.text?.isEmpty == false else {
            ToastManager.shared.showError(message: "Please, Enter initial price".localized, view: self.view)
            return
        }
        
        performRequest()
        
    }
    
    
    
    
}

extension PublishLiveAuctionViewController: UITextFieldDelegate {
    
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
        }else {
            auctionTimeView.backgroundColor = DesignSystem.Colors.SecondBackground.color
            auctionTimeView.layer.borderWidth = 1
            auctionTimeView.layer.borderColor = DesignSystem.Colors.PrimaryOrange.color.cgColor
            auctionTimeView.layer.cornerRadius = 15
            auctionTimeView.layer.masksToBounds = true
            label3.isHidden = false
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
        }
        
    }
    
}

extension PublishLiveAuctionViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        cell.priceLabel.text = "" //"\(item.price ?? "") K.D"
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

extension PublishLiveAuctionViewController: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = timesCollectionView.dequeueReusableCell(withReuseIdentifier: "LiveTimesCollectionViewCell", for: indexPath) as? LiveTimesCollectionViewCell else { return UICollectionViewCell() }
        
        let item = timesData[indexPath.row]
        
        if index == indexPath.row {
            if item.available == true {
                cell.containerView.backgroundColor = DesignSystem.Colors.PrimaryBlue.color
            }else {
                cell.containerView.backgroundColor = DesignSystem.Colors.PrimaryDarkRed.color
            }
        }else {
            cell.containerView.backgroundColor = .white
        }
        
        
        cell.timeLabelOutlet.text = "\(item.timeFrom ?? "") - \(item.timeTo ?? "")"
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //let item = timesData[indexPath.row]
        print(indexPath.row)
        index = indexPath.row
        timesCollectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 10) / 2, height: 55)
    }
    
}

extension PublishLiveAuctionViewController: FSCalendarDelegate, FSCalendarDataSource {

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
    }

    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }

}

// MARK: - FSCalendarDataSource and DataSource -
//extension PublishLiveAuctionViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
//    func minimumDate(for calendar: FSCalendar) -> Date {
//        return Date()
//    }
//
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        calendar.today = nil
////        let weekday = dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: date) - 1]
////        self.selectedDate = dateFormatter.string(from: date)
////        self.selectForm(weekDay: weekday, date: dateFormatter.string(from: date), selectedArea: self.selectedArea)
//    }
//}

