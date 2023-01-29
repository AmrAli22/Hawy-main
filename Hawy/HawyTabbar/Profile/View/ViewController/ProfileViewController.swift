//
//  ProfileViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 23/08/2022.
//

import UIKit
import Combine
import Alamofire

class ProfileViewController: BaseViewViewController, BottomPopupDelegate {
    
    @IBOutlet weak var MCardsView: UIView!
    @IBOutlet weak var MCardsLabel: UILabel!
    
    @IBOutlet weak var MAdsView: UIView!
    @IBOutlet weak var MAdsLabel: UILabel!
    
    @IBOutlet weak var MAuctionsLabel: UILabel!
    @IBOutlet weak var MAuctionsView: UIView!
    
    @IBOutlet weak var firstContainerView: UIView!
    
    @IBOutlet weak var firstContainerTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cardsCollectionView: UICollectionView!{
        didSet {
            
            cardsCollectionView.dataSource = self
            cardsCollectionView.delegate = self
            //subCategoryCollectionView.contentInset.top = 30
            cardsCollectionView.contentInset.bottom = 150
            cardsCollectionView.register(UINib(nibName: "MyCardsProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyCardsProfileCollectionViewCell")
            
        }
    }
    
    
    
    @IBOutlet weak var auctionsView: UIView!
    @IBOutlet weak var auctionViewTableView: UITableView!
    
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var userimage: UIImageView!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var addsView: UIView!
    
    @IBOutlet weak var notificationButton: UIButton!
    
    var auctionData = [MyAuctionItem]()
    var adsData = [AddAdsItem]()
    
    var myProfile = true
    var startWithAuctions = false
    
    
    var cellRowToTimerMapping: [Int: Timer] = [:]
    var cellRowToPauseFlagMapping: [Int: Bool] = [:]
    
    @IBOutlet weak var addsCollectionView: UICollectionView!{
        didSet {
            
            addsCollectionView.dataSource = self
            addsCollectionView.delegate = self
            //subCategoryCollectionView.contentInset.top = 30
            addsCollectionView.contentInset.bottom = 150
            addsCollectionView.register(UINib(nibName: "MyCardsProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyCardsProfileCollectionViewCell")
            
        }
    }
    @IBOutlet weak var addNewCardButton: UIButton!
    @IBOutlet weak var addNewCardLabel: UILabel!
    
    @IBOutlet weak var addNewAddButton: UIButton!
    @IBOutlet weak var addnewaddLabel: UILabel!
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyView2: UIView!
    @IBOutlet weak var emptyView3: UIView!
    @IBOutlet weak var filterCardsLabel: UILabel!
    
    let firstColor = DesignSystem.Colors.PrimaryBlue.color
    let secondColor = DesignSystem.Colors.PrimaryOrange.color
    
    var tf = ""
    var timer2: Timer?
    var totalTime: Int = 0
    var finalTotal: Int = 0
    
    var ownerId: Int?
    
    var newName = ""
    var newPhone = ""
    var newImage = ""
    var newCode = ""
    
    var subscriber = Set<AnyCancellable>()
    
    private var viewModel = ProfileViewModel()
    
    //0: all, 1: active, 2: pending, 3: purchased, 4: lost
    var filter = 5
    
    var all = [MyCardsItem]()
    var active = [MyCardsItem]()
    var pending = [MyCardsItem]()
    var purchased = [MyCardsItem]()
    var lost = [MyCardsItem]()
    
    var phonee = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(ownerId)
        
        cardsCollectionView.collectionViewLayout = createCompositionalLayout()
        addsCollectionView.collectionViewLayout = createCompositionalLayout()
        
        setTableView()
        
        MCardsView.setGradient(firstColor: firstColor, secondColor: secondColor)
        DispatchQueue.main.async {
            self.MAdsView.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
            self.MAuctionsView.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
            self.MCardsLabel.textColor = .white
            self.MAdsLabel.textColor = .black
            self.MAuctionsLabel.textColor = .black
        }
        
        
        
        sinkToLoading()
        sinkToReLoading()
        sinkToProfileMyAuctionsModelPublisher()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if myProfile == true {
            
            addnewaddLabel.isHidden = false
            addNewAddButton.isHidden = false
            addNewCardLabel.isHidden = false
            addNewCardButton.isHidden = false
            
            getProfileData(userId: HelperConstant.getUserId() ?? 0)
            
            Task {
                do {
                    //let myAuctions = try await viewModel.myAuctions()
                    //print(myAuctions)
                    
                    getProfileAuctions(userId: HelperConstant.getUserId() ?? 0)
                    getProfileAds(userId: HelperConstant.getUserId() ?? 0)
                    let myCards = try await viewModel.profileMyCards(type: "profile", id: HelperConstant.getUserId())
                    print(myCards)
                }catch {
                    // tell the user something went wrong, I hope
                    debugPrint(error)
                }
            }
            
        }else {
            
            addnewaddLabel.isHidden = true
            addNewAddButton.isHidden = true
            addNewCardLabel.isHidden = true
            addNewCardButton.isHidden = true
            
            getProfileData(userId: ownerId ?? 0)
            
            
            
            Task {
                do {
                    //let myAuctions = try await viewModel.myAuctions()
                    //print(myAuctions)
                    
                    getProfileAuctions(userId: ownerId ?? 0)
                    getProfileAds(userId: ownerId ?? 0)
                    let myCards = try await viewModel.profileMyCards(type: "profile", id: ownerId)
                    print(myCards)
                    
                    
                    
                }catch {
                    // tell the user something went wrong, I hope
                    debugPrint(error)
                }
            }
            
        }
        
        readNotification()
        
        if startWithAuctions {
            MAuctionsView.setGradient(firstColor: firstColor, secondColor: secondColor)
            DispatchQueue.main.async {
                self.MCardsView.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
                self.MAdsView.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
                self.MCardsLabel.textColor = .black
                self.MAdsLabel.textColor = .black
                self.MAuctionsLabel.textColor = .white
                
                self.auctionsView.isHidden = false
                self.addsView.isHidden = true
                
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        firstContainerView.roundCorners([.topLeft, .topRight], radius: 20)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        DispatchQueue.main.async {
            
            self.firstContainerView.roundCorners([.topLeft, .topRight], radius: 20)
            
            //self.setup()
            
        }
    }
    
    @IBAction func whatsButtonTapped(_ sender: Any) {
        
        let phoneNumber = self.phonee
        let appURL = URL(string: "https://wa.me/\(phoneNumber)")!
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appURL)
            }
        }
        
    }
    
    func readNotification() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")"
        ]
        
        //showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/notifications/status", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(ReadNotificationModel.self, from: response.data!)
                
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
                //
                if productResponse.item?.status == true {
                    self.notificationButton.setImage(UIImage(named: "notification"), for: .normal)
                }else {
                    self.notificationButton.setImage(UIImage(named: "Group 52267"), for: .normal)
                }
                
                //self.hideIndecator()
            } catch {
                //self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    
    func getProfileAds(userId: Int?) {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator() //
        AF.request("https://hawy-kw.com/api/auth/profile/ads?user_id=\(userId ?? 0)", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(AdsModel.self, from: response.data!)
                
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
                    self.adsData = productResponse.item ?? []
                    self.addsCollectionView.reloadData()
                    
                    if self.adsData.isEmpty == true {
                        self.emptyView3.isHidden = false
                    }else {
                        self.emptyView3.isHidden = true
                    }
                    
                }
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    func getProfileAuctions(userId: Int?) {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator() //
        AF.request("https://hawy-kw.com/api/auth/profile/auctions?user_id=\(userId ?? 0)", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(MyAuctionModel.self, from: response.data!)
                
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
                    self.auctionData = productResponse.item ?? []
                    self.auctionViewTableView.reloadData()
                    
                    if self.auctionData.isEmpty == true {
                        self.emptyView2.isHidden = false
                    }else {
                        self.emptyView2.isHidden = true
                    }
                    
                }
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    //https://hawy-kw.com/api/auth/profile/cards/show?id=9
    func getProfileData(userId: Int?) {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        let param: [String: Any] = [
            
            "user_id": userId ?? 0
            
        ]
        
        showIndecator() //
        AF.request("https://hawy-kw.com/api/auth/user", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
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
                    
//                    if self.myProfile == true {
//                        self.namelabel.text = productResponse.item?.name ?? ""
//                        self.userimage.loadImage(URLS.baseImageURL+(productResponse.item?.image ?? ""))
//                        self.phoneLabel.text = (productResponse.item?.code  ?? "") + (productResponse.item?.mobile ?? "")
//
//                        self.phonee = productResponse.item?.mobile ?? ""
//
//                    }else {
//
//                        self.namelabel.text = self.newName
//                        self.userimage.loadImage(URLS.baseImageURL+self.newImage)
//                        self.phoneLabel.text = (self.newCode) + (self.newPhone)
//
//                        self.phonee = self.newPhone
//
//                    }
                    
                    self.namelabel.text = productResponse.item?.name ?? ""
                    self.userimage.loadImage(URLS.baseImageURL+(productResponse.item?.image ?? ""))
                    self.phoneLabel.text = (productResponse.item?.code  ?? "") + (productResponse.item?.mobile ?? "")
                    
                    self.phonee = productResponse.item?.mobile ?? ""
                    
                }
                self.hideIndecator()
            } catch {
                self.hideIndecator()
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
    
    func sinkToReLoading() {
//        self.viewModel.loadinState
//            .sink { [weak self] state in
//                self?.handleActivityIndicator(state: state)
//            }.store(in: &subscriber)
        self.viewModel.reloadingState
            .sink { [weak self] (state) in
                guard let self = self else { return }
                if state {
                    print("show Loading")
                    self.auctionViewTableView.reloadData()
                    self.cardsCollectionView.reloadData()
                    //self.addsCollectionView.reloadData()
                }
            }.store(in: &subscriber)
    }
    
    func sinkToProfileMyAuctionsModelPublisher() {
        viewModel.profileMyCardsModelPublisher.sink { [weak self] (result) in
            guard let self = self else { return }
            if result?.code == 200 {
                
                //0: all, 1: active, 2: pending, 3: purchased, 4: lost
                self.all.removeAll()
                self.active.removeAll()
                self.pending.removeAll()
                self.purchased.removeAll()
                self.lost.removeAll()
                
                if result?.message == "Unauthenticated." {
                    
                    let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
                        
                        
                        let story = UIStoryboard(name: "Authentication", bundle:nil)
                        let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                        
                    }
                    let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                for filter in result?.item?.cards ?? [] {
                    
                    if filter.status == "active" {
                        self.active.append(MyCardsItem(id: filter.id, auctionID: filter.auctionID, name: filter.name, motherName: filter.motherName, fatherName: filter.fatherName, age: filter.age, status: filter.status, startDate: filter.startDate, endDate: filter.endDate, notes: filter.notes, categoryID: filter.categoryID, categoryName: filter.categoryName, mainImage: filter.mainImage, video: filter.video, images: filter.images, owners: filter.owners, inoculations: filter.inoculations, owner: filter.owner, purchasedTo: filter.purchasedTo))
                    }else if filter.status == "pending" {
                        self.pending.append(MyCardsItem(id: filter.id, auctionID: filter.auctionID, name: filter.name, motherName: filter.motherName, fatherName: filter.fatherName, age: filter.age, status: filter.status, startDate: filter.startDate, endDate: filter.endDate, notes: filter.notes, categoryID: filter.categoryID, categoryName: filter.categoryName, mainImage: filter.mainImage, video: filter.video, images: filter.images, owners: filter.owners, inoculations: filter.inoculations, owner: filter.owner, purchasedTo: filter.purchasedTo))
                    }else if filter.status == "purchased" {
                        self.purchased.append(MyCardsItem(id: filter.id, auctionID: filter.auctionID, name: filter.name, motherName: filter.motherName, fatherName: filter.fatherName, age: filter.age, status: filter.status, startDate: filter.startDate, endDate: filter.endDate, notes: filter.notes, categoryID: filter.categoryID, categoryName: filter.categoryName, mainImage: filter.mainImage, video: filter.video, images: filter.images, owners: filter.owners, inoculations: filter.inoculations, owner: filter.owner, purchasedTo: filter.purchasedTo))
                    }else if filter.status == "lost" {
                        self.lost.append(MyCardsItem(id: filter.id, auctionID: filter.auctionID, name: filter.name, motherName: filter.motherName, fatherName: filter.fatherName, age: filter.age, status: filter.status, startDate: filter.startDate, endDate: filter.endDate, notes: filter.notes, categoryID: filter.categoryID, categoryName: filter.categoryName, mainImage: filter.mainImage, video: filter.video, images: filter.images, owners: filter.owners, inoculations: filter.inoculations, owner: filter.owner, purchasedTo: filter.purchasedTo))
                    }else {
                        self.all.append(MyCardsItem(id: filter.id, auctionID: filter.auctionID, name: filter.name, motherName: filter.motherName, fatherName: filter.fatherName, age: filter.age, status: filter.status, startDate: filter.startDate, endDate: filter.endDate, notes: filter.notes, categoryID: filter.categoryID, categoryName: filter.categoryName, mainImage: filter.mainImage, video: filter.video, images: filter.images, owners: filter.owners, inoculations: filter.inoculations, owner: filter.owner, purchasedTo: filter.purchasedTo))
                    }
                    
                }
                
                
                
                if result?.item?.cards?.isEmpty == true {
                    self.emptyView.isHidden = false
                }else {
                    self.emptyView.isHidden = true
                }
                
//                let stroyboard = UIStoryboard(name: "Authentication", bundle: nil)
//                let VC = stroyboard.instantiateViewController(withIdentifier: "VeificationViewController") as? VeificationViewController
//                VC?.phone = (self.countryCode ?? "") + (self.phoneTF.text ?? "")
//                VC?.countryCode = self.countyCodeTF.text
//                VC?.homeOrNot = false
//                self.navigationController?.pushViewController(VC!, animated: true)
            }
        }.store(in: &subscriber)
    }
    
    func setTableView() {
        
        auctionViewTableView.register(UINib(nibName: "ProfileMySaleAuctionTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileMySaleAuctionTableViewCell")
        
        auctionViewTableView.contentInset.bottom = 150
        
        let sectionsTableViewFrame = CGRect(x: 0, y: 0, width: auctionViewTableView.frame.size.width, height: 1)
        auctionViewTableView.tableFooterView = UIView(frame: sectionsTableViewFrame)
        auctionViewTableView.tableHeaderView = UIView(frame: sectionsTableViewFrame)
        
        auctionViewTableView.delegate = self
        auctionViewTableView.dataSource = self
        
    }
    
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (index, environment) -> NSCollectionLayoutSection? in
            
            return self?.createSectionFor(index: index, environment: environment)
            
        }
        return layout
    }
    
    func setup(offsetY: CGFloat) {
        
        let yOffset = cardsCollectionView.contentOffset.y
        print(yOffset)
        
        let yOffset2 = auctionViewTableView.contentOffset.y
        print(yOffset2)
        
        if offsetY > 20 /* abs(xOffset) > 250 yOffset > 250 */ {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 1.0) { [weak self] in
                //your code here
                guard let self = self else { return }
                //self.viewOutlet.isHidden = false
                //self.viewOutlet.fadeIn(view: self.viewOutlet)
                self.firstContainerTopConstraint.constant = 10
                self.view.layoutIfNeeded()
            }
            
        }else {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 1.0) { [weak self] in
                //your code here
                guard let self = self else { return }
                //self.viewOutlet.isHidden = true
                //self.viewOutlet.fadeOut(view: self.viewOutlet)
                self.firstContainerTopConstraint.constant = 150
                self.view.layoutIfNeeded()
            }
            
        }
        
//        if yOffset2 > 20 /* abs(xOffset) > 250 yOffset > 250 */ {
//            self.view.layoutIfNeeded()
//            UIView.animate(withDuration: 1.0) { [weak self] in
//                //your code here
//                guard let self = self else { return }
//                //self.viewOutlet.isHidden = false
//                //self.viewOutlet.fadeIn(view: self.viewOutlet)
//                self.firstContainerTopConstraint.constant = 10
//                self.view.layoutIfNeeded()
//            }
//
//        }else {
//            self.view.layoutIfNeeded()
//            UIView.animate(withDuration: 1.0) { [weak self] in
//                //your code here
//                guard let self = self else { return }
//                //self.viewOutlet.isHidden = true
//                //self.viewOutlet.fadeOut(view: self.viewOutlet)
//                self.firstContainerTopConstraint.constant = 150
//                self.view.layoutIfNeeded()
//            }
//
//        }
        
    }
    
    func createSectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        switch index {
        case 0:
            return createFourthSection()
        default:
            return createFourthSection()
        }
    }
    
    func createFourthSection() -> NSCollectionLayoutSection {
        
        let inset: CGFloat = 5
        
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200)) //.fractionalHeight(0.65)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        //section.orthogonalScrollingBehavior = .continuous
        
        return section
        
    }
    
    @IBAction func editeProfileButtonAction(_ sender: Any) {
        let storyborad = UIStoryboard(name: "Profile", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "EditeProfileViewController") as? EditeProfileViewController
        navigationController?.pushViewController(VC!, animated: false)
    }
    @IBAction func filterButtonAction(_ sender: Any) {
        let storyborad = UIStoryboard(name: "Profile", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "FilterProfileCardsViewController") as! FilterProfileCardsViewController
        VC.height = 385 //self.view.frame.height - 100
        VC.topCornerRadius = 8
        VC.presentDuration = 0.5
        VC.dismissDuration = 0.5
        VC.popupDelegate = self
        
        //0: all, 1: active, 2: pending, 3: purchased, 4: lost
        VC.all = viewModel.profileMyCardsModel?.item?.cards?.count ?? 0
        VC.active = active.count
        VC.pending = pending.count
        VC.purchased = purchased.count
        VC.lost = lost.count
        
        VC.backFilter = { filter in
            
            self.filter = filter
            self.cardsCollectionView.reloadData()
            
            if filter == 0 {
                self.filterCardsLabel.text = "All Cards".localized
            }else if filter == 1 {
                self.filterCardsLabel.text = "Active Cards".localized
            }else if filter == 2 {
                self.filterCardsLabel.text = "Pending Cards".localized
            }else if filter == 3 {
                self.filterCardsLabel.text =  "Purchased Cards".localized
            }else if filter == 4 {
                self.filterCardsLabel.text = "Lost Cards".localized
            }else {
                self.filterCardsLabel.text = "All Cards".localized
            }
            
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
    
    @IBAction func addCardsButtonAction(_ sender: Any) {
        let storyborad = UIStoryboard(name: "Profile", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "AddCardsFromProfileViewController") as! AddCardsFromProfileViewController
        navigationController?.pushViewController(VC, animated: false)
    }
    
    @IBAction func addNewAdButtonAction(_ sender: Any) {
        
        let storyborad = UIStoryboard(name: "HawyTabbar", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "AddAdsFromProfileViewController") as! AddAdsFromProfileViewController
        navigationController?.pushViewController(VC, animated: false)
        
    }
    
    
    @IBAction func myCardsButtonAction(_ sender: Any) {
        MCardsView.setGradient(firstColor: firstColor, secondColor: secondColor)
        DispatchQueue.main.async {
            self.MAdsView.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
            self.MAuctionsView.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
            self.MCardsLabel.textColor = .white
            self.MAdsLabel.textColor = .black
            self.MAuctionsLabel.textColor = .black
            
            self.auctionsView.isHidden = true
            self.addsView.isHidden = true
            
        }
    }
    
    @IBAction func myAdsButtonAction(_ sender: Any) {
        MAdsView.setGradient(firstColor: firstColor, secondColor: secondColor)
        DispatchQueue.main.async {
            self.MCardsView.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
            self.MAuctionsView.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
            self.MCardsLabel.textColor = .black
            self.MAdsLabel.textColor = .white
            self.MAuctionsLabel.textColor = .black
            
            self.auctionsView.isHidden = true
            self.addsView.isHidden = false
            
        }
    }
    
    @IBAction func myAuctionsButtonAction(_ sender: Any) {
        MAuctionsView.setGradient(firstColor: firstColor, secondColor: secondColor)
        DispatchQueue.main.async {
            self.MCardsView.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
            self.MAdsView.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
            self.MCardsLabel.textColor = .black
            self.MAdsLabel.textColor = .black
            self.MAuctionsLabel.textColor = .white
            
            self.auctionsView.isHidden = false
            self.addsView.isHidden = true
            
        }
    }
    
    @objc func makeCollepse(button: UIButton) {
        print("tapped")
    }
    
    @IBAction func notificationButtonTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Notifications", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        
        navigationController?.pushViewController(VC, animated: true)
        
    }
    
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        DispatchQueue.main.async {
//            let firstAnimation = CollectionViewAnimationFactory.makeSlideIn(duration: 0.5, delayFactor: 0.05)
//            let secondAnimation = CollectionViewAnimationFactory.makeFade(duration: 0.5, delayFactor: 0.05)
//            let thirdAnimation = CollectionViewAnimationFactory.makeMoveUpWithBounce(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
//            let fourthAnimation = CollectionViewAnimationFactory.makeMoveUpWithFade(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
//            //
//            let animator = CollectionViewAnimator(animation: firstAnimation)
//            animator.animate(cell: cell, at: indexPath, in: collectionView)
//        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == cardsCollectionView {
            //0: all, 1: active, 2: pending, 3: purchased, 4: lost
            if filter == 0 {
                return viewModel.profileMyCardsModel?.item?.cards?.count ?? 0
            }else if filter == 1 {
                return active.count
            }else if filter == 2 {
                return pending.count
            }else if filter == 3 {
                return purchased.count
            }else if filter == 4 {
                return lost.count
            }else {
                return viewModel.profileMyCardsModel?.item?.cards?.count ?? 0
            }
            
        }else {
            return adsData.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == cardsCollectionView {
            guard let cell = cardsCollectionView.dequeueReusableCell(withReuseIdentifier: "MyCardsProfileCollectionViewCell", for: indexPath) as? MyCardsProfileCollectionViewCell else { return UICollectionViewCell() }
            
            
            
            if filter == 0 {
                let item  = viewModel.profileMyCardsModel?.item?.cards?[indexPath.row]
                cell.imageCard.loadImage(URLS.baseImageURL+(item?.mainImage ?? ""))
                cell.titleLabel.text = item?.name
                
                if item?.status == "pending" {
                    cell.stateView.backgroundColor = .lightGray
                }else if item?.status == "active" {
                    cell.stateView.backgroundColor = .systemGreen
                }else if item?.status == "purchased" {
                    cell.stateView.backgroundColor = .systemRed
                }else {
                    cell.stateView.backgroundColor = .black
                }
            }else if filter == 1 {
                let item = active[indexPath.row]
                cell.imageCard.loadImage(URLS.baseImageURL+(item.mainImage ?? ""))
                cell.titleLabel.text = item.name
                
                if item.status == "pending" {
                    cell.stateView.backgroundColor = .lightGray
                }else if item.status == "active" {
                    cell.stateView.backgroundColor = .systemGreen
                }else if item.status == "purchased" {
                    cell.stateView.backgroundColor = .systemRed
                }else {
                    cell.stateView.backgroundColor = .black
                }
            }else if filter == 2 {
                let item = pending[indexPath.row]
                cell.imageCard.loadImage(URLS.baseImageURL+(item.mainImage ?? ""))
                cell.titleLabel.text = item.name
                
                if item.status == "pending" {
                    cell.stateView.backgroundColor = .lightGray
                }else if item.status == "active" {
                    cell.stateView.backgroundColor = .systemGreen
                }else if item.status == "purchased" {
                    cell.stateView.backgroundColor = .systemRed
                }else {
                    cell.stateView.backgroundColor = .black
                }
            }else if filter == 3 {
                let item = purchased[indexPath.row]
                cell.imageCard.loadImage(URLS.baseImageURL+(item.mainImage ?? ""))
                cell.titleLabel.text = item.name
                
                if item.status == "pending" {
                    cell.stateView.backgroundColor = .lightGray
                }else if item.status == "active" {
                    cell.stateView.backgroundColor = .systemGreen
                }else if item.status == "purchased" {
                    cell.stateView.backgroundColor = .systemRed
                }else {
                    cell.stateView.backgroundColor = .black
                }
            }else if filter == 4 {
                let item = lost[indexPath.row]
                cell.imageCard.loadImage(URLS.baseImageURL+(item.mainImage ?? ""))
                cell.titleLabel.text = item.name
                
                if item.status == "pending" {
                    cell.stateView.backgroundColor = .lightGray
                }else if item.status == "active" {
                    cell.stateView.backgroundColor = .systemGreen
                }else if item.status == "purchased" {
                    cell.stateView.backgroundColor = .systemRed
                }else {
                    cell.stateView.backgroundColor = .black
                }
            }else {
                let item  = viewModel.profileMyCardsModel?.item?.cards?[indexPath.row]
                cell.imageCard.loadImage(URLS.baseImageURL+(item?.mainImage ?? ""))
                cell.titleLabel.text = item?.name
                
                if item?.status == "pending" {
                    cell.stateView.backgroundColor = .lightGray
                }else if item?.status == "active" {
                    cell.stateView.backgroundColor = .systemGreen
                }else if item?.status == "purchased" {
                    cell.stateView.backgroundColor = .systemRed
                }else {
                    cell.stateView.backgroundColor = .black
                }
            }
            
            return cell
        }else {
            guard let cell = addsCollectionView.dequeueReusableCell(withReuseIdentifier: "MyCardsProfileCollectionViewCell", for: indexPath) as? MyCardsProfileCollectionViewCell else { return UICollectionViewCell() }
            
            let item  = adsData[indexPath.row]
            cell.imageCard.loadImage(URLS.baseImageURL+(item.cardImage ?? ""))
            cell.titleLabel.text = item.cardName
            
            return cell
        }
        
    }
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
            if collectionView == cardsCollectionView {
                
                if filter == 0 {
                    
                    let item  = viewModel.profileMyCardsModel?.item?.cards?[indexPath.row]
                    if myProfile == true {
                        let storyborad = UIStoryboard(name: "Profile", bundle: nil)
                        let VC = storyborad.instantiateViewController(withIdentifier: "ShowAddedCardDetailsViewController") as? ShowAddedCardDetailsViewController
                        
                        VC?.cardId = item?.id
                        navigationController?.pushViewController(VC!, animated: false)
                    }else {
                        let storyborad = UIStoryboard(name: "Profile", bundle: nil)
                        let VC = storyborad.instantiateViewController(withIdentifier: "ShowAddedCardDetailsViewController") as? ShowAddedCardDetailsViewController
                        VC?.cardId = item?.id
                        VC?.myProfile = self.myProfile
                        present(VC!, animated: false, completion: nil)
                    }
                    
                }else if filter == 1 {
                    let item = active[indexPath.row]
                    if myProfile == true {
                        let storyborad = UIStoryboard(name: "Profile", bundle: nil)
                        let VC = storyborad.instantiateViewController(withIdentifier: "ShowAddedCardDetailsViewController") as? ShowAddedCardDetailsViewController
                        
                        VC?.cardId = item.id
                        navigationController?.pushViewController(VC!, animated: false)
                    }else {
                        let storyborad = UIStoryboard(name: "Profile", bundle: nil)
                        let VC = storyborad.instantiateViewController(withIdentifier: "ShowAddedCardDetailsViewController") as? ShowAddedCardDetailsViewController
                        VC?.cardId = item.id
                        VC?.myProfile = self.myProfile
                        present(VC!, animated: false, completion: nil)
                    }
                }else if filter == 2 {
                    let item = pending[indexPath.row]
                    if myProfile == true {
                        let storyborad = UIStoryboard(name: "Profile", bundle: nil)
                        let VC = storyborad.instantiateViewController(withIdentifier: "ShowAddedCardDetailsViewController") as? ShowAddedCardDetailsViewController
                        
                        VC?.cardId = item.id
                        navigationController?.pushViewController(VC!, animated: false)
                    }else {
                        let storyborad = UIStoryboard(name: "Profile", bundle: nil)
                        let VC = storyborad.instantiateViewController(withIdentifier: "ShowAddedCardDetailsViewController") as? ShowAddedCardDetailsViewController
                        VC?.cardId = item.id
                        VC?.myProfile = self.myProfile
                        present(VC!, animated: false, completion: nil)
                    }
                }else if filter == 3 {
                    let item = purchased[indexPath.row]
                    if myProfile == true {
                        let storyborad = UIStoryboard(name: "Profile", bundle: nil)
                        let VC = storyborad.instantiateViewController(withIdentifier: "ShowAddedCardDetailsViewController") as? ShowAddedCardDetailsViewController
                        
                        VC?.cardId = item.id
                        navigationController?.pushViewController(VC!, animated: false)
                    }else {
                        let storyborad = UIStoryboard(name: "Profile", bundle: nil)
                        let VC = storyborad.instantiateViewController(withIdentifier: "ShowAddedCardDetailsViewController") as? ShowAddedCardDetailsViewController
                        VC?.cardId = item.id
                        VC?.myProfile = self.myProfile
                        present(VC!, animated: false, completion: nil)
                    }
                }else if filter == 4 {
                    let item = lost[indexPath.row]
                    if myProfile == true {
                        let storyborad = UIStoryboard(name: "Profile", bundle: nil)
                        let VC = storyborad.instantiateViewController(withIdentifier: "ShowAddedCardDetailsViewController") as? ShowAddedCardDetailsViewController
                        
                        VC?.cardId = item.id
                        navigationController?.pushViewController(VC!, animated: false)
                    }else {
                        let storyborad = UIStoryboard(name: "Profile", bundle: nil)
                        let VC = storyborad.instantiateViewController(withIdentifier: "ShowAddedCardDetailsViewController") as? ShowAddedCardDetailsViewController
                        VC?.cardId = item.id
                        VC?.myProfile = self.myProfile
                        present(VC!, animated: false, completion: nil)
                    }
                }else {
                    let item  = viewModel.profileMyCardsModel?.item?.cards?[indexPath.row]
                    if myProfile == true {
                        let storyborad = UIStoryboard(name: "Profile", bundle: nil)
                        let VC = storyborad.instantiateViewController(withIdentifier: "ShowAddedCardDetailsViewController") as? ShowAddedCardDetailsViewController
                        
                        VC?.cardId = item?.id
                        navigationController?.pushViewController(VC!, animated: false)
                    }else {
                        let storyborad = UIStoryboard(name: "Profile", bundle: nil)
                        let VC = storyborad.instantiateViewController(withIdentifier: "ShowAddedCardDetailsViewController") as? ShowAddedCardDetailsViewController
                        VC?.cardId = item?.id
                        VC?.myProfile = self.myProfile
                        present(VC!, animated: false, completion: nil)
                    }
                }
                
            }else {
                let item  = adsData[indexPath.row]
                
                if myProfile == true {
                    let storyborad = UIStoryboard(name: "Profile", bundle: nil)
                    let VC = storyborad.instantiateViewController(withIdentifier: "ShowAddedCardDetailsViewController") as? ShowAddedCardDetailsViewController
                    VC?.cardId = item.cardID
                    navigationController?.pushViewController(VC!, animated: false)
                }else {
                    let storyborad = UIStoryboard(name: "Profile", bundle: nil)
                    let VC = storyborad.instantiateViewController(withIdentifier: "ShowAddedCardDetailsViewController") as? ShowAddedCardDetailsViewController
                    VC?.cardId = item.cardID
                    VC?.myProfile = self.myProfile
                    present(VC!, animated: false, completion: nil)
                }
                
                
            }
        }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //viewWillLayoutSubviews()
        setup(offsetY: scrollView.contentOffset.y)
    }
    
    private func setupTimer(for cell: UITableViewCell, indexPath: IndexPath, numberOfSeconds: Int) {
        let row = indexPath.row
        if cellRowToTimerMapping[row] == nil {
            var numberOfSecondsPassed = numberOfSeconds
            let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { capturedTimer in
                
                if self.cellRowToPauseFlagMapping[row] != nil && self.cellRowToPauseFlagMapping[row] == true {
                    return
                }
                                
                numberOfSecondsPassed -= 1
                
                if let visibleCell = self.auctionViewTableView.cellForRow(at: indexPath) as? ProfileMySaleAuctionTableViewCell {
                    
//                    if let visibleCell = visibleCell {
//
//                    }
                    
                    visibleCell.timerLabel.text = self.timeFormatted(numberOfSecondsPassed) // will show timer
                    visibleCell.timerLabel.textColor = DesignSystem.Colors.PrimaryBlack.color
                    
                    print(numberOfSecondsPassed)
                    if numberOfSecondsPassed <= 0 {
                        print(numberOfSecondsPassed)
                        numberOfSecondsPassed = 0
                        self.cellRowToPauseFlagMapping[row] = true
                        
                        
                        
                        visibleCell.timerLabel.text = "00 : 00 : 00"
                        visibleCell.timerLabel.textColor = DesignSystem.Colors.PrimaryDarkRed.color
                        //timer.invalidate()
//                        if let visibleCell = visibleCell {
//
//                            //self.timer2?.invalidate()
//                            //visibleCell.textLabel?.text = "Loading..."
//                        }
//                        else {
//
//
//
//                            visibleCell.totalTime -= 1
//                        }
                        
                        self.makeNetworkCall {
                            //self.cellRowToPauseFlagMapping[row] = false
                        }
                    }
                    
                }

                
            }
            cellRowToTimerMapping[row] = timer
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    
    //MARK:- SetUp timeFormatted
    func timeFormatted(_ totalSeconds: Int) -> String {
        
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hour: Int = totalSeconds / 3600
        
        return hour > 0 ? String(format: "%02d:%02d:%02d", hour, minutes, seconds) : String(format: "%02d:%02d", minutes, seconds)
        
    }
    

    private func makeNetworkCall(completion: @escaping () -> Void) {
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        DispatchQueue.main.async {
//            let firstAnimation = AnimationFactory.makeSlideIn(duration: 0.5, delayFactor: 0.05)
//            let secondAnimation = AnimationFactory.makeFade(duration: 0.5, delayFactor: 0.05)
//            let thirdAnimation = AnimationFactory.makeMoveUpWithBounce(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
//            let fourthAnimation = AnimationFactory.makeMoveUpWithFade(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
//            //
//            let animator = Animator(animation: firstAnimation)
//            animator.animate(cell: cell, at: indexPath, in: tableView)
//        }
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return auctionData.count //viewModel.profileMyAuctionsModel?.item?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !auctionData[section].isExpanded {
            return 0
        }
        
        return auctionData[section].cards?.count ?? 0 //viewModel.profileMyAuctionsModel?.item?[section].cards?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = auctionViewTableView.dequeueReusableCell(withIdentifier: "ProfileMySaleAuctionTableViewCell", for: indexPath) as? ProfileMySaleAuctionTableViewCell else { return UITableViewCell() }
        
        let item = auctionData[indexPath.section].cards?[indexPath.row] //viewModel.profileMyAuctionsModel?.item?[indexPath.section].cards?[indexPath.row]
        
        cell.cardImage.loadImage(URLS.baseImageURL+(item?.mainImage ?? ""))
        cell.titleLabel.text = item?.name
        cell.priceLabel.text = "\(item?.bidMaxPrice ?? "0.0")" + (HelperConstant.getCurrency() ?? "K.D") //"K.D".localized
        
        let startTime = (item?.startDate ?? 0)
        let endTime = (item?.endDate ?? 0)
        let currentTime = Int(Date.currentTimeStamp)
        
        let formatter3 = DateFormatter()
        formatter3.dateFormat = " dd-MM-yyyy"
        print(formatter3.string(from: Date(timeIntervalSince1970: TimeInterval(item?.startDate ?? 0))))
        cell.timerLabel.text = formatter3.string(from: Date(timeIntervalSince1970: TimeInterval((item?.endDate ?? 0) - (item?.startDate ?? 0))))
        
        if startTime > currentTime {
            //ToastManager.shared.showError(message: "Auction dosen't start yet".localized, view: self.view)
            cell.timerLabel.text = formatter3.string(from: Date(timeIntervalSince1970: TimeInterval((item?.endDate ?? 0) - (item?.startDate ?? 0))))
        }else {
            
            if endTime <= currentTime {
                cell.timerLabel.textColor = DesignSystem.Colors.PrimaryDarkRed.color
                cell.timerLabel.text = "00 : 00 : 00"
            }else {
                let finalTimeStamp = endTime - currentTime
                self.finalTotal = finalTimeStamp
                let (h, m, s) = self.secondsToHoursMinutesSeconds(finalTimeStamp)
                  print ("\(h) , \(m) , \(s)")
                cell.timerLabel.textColor = DesignSystem.Colors.PrimaryBlack.color
                cell.timerLabel.text = "\(h) : \(m) : \(s)"

                //cell.startOtpTimer(data: item)
            }
            
            //let endTime = (item?.endDate ?? 0)
            //let currentTime = Int(Date.currentTimeStamp)
            
            
            let finalTimeStamp2 = endTime - currentTime
            setupTimer(for: cell, indexPath: indexPath, numberOfSeconds: finalTimeStamp2)
            
            
            //cell.timerLabel.text = item.t
            cell.auctionLabel.text = "\(item?.bidCounter ?? 0)"
            //cell
            
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if myProfile == true {
            
            let item1 = auctionData[indexPath.section]
            let item2 = auctionData[indexPath.section].cards?[indexPath.row]
            
            let startTime = (item1.startDate ?? 0)
            let endTime = (item1.endDate ?? 0)
            let currentTime = Int(Date.currentTimeStamp)
            
            if item1.type == "live" {
                
                if startTime > currentTime {
                    ToastManager.shared.showError(message: "Auction dosen't start yet".localized, view: self.view)
                }else {
                    
//                    let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
//                    let VC = storyborad.instantiateViewController(withIdentifier: "LiveAuctionsDetailsViewController") as? LiveAuctionsDetailsViewController
//                    VC?.auction_id = item1.id
//                    VC?.card_id = item2?.id
//                    //VC?.fromProfile = true
//                    navigationController?.pushViewController(VC!, animated: false)
                    
//                    let VC = NewLiveViewController()
//                    VC.auction_id = item1.id
                    let VC = AuctionLiveVideo()
                    VC.auctionID = item1.id
                    navigationController?.pushViewController(VC, animated: false)
                    
                }
                
                
                
            }else {
                
                if startTime > currentTime {
                    ToastManager.shared.showError(message: "Auction dosen't start yet".localized, view: self.view)
                }else {
                    
                    let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
                    let VC = storyborad.instantiateViewController(withIdentifier: "AuctionProductDetailsViewController") as? AuctionProductDetailsViewController
                    VC?.auctionId = item1.id
                    VC?.cardId = item2?.id
                    VC?.fromProfile = true
                    navigationController?.pushViewController(VC!, animated: false)
                    
                }
                
                
                
            }
            
            
        }else {
            
            let item1 = auctionData[indexPath.section]
            let item2 = auctionData[indexPath.section].cards?[indexPath.row]
            
            let startTime = (item1.startDate ?? 0)
            let endTime = (item1.endDate ?? 0)
            let currentTime = Int(Date.currentTimeStamp)
            
            if item1.type == "live" {
                
//                if startTime > currentTime {
//                    ToastManager.shared.showError(message: "Auction dosen't start yet".localized, view: self.view)
//                }else {
//
//                    let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
//                    let VC = storyborad.instantiateViewController(withIdentifier: "LiveAuctionsDetailsViewController") as? LiveAuctionsDetailsViewController
//                    VC?.auction_id = item1.id
//                    VC?.card_id = item2?.id
//                    //VC?.fromProfile = true
//                    navigationController?.pushViewController(VC!, animated: false)
//
//                }
                
//                let VC = NewLiveViewController()
//                VC.auction_id = item1.id
                let VC = AuctionLiveVideo()
                VC.auctionID = item1.id
                navigationController?.pushViewController(VC, animated: false)
                
            }else {
                
                if startTime > currentTime {
                    ToastManager.shared.showError(message: "Auction dosen't start yet".localized, view: self.view)
                }else {
                    
                    let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
                    let VC = storyborad.instantiateViewController(withIdentifier: "AuctionProductDetailsViewController") as? AuctionProductDetailsViewController
                    VC?.auctionId = item1.id
                    VC?.cardId = item2?.id
                    VC?.fromProfile = true
                    present(VC!, animated: false, completion: nil)
                    
                }
                
                
                
            }
            
        }
        
    }
    
    @objc func handleExpandClose(button: UIButton) {
        print("Trying to expand and close section...")
        
        let section = button.tag
        
        // we'll try to close the section first by deleting the rows
        var indexPaths = [IndexPath]()
        for row in auctionData[section].cards!.indices {
            print(0, row)
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = auctionData[section].isExpanded
        auctionData[section].isExpanded = !isExpanded
        
        //button.setTitle(isExpanded ? "Open" : "Close", for: .normal)
        
        if isExpanded {
            auctionViewTableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            auctionViewTableView.insertRows(at: indexPaths, with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let item = auctionData[section] //viewModel.profileMyAuctionsModel?.item?[section]
        
        // first create the custom view
        let myCustomView = UIView()
        
        let arrowUpDowmImage: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "Iconly Light Arrow - Down -1")
            imageView.contentMode = .scaleAspectFit
            imageView.layer.masksToBounds = false
            imageView.layer.cornerRadius = 12.5
            return imageView
        }()
        let firstTimerImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "07448c5d1447c49b9630f1fe372af70f")
            imageView.contentMode = .scaleAspectFit
            imageView.layer.masksToBounds = false
            imageView.layer.cornerRadius = 12.5
            return imageView
        }()
        let secondTimerImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "07448c5d1447c49b9630f1fe372af70f")
            imageView.contentMode = .scaleAspectFit
            imageView.layer.masksToBounds = false
            imageView.layer.cornerRadius = 12.5
            return imageView
        }()
        let saleAuctionImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "Search results for Auctions - Flaticon-3")
            imageView.tintColor = .white
            imageView.contentMode = .scaleAspectFit
            imageView.layer.masksToBounds = false
            imageView.layer.cornerRadius = 12.5
            return imageView
        }()
        let TitleLabel: UILabel = {
            let lable = UILabel()
            lable.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            lable.text = "Hamam"
            lable.textColor = .white
            return lable
        }()
        let firstTimerLabel: UILabel = {
            let lable = UILabel()
            lable.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            lable.text = "7-8-2020"
            lable.numberOfLines = 2
            lable.textColor = .white
            return lable
        }()
        let secondTimerLabel: UILabel = {
            let lable = UILabel()
            lable.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            lable.text = "7-8-2020"
            lable.numberOfLines = 2
            lable.textColor = .white
            return lable
        }()
        let saleAuctionLabel: UILabel = {
            let lable = UILabel()
            lable.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            lable.text = "Sale auction"
            lable.textColor = .white
            return lable
        }()
        
        let collapseButton:  UIButton = {
            
            let button = UIButton()
            button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
            
            button.tag = section
            
            return button
        }()
        
        // create a view cell and attach the custom view to it
        let headerView = UITableViewHeaderFooterView()
        let contentView = headerView.contentView
        let gradientView = GradientView()
        
        contentView.addSubview(myCustomView)
        myCustomView.addSubview(gradientView)
        
        gradientView.addSubview(TitleLabel)
        gradientView.addSubview(firstTimerLabel)
        gradientView.addSubview(secondTimerLabel)
        gradientView.addSubview(saleAuctionLabel)
        
        gradientView.addSubview(arrowUpDowmImage)
        gradientView.addSubview(firstTimerImageView)
        gradientView.addSubview(secondTimerImageView)
        gradientView.addSubview(saleAuctionImageView)
        gradientView.addSubview(collapseButton)
        
        myCustomView.backgroundColor = UIColor.clear
        headerView.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        gradientView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradientView.gradientLayer.colors = [UIColor().colorWithHexString(hexString: item.startColor ?? "").cgColor, UIColor().colorWithHexString(hexString: item.endColor ?? "").cgColor]
        gradientView.layer.cornerRadius = 20
        
        // add extra code to pin all the anchors
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        myCustomView.translatesAutoresizingMaskIntoConstraints = false
        TitleLabel.translatesAutoresizingMaskIntoConstraints = false
        firstTimerLabel.translatesAutoresizingMaskIntoConstraints = false
        secondTimerLabel.translatesAutoresizingMaskIntoConstraints = false
        saleAuctionLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowUpDowmImage.translatesAutoresizingMaskIntoConstraints = false
        firstTimerImageView.translatesAutoresizingMaskIntoConstraints = false
        secondTimerImageView.translatesAutoresizingMaskIntoConstraints = false
        saleAuctionImageView.translatesAutoresizingMaskIntoConstraints = false
        collapseButton.translatesAutoresizingMaskIntoConstraints = false
        
        myCustomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        myCustomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        myCustomView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        myCustomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        gradientView.leadingAnchor.constraint(equalTo: myCustomView.leadingAnchor).isActive = true
        gradientView.trailingAnchor.constraint(equalTo: myCustomView.trailingAnchor).isActive = true
        gradientView.topAnchor.constraint(equalTo: myCustomView.topAnchor).isActive = true
        gradientView.bottomAnchor.constraint(equalTo: myCustomView.bottomAnchor).isActive = true
        
        collapseButton.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor).isActive = true
        collapseButton.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor).isActive = true
        collapseButton.topAnchor.constraint(equalTo: gradientView.topAnchor).isActive = true
        collapseButton.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            
            TitleLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 30),
            TitleLabel.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 15),
            
            arrowUpDowmImage.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -30),
            arrowUpDowmImage.centerYAnchor.constraint(equalTo: TitleLabel.centerYAnchor),
            arrowUpDowmImage.widthAnchor.constraint(equalToConstant: 20),
            arrowUpDowmImage.heightAnchor.constraint(equalToConstant: 20),
            
            firstTimerImageView.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 5),
            firstTimerImageView.topAnchor.constraint(equalTo: TitleLabel.bottomAnchor, constant: 15),
            firstTimerImageView.widthAnchor.constraint(equalToConstant: 20),
            firstTimerImageView.heightAnchor.constraint(equalToConstant: 20),
            
            firstTimerLabel.leadingAnchor.constraint(equalTo: firstTimerImageView.trailingAnchor, constant: 5),
            firstTimerLabel.centerYAnchor.constraint(equalTo: firstTimerImageView.centerYAnchor),
            firstTimerLabel.widthAnchor.constraint(equalToConstant: 85),
            
            secondTimerImageView.leadingAnchor.constraint(equalTo: firstTimerLabel.trailingAnchor, constant: 5),
            secondTimerImageView.topAnchor.constraint(equalTo: firstTimerImageView.topAnchor),
            secondTimerImageView.widthAnchor.constraint(equalToConstant: 20),
            secondTimerImageView.heightAnchor.constraint(equalToConstant: 20),
            
            secondTimerLabel.leadingAnchor.constraint(equalTo: secondTimerImageView.trailingAnchor, constant: 5),
            secondTimerLabel.centerYAnchor.constraint(equalTo: secondTimerImageView.centerYAnchor),
            secondTimerLabel.widthAnchor.constraint(equalToConstant: 85),
            
            saleAuctionImageView.leadingAnchor.constraint(equalTo: secondTimerLabel.trailingAnchor, constant: 5),
            saleAuctionImageView.topAnchor.constraint(equalTo: firstTimerImageView.topAnchor),
            saleAuctionImageView.widthAnchor.constraint(equalToConstant: 20),
            saleAuctionImageView.heightAnchor.constraint(equalToConstant: 20),
            
            saleAuctionLabel.leadingAnchor.constraint(equalTo: saleAuctionImageView.trailingAnchor, constant: 5),
            saleAuctionLabel.centerYAnchor.constraint(equalTo: saleAuctionImageView.centerYAnchor),
            
        ])
        
        collapseButton.addTarget(self, action: #selector(makeCollepse), for: .touchUpInside)
        
        
        
        TitleLabel.text = item.name
        firstTimerLabel.text = "\(item.startDate ?? 0)"
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "dd-MM-yyyy hh:mm a"
        print(formatter3.string(from: Date(timeIntervalSince1970: TimeInterval(item.startDate ?? 0))))
        firstTimerLabel.text = formatter3.string(from: Date(timeIntervalSince1970: TimeInterval(item.startDate ?? 0)))
        secondTimerLabel.text = formatter3.string(from: Date(timeIntervalSince1970: TimeInterval(item.endDate ?? 0)))//"\(item.endDate ?? 0)"
        saleAuctionLabel.text = item.type
        
//      collapseButton)  if ownerName == "Inhouse" {
//            label.text = ""
//        }else {
//            label.text = ownerName
//        }
//
//        imageView.loadImage(URL(string: "\(URLS.baseImageURL)\(carts[section].owner_image ?? "")"))
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        showPinnedHeaders()
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        showPinnedHeaders()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        removePinnedHeaders()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        removePinnedHeaders()
    }

    private func showPinnedHeaders() {
        for section in 0..<(viewModel.profileMyAuctionsModel?.item?.count ?? 0) {
            auctionViewTableView.headerView(forSection: section)?.isHidden = false
        }
    }

    private func removePinnedHeaders() {
        if let indexPathsForVisibleRows = auctionViewTableView.indexPathsForVisibleRows {
            if indexPathsForVisibleRows.count > 0 {
                for indexPathForVisibleRow in indexPathsForVisibleRows {
                    if let header = auctionViewTableView.headerView(forSection: indexPathForVisibleRow.section) {
                        if let cell = auctionViewTableView.cellForRow(at: indexPathForVisibleRow) {
                            if header.frame.intersects(cell.frame) {
                                let seconds = 0.5
                                let delay = seconds * Double(NSEC_PER_SEC)
                                let dispatchTime = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                    if !self.auctionViewTableView.isDragging && header.frame.intersects(cell.frame) {
                                        //header.isHidden = true
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
}
