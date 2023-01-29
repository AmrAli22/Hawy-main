//
//  SalesAuctionsProductsViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 11/08/2022.
//

import UIKit
import Combine
import Alamofire
import PusherSwift

class SalesAuctionsProductsViewController: BaseViewViewController, PusherDelegate {
    
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var salesAuctionsProductsCollectionView: UICollectionView!{
        didSet {
            
            salesAuctionsProductsCollectionView.dataSource = self
            salesAuctionsProductsCollectionView.delegate = self
            //subCategoryCollectionView.contentInset.top = 30
            
            salesAuctionsProductsCollectionView.register(UINib(nibName: "SalesAuctionsProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SalesAuctionsProductsCollectionViewCell")
            
        }
    }
    @IBOutlet weak var titleScreenLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var personIcon: UIImageView!
    @IBOutlet weak var nameLAbel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var bidCounterLabel: UILabel!
    @IBOutlet weak var allCardsPriceValueLabel: UILabel!
    
    var name: String?
    var user: String?
    var date: String?
    var image: String?
    var bidsCount: Int?
    var cards = [MyAuctionCard]()
    
    var cards2 = [Card]()
    
    var auctionId: Int?
    
    var time: Int?
    
    var currentTime: Int?
    
    var isLive = false
    
    var titleType = 0
    
    //var screenTitleLabel: String?
    //var fromStock: Bool? = false
    
    let decoder = JSONDecoder()
    //to get socket
    var pusher: Pusher!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(auctionId)
        //titleScreenLabel.text = "Sales Auctions"
        
//        titleLabel.text = name ?? ""
//        nameLAbel.text = user ?? ""
//        //dateLabel.text = date ?? ""
//        let formatter3 = DateFormatter()
//        formatter3.dateFormat = " dd-MM-yyyy"
//        print(formatter3.string(from: Date(timeIntervalSince1970: TimeInterval(Int(date ?? "") ?? 0))))
//        dateLabel.text = formatter3.string(from: Date(timeIntervalSince1970: TimeInterval(Int(date ?? "") ?? 0)))
//        //print(cards[1])
//        bidCounterLabel.text = "\(bidsCount ?? 0)"
//        cardImage.loadImage(URLS.baseImageURL+(image ?? ""))
        
        salesAuctionsProductsCollectionView.collectionViewLayout = createCompositionalLayout()
        
        performPackage(id: auctionId)
        
        if titleType == 0 {
            titleScreenLabel.text = "Sales Auctions".localized
        }else if titleType == 1 {
            titleScreenLabel.text = "Live Auctions".localized
        }else if titleType == 2 {
            titleScreenLabel.text = "Stock Auctions".localized
        }
        
        listenToPriceFromUSDPusher(auction_id: auctionId)
        listenToPriceFromKWDPusher(auction_id: auctionId)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topContainer.roundCornersWithMask([.topLeading, .topTrailing], radius: 20)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //to disconnect socket
        pusher.disconnect()
        
    }
    
    private func listenToPriceFromKWDPusher(auction_id: Int?) {
        
        print("auction_id: \(auction_id)")
        // Instantiate Pusher
        pusher = Pusher(
            key: "65b581feebecaee4af62",
            options: PusherClientOptions(host: .cluster("eu"))
        )
        
        // Subscribe to a pusher channel
        let channel = pusher.subscribe("auction.\(auction_id ?? 0)")
        
        pusher.delegate = self
        
        pusher.connect()
        
        // Bind to an event called "order-event" on the event channel and fire
        // the callback when the event is triggerred
        
        let _ = channel.bind(eventName: "kwd_price_update" , eventCallback: { [weak self] (event: PusherEvent) -> Void in
            
            guard let self = self else { return }
            
            print(event)
            
            // convert the data string to type data for decoding
            guard let json = event.data,
                  let jsonData = json.data(using: .utf8)
            else {
                print("Could not convert JSON string to data")
                return
            }
            
            print(json)
            print(jsonData)
            
            // decode the event data as json into a RealTimeModel
            let decoded = try? self.decoder.decode(UpdateTimeModel.self, from: jsonData)
            guard let data = decoded else {
                print("Could not decode message")
                return
            }
            
            self.cards2 = data.data?.cards ?? [Card]()
            self.salesAuctionsProductsCollectionView.reloadData()
            
        })
        
    }
    
    private func listenToPriceFromUSDPusher(auction_id: Int?) {
        
        print("auction_id: \(auction_id)")
        // Instantiate Pusher
        pusher = Pusher(
            key: "65b581feebecaee4af62",
            options: PusherClientOptions(host: .cluster("eu"))
        )
        
        // Subscribe to a pusher channel
        let channel = pusher.subscribe("auction.\(auction_id ?? 0)")
        
        pusher.delegate = self
        
        pusher.connect()
        
        // Bind to an event called "order-event" on the event channel and fire
        // the callback when the event is triggerred
        
        let _ = channel.bind(eventName: "usd_price_update" , eventCallback: { [weak self] (event: PusherEvent) -> Void in
            
            guard let self = self else { return }
            
            print(event)
            
            // convert the data string to type data for decoding
            guard let json = event.data,
                  let jsonData = json.data(using: .utf8)
            else {
                print("Could not convert JSON string to data")
                return
            }
            
            print(json)
            print(jsonData)
            
            // decode the event data as json into a RealTimeModel
            let decoded = try? self.decoder.decode(UpdateTimeModel.self, from: jsonData)
            guard let data = decoded else {
                print("Could not decode message")
                return
            }
            
            self.cards2 = data.data?.cards ?? []
            self.salesAuctionsProductsCollectionView.reloadData()
            
        })
        
    }
    
    
    func performPackage(id: Int?) { //url: String, parameters: [String:Any]
        
        let url = "https://hawy-kw.com/api/auctions/sales/show?auction_id=\(id ?? 0)"
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
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
                            
                            self.titleLabel.text = forgetPasswordRequest.item?.name ?? ""
                            self.nameLAbel.text = forgetPasswordRequest.item?.user ?? ""
                            //dateLabel.text = date ?? ""
                            let formatter3 = DateFormatter()
                            formatter3.dateFormat = " dd-MM-yyyy hh:mm a"
                            print(formatter3.string(from: Date(timeIntervalSince1970: TimeInterval(Int(forgetPasswordRequest.item?.startDate ?? 0)))))
                            self.dateLabel.text = formatter3.string(from: Date(timeIntervalSince1970: TimeInterval(Int(forgetPasswordRequest.item?.startDate ?? 0))))
                            //print(cards[1])
                            self.allCardsPriceValueLabel.text = "\(forgetPasswordRequest.item?.cards?[0].price ?? "") " + (HelperConstant.getCurrency() ?? "K.D")
                            self.bidCounterLabel.text = "\(forgetPasswordRequest.item?.bidCounter ?? 0)"
                            self.cardImage.loadImage(URLS.baseImageURL+(forgetPasswordRequest.item?.owner?.image ?? ""))
                            
                            self.time = (forgetPasswordRequest.item?.startDate ?? 0)// * 1000
                            self.currentTime = Int(Date.currentTimeStamp)
                            
                            self.cards2 = forgetPasswordRequest.item?.cards ?? []
                            self.salesAuctionsProductsCollectionView.reloadData()
                            
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
    
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (index, environment) -> NSCollectionLayoutSection? in
            
            return self?.createSectionFor(index: index, environment: environment)
            
        }
        return layout
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
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(260))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        //section.orthogonalScrollingBehavior = .continuous
        
        return section
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension SalesAuctionsProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let firstAnimation = CollectionViewAnimationFactory.makeSlideIn(duration: 0.5, delayFactor: 0.05)
            let secondAnimation = CollectionViewAnimationFactory.makeFade(duration: 0.5, delayFactor: 0.05)
            let thirdAnimation = CollectionViewAnimationFactory.makeMoveUpWithBounce(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
            let fourthAnimation = CollectionViewAnimationFactory.makeMoveUpWithFade(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
            //
            let animator = CollectionViewAnimator(animation: firstAnimation)
            animator.animate(cell: cell, at: indexPath, in: collectionView)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards2.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = salesAuctionsProductsCollectionView.dequeueReusableCell(withReuseIdentifier: "SalesAuctionsProductsCollectionViewCell", for: indexPath) as? SalesAuctionsProductsCollectionViewCell else { return UICollectionViewCell() }
        
        let item = cards2[indexPath.row]
        
        cell.ownerStackView.isHidden = true
        cell.cardImage.loadImage(URLS.baseImageURL+(item.mainImage ?? ""))
        cell.cardNameLabel.text = item.name ?? ""
        cell.cardPriceLabel.text = "" //"\(item.price ?? "0.0")" + (HelperConstant.getCurrency() ?? "K.D") //"K.D".localized
        cell.bidMaxPriceLabel.text = "\(item.bidMaxPrice ?? "0.0") " + (HelperConstant.getCurrency() ?? "K.D") //"K.D".localized
        
        let userID = HelperConstant.getUserId()
        if (item.type == "live" && item.conductorAvailable == true && item.conductor?.id != userID) {
            if AppLocalization.currentAppleLanguage() == "en" {
                cell.spoilerHereLabel.text = "Spoiler here"
            }else {
                cell.spoilerHereLabel.text = "المدلل هنا"
            }
        }else{
            cell.spoilerHereLabel.text = ""
        }
        
        
//        if item.conducted_by == "me" {
//            cell.spoilerHereLabel.text = ""
//        }else{
//            if item.type == "live" && (item.conductor.id != ) {
//                if item.conductor_available == true {
//                    
//                    if AppLocalization.currentAppleLanguage() == "en" {
//                        cell.spoilerHereLabel.text = "Spoiler here"
//                    }else {
//                        cell.spoilerHereLabel.text = "المدلل هنا"
//                    }
//                    
//                }else {
//                    
//                    cell.spoilerHereLabel.text = ""
//                    
//                }
//            }else {
//                cell.spoilerHereLabel.text = ""
//            }
//        }
       
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = cards2[indexPath.row]
        
        print(time, currentTime)
        if time ?? 0 > currentTime ?? 0 {
          //  ToastManager.shared.showError(message: "Auction dosen't start yet".localized, view: self.view)
            let storyborad = UIStoryboard(name: "Profile", bundle: nil)
            let VC = storyborad.instantiateViewController(withIdentifier: "ShowAddedCardDetailsViewController") as? ShowAddedCardDetailsViewController
            
            VC?.cardId = item.id
            navigationController?.pushViewController(VC!, animated: false)
            
            
        }else {
            
            if item.type == "live" || isLive == true {

                let VC = AuctionLiveVideo()
                VC.auctionID = auctionId
                navigationController?.pushViewController(VC, animated: false)
      
            }else {
                
                let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
                let VC = storyborad.instantiateViewController(withIdentifier: "AuctionProductDetailsViewController") as? AuctionProductDetailsViewController
                VC?.auctionId = auctionId
                VC?.cardId = item.id
                
                VC?.price = "\(item.price ?? "0.0")"
                VC?.images = item.images ?? []
                VC?.desc = item.notes
                VC?.time = item.endDate ?? 0
                //VC?.ownerName = item
                //VC?.ownerImage = item
                
                navigationController?.pushViewController(VC!, animated: false)
                
            }
            
        }
        
    }
    
}

// MARK: - AddSaleAuctionModel
struct UpdateTimeModel: Codable {
    let data: UpdateTimeData?
}

// MARK: - DataClass
struct UpdateTimeData: Codable {
    let id: Int?
    let name: String?
    let startDate, endDate: Int?
    let user, subscribePrice, type, status: String?
    let currency: String?
    let cards: [Card]?
    let owner: UpdateTimeOwner?
    let startColor, endColor: String?
    let bidCounter: Int?

    enum CodingKeys: String, CodingKey {
        case id, name
        case startDate = "start_date"
        case endDate = "end_date"
        case user
        case subscribePrice = "subscribe_price"
        case type, status, currency, cards, owner
        case startColor = "start_color"
        case endColor = "end_color"
        case bidCounter = "bid_counter"
    }
}

// MARK: - Card
struct UpdateTimeCard: Codable {
    let id, auctionID: Int?
    let type, name, price, motherName: String?
    let fatherName, age, status: String?
    let startDate, endDate: Int?
    let currency, bidMaxPrice: String?
    let bidCounter: Int?
    let notes, conductedBy: String?
    let conductorAvailable: Bool?
    let documentationNumber: String?
    let conductor: UpdateTimeOwner?
    let categoryID: Int?
    let categoryName, mainImage, video: String?
    let images: [String]?
    let owners, inoculations, joinedUsers: [UpdateTimeOwner]?
    let owner, purchasedTo: UpdateTimeOwner?

    enum CodingKeys: String, CodingKey {
        case id
        case auctionID = "auction_id"
        case type, name, price
        case motherName = "mother_name"
        case fatherName = "father_name"
        case age, status
        case startDate = "start_date"
        case endDate = "end_date"
        case currency
        case bidMaxPrice = "bid_max_price"
        case bidCounter = "bid_counter"
        case notes
        case conductedBy = "conducted_by"
        case conductorAvailable = "conductor_available"
        case documentationNumber = "documentation_number"
        case conductor
        case categoryID = "category_id"
        case categoryName = "category_name"
        case mainImage = "main_image"
        case video, images, owners, inoculations
        case joinedUsers = "joined_users"
        case owner
        case purchasedTo = "purchased_to"
    }
}

// MARK: - Owner
struct UpdateTimeOwner: Codable {
    let id: Int?
    let name, mobile, code: String?
    let subscription: Bool?
    let image: String?
    let currency, isoCode: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, mobile, code, subscription, image, currency
        case isoCode = "iso_code"
    }
}
