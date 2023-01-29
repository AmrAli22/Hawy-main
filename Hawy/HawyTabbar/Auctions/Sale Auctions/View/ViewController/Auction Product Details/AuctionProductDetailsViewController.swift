//
//  AuctionProductDetailsViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 12/08/2022.
//

import UIKit
import PusherSwift
import Alamofire

class AuctionProductDetailsViewController: BaseViewViewController, PusherDelegate, BottomPopupDelegate {
    
    @IBOutlet weak var bannerContainerView: UIView!
    
    @IBOutlet weak var contanerOfWinView: UIView!
    @IBOutlet weak var contanerOfWinViewHeight: NSLayoutConstraint!
    @IBOutlet weak var winView: UIView!
    @IBOutlet weak var highPriceView: UIView!
    
    @IBOutlet weak var plusButtonOutlet: UIButton!
    @IBOutlet weak var minusButtonOutlet: UIButton!
    @IBOutlet weak var bidLabel: UILabel!
    @IBOutlet weak var addBidButton: GradientButton!
    
    @IBOutlet weak var yourLucklabel: UILabel!
    @IBOutlet weak var yourLuckImage: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var biddingView: UIView!
    
    @IBOutlet weak var descTV: UITextView!
    
    @IBOutlet weak var saleAuctionProductBannerCollectionView: UICollectionView!{
        didSet {
            
            saleAuctionProductBannerCollectionView.dataSource = self
            saleAuctionProductBannerCollectionView.delegate = self
            //subCategoryCollectionView.contentInset.top = 30
            saleAuctionProductBannerCollectionView.reloadData()
            saleAuctionProductBannerCollectionView.register(UINib(nibName: "SubCategoryDetailsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SubCategoryDetailsCollectionViewCell")
            
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var currencyBidLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var ownerUserImage: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    
    @IBOutlet weak var startPriceLabel: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var clockImage: UIImageView!
    
    @IBOutlet weak var offerView: UIView!
    
    @IBOutlet weak var offerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var backToHomeButton: GradientButton!
    @IBOutlet weak var waitingForAcceptButtonAction: UIButton!
    @IBOutlet weak var waitingForAceptButonHeight: NSLayoutConstraint!
    @IBOutlet weak var contactWhatsAppView: UIView!
    @IBOutlet weak var contactWhatsAppViewHeight: NSLayoutConstraint!
    @IBOutlet weak var extendTimeButtonOutlet: GradientButton!
    
    @IBOutlet weak var acceptRejectViewHeight: NSLayoutConstraint!
    @IBOutlet weak var acceptRejectView: UIView!
    @IBOutlet weak var acceptOfferLabel: UILabel!
    @IBOutlet weak var desc24HLabel: UILabel!
    
    @IBOutlet weak var acceptRejectButtonsStack: UIStackView!
    @IBOutlet weak var acceptButtonOutlet: GradientButton!
    @IBOutlet weak var rejectButtonOutlet: GradientButton!
    
    @IBOutlet weak var payDoneStack: UIStackView!
    @IBOutlet weak var payDoneButtonOutlet: GradientButton!
    
    @IBOutlet weak var plusMinusDescLabel: UILabel!
    
    var lastOfferUserId: Int?
    
    var timer = Timer()
    var counter = 0
    
    var timer2: Timer?
    var totalTime: Int = 0
    var finalTotal: Int = 0
    
    var bidMaxPrice: String?
    var bidCounter: Int?
    
    var auctionId: Int?
    var cardId:Int?
    
    var price: String?
    var images: [String] = []
    var desc: String?
    var ownerName: String?
    var ownerImage: String?
    var time: Int?
    
    var currentTime: Int?
    
    var phoneNumber = ""
    
    let decoder = JSONDecoder()
    //to get socket
    var pusher: Pusher!
    
    var pusher2: Pusher!
    
    var fromProfile: Bool?
    
    var cardData = [ShowCardDetailsItem]()
    
    var isStockAuction: Bool?
    
    var isOwnerId = 0
    
    @IBOutlet weak var biddingViewHeight: NSLayoutConstraint!
    @IBOutlet weak var congarateView: UIView!
    @IBOutlet weak var congarateViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var backToHomeView: UIView!
    @IBOutlet weak var backToHomeViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if fromProfile == true {
            congarateView.isHidden = true
            congarateViewHeight.constant = 0
            biddingView.isHidden = true
            yourLucklabel.isHidden = true
            yourLuckImage.isHidden = true
            biddingViewHeight.constant = 0
            contanerOfWinView.isHidden = true
            contanerOfWinViewHeight.constant = 0
            
        }else {
            congarateView.isHidden = false
            congarateViewHeight.constant = 70
            biddingView.isHidden = false
            yourLucklabel.isHidden = false
            yourLuckImage.isHidden = false
            biddingViewHeight.constant = 200 //230
            contanerOfWinView.isHidden = false
            contanerOfWinViewHeight.constant = 120
            
        }
        
        self.offerView.isHidden = true
        self.acceptRejectView.isHidden = true
        self.offerViewHeight.constant = 0 //220
        self.acceptRejectViewHeight.constant = 0
        
        backToHomeButton.isHidden = true
        backToHomeView.isHidden = true
        backToHomeViewHeight.constant = 0
        winView.isHidden = true
        //highPriceView.isHidden = true
        //acceptRejectView.isHidden = true
        //backToHomeButton.isHidden = true
        waitingForAcceptButtonAction.isHidden = true
        waitingForAceptButonHeight.constant = 0
        contactWhatsAppView.isHidden = true
        contactWhatsAppViewHeight.constant = 0
        acceptRejectViewHeight.constant = 0
        //offerViewHeight.constant = 200
        //offerView.isHidden = true
        
        //getCardData(id: cardId, userId: HelperConstant.getUserId() ?? 0)
        
        //getLastOffer()
        
        //listenToChangesFromPusher(auction_id: auctionId ?? 0, card_id: cardId ?? 0)
        
//        pageControl.numberOfPages = 5
//        DispatchQueue.main.async {
//            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
//        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if fromProfile == true {
            biddingView.isHidden = true
            yourLucklabel.isHidden = true
            yourLuckImage.isHidden = true
        }else {
            biddingView.isHidden = false
            yourLucklabel.isHidden = false
            yourLuckImage.isHidden = false
        }
        
        backToHomeButton.isHidden = true
        backToHomeView.isHidden = true
        backToHomeViewHeight.constant = 0
        winView.isHidden = true
        //acceptRejectView.isHidden = true
        //backToHomeButton.isHidden = true
        waitingForAcceptButtonAction.isHidden = true
        waitingForAceptButonHeight.constant = 0
        contactWhatsAppView.isHidden = true
        contactWhatsAppViewHeight.constant = 0
        
        
        getCardData(id: cardId, userId: HelperConstant.getUserId() ?? 0)
        getLastOffer()
        
        if HelperConstant.getCurrency() == "USD" {
            listenToChangesFromPusherUSD(auction_id: auctionId ?? 0, card_id: cardId ?? 0)
        }else {
            listenToChangesFromPusher(auction_id: auctionId ?? 0, card_id: cardId ?? 0)
        }
        
        listenToChangesFromPusherTime(auction_id: auctionId ?? 0, card_id: cardId ?? 0)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bannerContainerView.roundCorners([.bottomLeft, .bottomRight], radius: 20)
        winView.roundCorners([.topLeft, .topRight], radius: 20)
        highPriceView.roundCorners([.bottomLeft, .bottomRight], radius: 20)
        plusButtonOutlet.roundCorners([.topLeft, .bottomLeft], radius: 10)
        minusButtonOutlet.roundCorners([.topRight, .bottomRight], radius: 10)
        
        let gradient = UIImage.gradientImage(bounds: ownerUserImage.bounds, colors: [DesignSystem.Colors.PrimaryBlue.color, DesignSystem.Colors.PrimaryOrange.color])
        let gradientColor = UIColor(patternImage: gradient)
        ownerUserImage.layer.borderColor = gradientColor.cgColor
        ownerUserImage.layer.borderWidth = 3
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //to disconnect socket
        pusher.disconnect()
        pusher2.disconnect()
        self.timer2?.invalidate()
        
    }
    
    private func listenToChangesFromPusherTime(auction_id: Int?, card_id: Int?) {
        
        print("auction_id: \(auction_id), card_id: \(card_id)")
        // Instantiate Pusher
        pusher2 = Pusher(
            key: "65b581feebecaee4af62",
            options: PusherClientOptions(host: .cluster("eu"))
        )
        
        // Subscribe to a pusher channel
        let channel = pusher2.subscribe("auction.\(auction_id ?? 0).\(card_id ?? 0)")
        
        pusher2.delegate = self
        
        pusher2.connect()
        
        // Bind to an event called "order-event" on the event channel and fire
        // the callback when the event is triggerred
        
        let eventNamee = #"App\Events\ApiDataListener"#
        print("App\\Events\\ApiDataListener")
        
        print(eventNamee)
        
        let _ = channel.bind(eventName: "App\\Events\\UpdateTime" , eventCallback: { [weak self] (event: PusherEvent) -> Void in
            
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
            let decoded = try? self.decoder.decode(UpdateTime.self, from: jsonData)
            guard let data = decoded else {
                print("Could not decode message")
                return
            }
            
            self.finalTotal = data.end_date ?? 0
            self.startOtpTimer()
            
        })
        
    }
    
    private func listenToChangesFromPusherUSD(auction_id: Int?, card_id: Int?) {
        
        print("auction_id: \(auction_id), card_id: \(card_id)")
        // Instantiate Pusher
        pusher = Pusher(
            key: "65b581feebecaee4af62",
            options: PusherClientOptions(host: .cluster("eu"))
        )
        
        // Subscribe to a pusher channel
        let channel = pusher.subscribe("auction.\(auction_id ?? 0).\(card_id ?? 0)")
        
        pusher.delegate = self
        
        pusher.connect()
        
        // Bind to an event called "order-event" on the event channel and fire
        // the callback when the event is triggerred
        
        let eventNamee = #"App\Events\ApiDataListener"#
        print("App\\Events\\ApiDataListener")
        
        print(eventNamee)
        
        let _ = channel.bind(eventName: "usd_bid" , eventCallback: { [weak self] (event: PusherEvent) -> Void in
            
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
            let decoded = try? self.decoder.decode(RealTimeModel.self, from: jsonData)
            guard let data = decoded else {
                print("Could not decode message")
                return
            }
            
            self.contanerOfWinView.isHidden = false
            self.contanerOfWinViewHeight.constant = 60
            
            self.highPriceView.isHidden = false
            
            if data.data?.offer?.user?.id == HelperConstant.getUserId() {
                self.yourLucklabel.text = "You seem to be the luckiest person to win the auction so far".localized
                self.yourLuckImage.isHidden = false
                
            }else {
                self.yourLucklabel.text = "Looks like you won't win the auction".localized
                self.yourLuckImage.isHidden = true
            }
            
            if Double(data.data?.offer?.price ?? "0.0") ?? 0.0 >= 1000.0 {
                self.plusMinusDescLabel.text = "The minimum increase is 50 dinars".localized
            }else {
                self.plusMinusDescLabel.text = "The minimum increase is 10 dinars".localized
            }
            
            self.bidLabel.text = "\(data.data?.offer?.minimumBidding ?? 0.0)"
            
            self.bidMaxPrice = data.data?.offer?.price ?? "0.0" //Double(data.data?.offer?.price ?? "0.0")
            
            self.priceLabel.text = "\(data.data?.offer?.price ?? "0.0")"
            //self.bidLabel.text = data.data?.price
            self.ownerUserImage.loadImage(URLS.baseImageURL+(data.data?.offer?.user?.image ?? ""))
            self.ownerNameLabel.text = data.data?.offer?.user?.name ?? ""
            //self.descTV.text = desc ?? ""
            
            print("\(data.data) says \(data.data)")
            
            
            
        })
        
    }
    
    private func listenToChangesFromPusher(auction_id: Int?, card_id: Int?) {
        
        print("auction_id: \(auction_id), card_id: \(card_id)")
        // Instantiate Pusher
        pusher = Pusher(
            key: "65b581feebecaee4af62",
            options: PusherClientOptions(host: .cluster("eu"))
        )
        
        // Subscribe to a pusher channel
        let channel = pusher.subscribe("auction.\(auction_id ?? 0).\(card_id ?? 0)")
        
        pusher.delegate = self
        
        pusher.connect()
        
        // Bind to an event called "order-event" on the event channel and fire
        // the callback when the event is triggerred
        
        let eventNamee = #"App\Events\ApiDataListener"#
        print("App\\Events\\ApiDataListener")
        
        print(eventNamee)
        
        let _ = channel.bind(eventName: "kwd_bid" , eventCallback: { [weak self] (event: PusherEvent) -> Void in
            
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
            let decoded = try? self.decoder.decode(RealTimeModel.self, from: jsonData)
            guard let data = decoded else {
                print("Could not decode message")
                return
            }
            
            self.contanerOfWinView.isHidden = false
            self.contanerOfWinViewHeight.constant = 60
            
            self.congarateView.isHidden = false
            self.congarateViewHeight.constant = 70
            
            self.highPriceView.isHidden = false
            if data.data?.offer?.user?.id == HelperConstant.getUserId() {
                self.yourLucklabel.text = "You seem to be the luckiest person to win the auction so far".localized
                self.yourLuckImage.isHidden = false
                
            }else {
                self.yourLucklabel.text = "Looks like you won't win the auction".localized
                self.yourLuckImage.isHidden = true
            }
            
            if Double(data.data?.offer?.price ?? "0.0") ?? 0.0 >= 1000.0 {
                self.plusMinusDescLabel.text = "The minimum increase is 50 dinars".localized
            }else {
                self.plusMinusDescLabel.text = "The minimum increase is 10 dinars".localized
            }
            
            self.bidLabel.text = "\(data.data?.offer?.minimumBidding ?? 0.0)"
            
            self.bidMaxPrice = data.data?.offer?.price ?? "0.0" //Double(data.data?.offer?.price ?? "0.0")
            
            self.priceLabel.text = "\(data.data?.offer?.price ?? "0.0")"
            //self.bidLabel.text = data.data?.price
            self.ownerUserImage.loadImage(URLS.baseImageURL+(data.data?.offer?.user?.image ?? ""))
            self.ownerNameLabel.text = data.data?.offer?.user?.name ?? ""
            //self.descTV.text = desc ?? ""
            
            print("\(data.data) says \(data.data)")
            
            
            
        })
        
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func timeString(time: TimeInterval) -> String {
            let hour = Int(time) / 3600
            let minute = Int(time) / 60 % 60
            let second = Int(time) % 60

            // return formated string
            return String(format: "%02i:%02i:%02i", hour, minute, second)
        }
    
    
    func getCardData(id: Int?, userId: Int?) {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/auth/profile/cards/show?id=\(id ?? 0)&user_id=\(userId ?? 0)&auction_id=\(auctionId ?? 0)", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(ShowCardDetailsModel.self, from: response.data!)
                
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
                    
                    self.currencyLabel.text = HelperConstant.getCurrency() ?? "KWD"
                    self.currencyBidLabel.text = HelperConstant.getCurrency() ?? "KWD"
                    
                    if productResponse.item?.bidCounter == 0 {
                        self.contanerOfWinView.isHidden = false
                        self.contanerOfWinViewHeight.constant = 60
                        
                        self.highPriceView.isHidden = false
                        //self.highPriceView.isHidden = true
                        
                        self.yourLuckImage.isHidden = true
                        
                        self.currencyLabel.text = HelperConstant.getCurrency() ?? "KWD"
                        self.currencyBidLabel.text = HelperConstant.getCurrency() ?? "KWD"
                        self.priceLabel.text = "\(productResponse.item?.price ?? "0.0")"
                        self.ownerUserImage.loadImage(URLS.baseImageURL+(productResponse.item?.owner?.image ?? ""))
                        self.ownerNameLabel.text = productResponse.item?.owner?.name ?? ""
                        
                    }else {
                        self.contanerOfWinView.isHidden = false
                        self.contanerOfWinViewHeight.constant = 60
                        
                        self.highPriceView.isHidden = false
                        self.highPriceView.isHidden = false
                        
                        self.getLastOffer()
                        
                    }
                    
                    self.bidCounter = productResponse.item?.bidCounter
                    
                    self.bidMaxPrice = productResponse.item?.bid_max_price
                    
                    if Double(self.bidMaxPrice ?? "0.0") ?? 0.0 >= 1000.0 {
                        self.plusMinusDescLabel.text = "The minimum increase is 50 dinars".localized
                        self.bidLabel.text = "50"
                    }else {
                        self.plusMinusDescLabel.text = "The minimum increase is 10 dinars".localized
                        self.bidLabel.text = "10"
                    }
                    
                    self.descTV.text = productResponse.item?.notes ?? ""
                    
                    //self.images = productResponse.item?.images ?? []
                    
                    if productResponse.item?.images?.isEmpty == true {
                        self.images.append(productResponse.item?.mainImage ?? "")
                    }else {
                        self.images = productResponse.item?.images ?? []
                    }
                    
                    self.pageControl.numberOfPages = self.images.count
                    
                    self.time = (productResponse.item?.endDate ?? 0)// * 1000
                    self.currentTime = Int(Date.currentTimeStamp)
                    
                    self.phoneNumber = "\(productResponse.item?.owner?.code ?? "")" + "\(productResponse.item?.owner?.mobile ?? "")"
                    
                    self.isOwnerId = productResponse.item?.owner?.id ?? 0
                    
                    if productResponse.item?.owner?.id == HelperConstant.getUserId() {
                        
                        self.biddingView.isHidden = true
                        self.yourLucklabel.isHidden = true
                        self.yourLuckImage.isHidden = true
                        
                        self.biddingView.isHidden = true
                        
                        if self.isStockAuction == true {
                            
                            self.extendTimeButtonOutlet.isHidden = true
                            
                        }else {
                            
                            self.extendTimeButtonOutlet.isHidden = false
                            
                            self.extendTimeButtonOutlet.setTitleColor(.white, for: .normal)
                            
                            self.extendTimeButtonOutlet.setTitleColor(.white, for: .normal)
                            
                            self.extendTimeButtonOutlet.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                            self.extendTimeButtonOutlet.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                            self.extendTimeButtonOutlet.gradientLayer.colors = [DesignSystem.Colors.PrimaryLightBlue.color.cgColor, DesignSystem.Colors.PrimaryOrange.color.cgColor]
                            
                        }
                        
                        
                        
                    }else {
                        self.biddingView.isHidden = false
                        self.extendTimeButtonOutlet.isHidden = true
                        
                        if self.isStockAuction == true {
                            
                            self.extendTimeButtonOutlet.isHidden = true
                            
                        }else {
                            
                            self.extendTimeButtonOutlet.isHidden = true
                            
                            self.extendTimeButtonOutlet.setTitleColor(.black, for: .normal)
                            
                            self.extendTimeButtonOutlet.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                            self.extendTimeButtonOutlet.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                            self.extendTimeButtonOutlet.gradientLayer.colors = [DesignSystem.Colors.ButtonBG.color.cgColor, DesignSystem.Colors.ButtonBG.color.cgColor]
                            
                        }
                        
                    }
                    
                    if productResponse.item?.owner?.id == HelperConstant.getUserId() {
                        self.offerView.isHidden = true
                        self.acceptRejectView.isHidden = true
                        self.offerViewHeight.constant = 0 //220
                        self.acceptRejectViewHeight.constant = 0
                        
                        self.congarateView.isHidden = true
                        self.congarateViewHeight.constant = 0
                        self.biddingView.isHidden = true
                        self.yourLucklabel.isHidden = true
                        self.yourLuckImage.isHidden = true
                        self.biddingViewHeight.constant = 0
                        
                    }else {
                        self.offerView.isHidden = true
                        self.acceptRejectView.isHidden = true
                        self.offerViewHeight.constant = 0
                        self.acceptRejectViewHeight.constant = 0
                        
                        self.congarateView.isHidden = false
                        self.congarateViewHeight.constant = 70
                        self.biddingView.isHidden = false
                        self.yourLucklabel.isHidden = false
                        self.yourLuckImage.isHidden = false
                        self.biddingViewHeight.constant =  210 //230
                        
                    }
                    
                    if self.time ?? 0 <= self.currentTime ?? 0 {
                        
                        
                        
                        self.timer2?.invalidate()
                        self.timerLabel.text = "00 : 00 : 00"
                        self.timerLabel.textColor = DesignSystem.Colors.PrimaryDarkRed.color
                        
                        self.clockImage.image = UIImage(named: "asset-2")
                        
                        
                        self.extendTimeButtonOutlet.isHidden = true
                        
                        self.extendTimeButtonOutlet.setTitleColor(.black, for: .normal)
                        
                        if productResponse.item?.owner?.id == HelperConstant.getUserId() {
                            self.offerView.isHidden = true
                            self.acceptRejectView.isHidden = false
                            self.offerViewHeight.constant = 0 //220
                            self.acceptRejectViewHeight.constant = 250
                            self.waitingForAcceptButtonAction.isHidden = false
                            self.waitingForAceptButonHeight.constant = 55
                            self.contactWhatsAppView.isHidden = false
                            self.contactWhatsAppViewHeight.constant = 55
                            
                            self.congarateView.isHidden = true
                            self.congarateViewHeight.constant = 0
                            self.biddingView.isHidden = true
                            self.yourLucklabel.isHidden = true
                            self.yourLuckImage.isHidden = true
                            self.biddingViewHeight.constant = 0
                            
                            if self.bidCounter == 0 {
                                
                                self.acceptRejectView.isHidden = true
                                self.acceptRejectViewHeight.constant = 0
                                
                            }else {
                                
                                self.acceptRejectView.isHidden = false
                                self.acceptRejectViewHeight.constant = 250
                                
                            }
                            
                        }else {
                            self.offerView.isHidden = true
                            self.acceptRejectView.isHidden = true
                            self.offerViewHeight.constant = 0
                            self.acceptRejectViewHeight.constant = 0
                            
                            self.congarateView.isHidden = false
                            self.congarateViewHeight.constant = 70
                            self.biddingView.isHidden = false
                            self.yourLucklabel.isHidden = false
                            self.yourLuckImage.isHidden = false
                            self.biddingViewHeight.constant =  210 //230
                            
                        }
                        
                        
                        
                        self.plusButtonOutlet.isEnabled = false
                        self.minusButtonOutlet.isEnabled = false
                        self.addBidButton.isHidden = true
                        self.backToHomeButton.isHidden = false
                        self.backToHomeView.isHidden = false
                        self.backToHomeViewHeight.constant = 55
                        
                        self.contactWhatsAppView.isHidden = false
                        self.contactWhatsAppViewHeight.constant = 55
                        self.waitingForAcceptButtonAction.isHidden = false
                        self.waitingForAceptButonHeight.constant = 55
                        
                        self.getLastOffer()
                        self.getAuctionStatus()
                        
                    }else {
                        
                        //let finalTimeStamp = (self.time ?? 0) - (self.currentTime ?? 0)
                        //self.timerLabel.text = self.timeString(time: //TimeInterval(productResponse.item?.endDate ?? 0))
                        //self.timerLabel.textColor = DesignSystem.Colors.PrimaryGreen.color
                        
                        self.timerLabel.text = self.timeString(time: TimeInterval(productResponse.item?.endDate ?? 0 * 1000))
                        let finalTimeStamp = (self.time ?? 0) - (self.currentTime ?? 0)
                        self.finalTotal = finalTimeStamp
                        let (h, m, s) = self.secondsToHoursMinutesSeconds(finalTimeStamp)
                          print ("\(h) Hours, \(m) Minutes, \(s) Seconds")
                        //self.timerLabel.text = "\(h) : \(m) : \(s)"
                        self.startOtpTimer()
                        self.timerLabel.textColor = DesignSystem.Colors.PrimaryBlack.color
                        self.clockImage.image = UIImage(systemName: "clock.fill")
                        
                        
                    }
                    
                    self.saleAuctionProductBannerCollectionView.reloadData()
                    
                }
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    func performRequest() { //url: String, parameters: [String:Any]
        
        let url = "https://hawy-kw.com/api/bid"
        
        let param: [String: Any] = [
            
            "card_id" : cardId ?? 0,
            "auction_id": auctionId ?? 0,
            "price": bidLabel.text ?? "",
            "bid_time": Int(Date.currentTimeStamp)
            
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
            .validate()
        
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
                        let forgetPasswordRequest = try decoder.decode(BidModel.self, from: data)
                        print(forgetPasswordRequest)
                        
                        if forgetPasswordRequest.code == 200 {
                            
                            print("success")
                            
                            self.bidLabel.text = "\(forgetPasswordRequest.item?.minimumBiding ?? 0)"
                            
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
    
    func getAuctionStatus() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/auctions/sales/getStatus?auction_id=\(auctionId ?? 0)&card_id=\(cardId ?? 0)", method: .get, parameters: nil, headers: headers).responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(AuctionStatusModel.self, from: response.data!)
                
                if productResponse.code == 200 {
                    //self.acceptRejectView.isHidden = false
                    if productResponse.item?.status == "pending" {
                        self.acceptOfferLabel.text = "You want to accept offer?".localized
                        self.payDoneStack.isHidden = true
                        self.desc24HLabel.isHidden = true
                        self.acceptRejectButtonsStack.isHidden = false
                    }else if productResponse.item?.status == "agree" {
                        
                        self.acceptOfferLabel.text = "Offer accepted".localized
                        self.payDoneStack.isHidden = false
                        self.acceptRejectButtonsStack.isHidden = true
                        self.contactWhatsAppView.isHidden = false
                        self.contactWhatsAppViewHeight.constant = 55
                        self.waitingForAcceptButtonAction.isHidden = false
                        self.waitingForAceptButonHeight.constant = 55
                        self.offerView.isHidden = false
                        self.offerViewHeight.constant = 180
                        
                    }else if productResponse.item?.status == "disagree" {
                        
                        self.acceptOfferLabel.text = "Offer rejected".localized
                        self.desc24HLabel.isHidden = true
                        self.payDoneStack.isHidden = true
                        self.acceptRejectButtonsStack.isHidden = true
                        
                    }else {
                        self.acceptOfferLabel.isHidden = true
                        self.payDoneStack.isHidden = false
                        self.desc24HLabel.isHidden = false
                        self.acceptRejectButtonsStack.isHidden = true
                    }
                    
                }
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    func getLastOffer() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/auctions/sales/lastoffer?auction_id=\(auctionId ?? 0)&card_id=\(cardId ?? 0)", method: .get, parameters: nil, headers: headers).responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(BidModel.self, from: response.data!)
                
                if productResponse.code == 200 {
                    //self.highPriceView.isHidden = false
                    
                    self.bidLabel.text = "\(productResponse.item?.minimumBiding ?? 0)"
                    
                    if Double(productResponse.item?.offer?.price ?? "0.0") ?? 0.0 >= 1000.0 {
                        self.plusMinusDescLabel.text = "The minimum increase is 50 dinars".localized
                        //self.bidLabel.text = "50"
                    }else {
                        self.plusMinusDescLabel.text = "The minimum increase is 10 dinars".localized
                        //self.bidLabel.text = "10"
                        
                    }
                    
                    self.bidMaxPrice = productResponse.item?.offer?.price ?? "0.0" //Double(productResponse.item?.offer?.price ?? "0.0")
                    
                    //self.priceLabel.text = "\(productResponse.item?.offer?.price ?? "0.0")"
                    self.priceLabel.text = "\(productResponse.item?.offer?.price ?? "0.0")"
                    print(productResponse.item?.offer?.price ?? "0.0")
                    //self.bidLabel.text = data.data?.price
                    self.ownerUserImage.loadImage(URLS.baseImageURL+(productResponse.item?.offer?.user?.image ?? ""))
                    self.ownerNameLabel.text = productResponse.item?.offer?.user?.name ?? ""
                    
                    
                    self.lastOfferUserId = productResponse.item?.offer?.user?.id
                    
//                    if productResponse.item?.user.id == HelperConstant.getUserId() {
//                        self.offerView.isHidden = false
//                        self.acceptRejectView.isHidden = false
//                        //self.offerViewHeight.constant = 220 //220
//                        //self.acceptRejectViewHeight.constant = 300
//                    }else {
//                        self.offerView.isHidden = true
//                        self.acceptRejectView.isHidden = true
//                        //self.offerViewHeight.constant = 0
//                        //self.acceptRejectViewHeight.constant = 0
//                    }
                    
                    if productResponse.item?.offer?.user?.id == HelperConstant.getUserId() {
                        self.yourLucklabel.text = "You seem to be the luckiest person to win the auction so far".localized
                        self.yourLuckImage.isHidden = false
                        
                        
                    }else {
                        self.yourLucklabel.text = "Looks like you won't win the auction".localized
                        self.yourLuckImage.isHidden = true
                    }
                    
                    self.getUserBid()
                    
                }
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    func getUserBid() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator() //?user_id=20 //https://hawy-kw.com/api/users/bids?auction_id=10&card_id=3&user_id=20
        AF.request("https://hawy-kw.com/api/users/bids?auction_id=\(auctionId ?? 0)&card_id=\(cardId ?? 0)&user_id=\(HelperConstant.getUserId() ?? 0)", method: .get, parameters: nil, headers: headers).responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(ISUserBidModel.self, from: response.data!)
                
                if productResponse.code == 200 {
                    //self.highPriceView.isHidden = false
                    
                    if productResponse.item == nil {
                        
                        self.congarateView.isHidden = true
                        self.congarateViewHeight.constant = 0
                        self.yourLucklabel.isHidden = true
                        self.yourLuckImage.isHidden = true
                        
                    }else {
                        
                        if productResponse.item?.user?.id == HelperConstant.getUserId() {
                            self.yourLucklabel.text = "You seem to be the luckiest person to win the auction so far".localized
                            self.yourLuckImage.isHidden = false
                            
                            self.congarateView.isHidden = false
                            self.congarateViewHeight.constant = 70
                            
                        }else {
                            self.yourLucklabel.text = "Looks like you won't win the auction".localized
                            self.yourLuckImage.isHidden = true
                            
                            self.congarateView.isHidden = true
                            self.congarateViewHeight.constant = 0
                            
                        }
                    }
                    
                    
                }
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    func performUpdateStatusAgree(status: String?) { //url: String, parameters: [String:Any]
        
        let url = "https://hawy-kw.com/api/auctions/sales/status"
        
        let param: [String: Any] = [
            
            "card_id" : cardId ?? 0,
            "auction_id": auctionId ?? 0,
            "status": status ?? "" //bidLabel.text ?? ""
            
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
            .validate()
        
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
                        let forgetPasswordRequest = try decoder.decode(AuctionAcceptRejectModelModel.self, from: data)
                        print(forgetPasswordRequest)
                        
                        if forgetPasswordRequest.code == 200 {
                            
                            print("success")
                            
                                self.acceptOfferLabel.text = "Offer accepted".localized
                                self.payDoneStack.isHidden = false
                                self.desc24HLabel.isHidden = false
                                self.acceptRejectButtonsStack.isHidden = true
                                self.contactWhatsAppView.isHidden = false
                                self.contactWhatsAppViewHeight.constant = 55
                                //self.offerViewHeight.constant = 300
                                
                            
                            
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
    
    func performUpdateStatusDisAgree(status: String?) { //url: String, parameters: [String:Any]
        
        let url = "https://hawy-kw.com/api/auctions/sales/status"
        
        let param: [String: Any] = [
            
            "card_id" : cardId ?? 0,
            "auction_id": auctionId ?? 0,
            "status": status ?? "" //bidLabel.text ?? ""
            
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
            .validate()
        
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
                        let forgetPasswordRequest = try decoder.decode(AuctionAcceptRejectModelModel.self, from: data)
                        print(forgetPasswordRequest)
                        
                        if forgetPasswordRequest.code == 200 {
                            
                            print("success")
                            
                                self.acceptOfferLabel.text = "Offer rejected".localized
                                self.desc24HLabel.isHidden = true
                                self.payDoneStack.isHidden = true
                                self.acceptRejectButtonsStack.isHidden = true
                            
                            
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
    
    func performUpdateStatusPayDone(status: String?) { //url: String, parameters: [String:Any]
        
        let url = "https://hawy-kw.com/api/auctions/sales/status"
        
        let param: [String: Any] = [
            
            "card_id" : cardId ?? 0,
            "auction_id": auctionId ?? 0,
            "status": status ?? "" //bidLabel.text ?? ""
            
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
            .validate()
        
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
                        let forgetPasswordRequest = try decoder.decode(AuctionAcceptRejectModelModel.self, from: data)
                        print(forgetPasswordRequest)
                        
                        if forgetPasswordRequest.code == 200 {
                            
                            print("success")
                            
                                self.acceptOfferLabel.text = "Pay done".localized
                                self.desc24HLabel.isHidden = true
                                self.payDoneStack.isHidden = true
                                self.acceptRejectButtonsStack.isHidden = true
                            
                            
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
    
    @IBAction func plusButtonAction(_ sender: Any) {
        
        
        
        if Double(bidMaxPrice ?? "0.0") ?? 0.0 >= 1000.0 {
            plusMinusDescLabel.text = "The minimum increase is 50 dinars".localized
            let plus = (Int(bidLabel.text ?? "") ?? 0) + 50
            bidLabel.text = "\(plus)"
        }else {
            plusMinusDescLabel.text = "The minimum increase is 10 dinars".localized
            let plus = (Int(bidLabel.text ?? "") ?? 0) + 10
            bidLabel.text = "\(plus)"
        }
        
        
        
    }
    @IBAction func minusButtonAction(_ sender: Any) {
        
        
        
        let plus = (Int(bidLabel.text ?? "") ?? 0) - 10
        
        if (Int(bidLabel.text ?? "") ?? 0) <= 10 { //plus <= 0
            
        }else {
            
            if Double(bidMaxPrice ?? "0.0") ?? 0.0 >= 1000.0 {
                
                if (Int(bidLabel.text ?? "") ?? 0) <= 50 {
                    
                }else {
                    plusMinusDescLabel.text = "The minimum increase is 50 dinars".localized
                    let plus = (Int(bidLabel.text ?? "") ?? 0) - 50
                    bidLabel.text = "\(plus)"
                }
                
                
            }else {
                plusMinusDescLabel.text = "The minimum increase is 10 dinars".localized
                let plus = (Int(bidLabel.text ?? "") ?? 0) - 10
                bidLabel.text = "\(plus)"
            }
            
            //bidLabel.text = "\(plus)"
            
        }
        
        
        
    }
    @IBAction func addBidButtonAction(_ sender: Any) {
        performRequest()
    }
    @IBAction func backToHomeButtonAction(_ sender: Any) {
        
        let story = UIStoryboard(name: "HawyTabbar", bundle:nil)
        let vc = story.instantiateViewController(withIdentifier: "HawyTabbarController") as! HawyTabbarController
        UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
    }
    @IBAction func waitingForAcceptButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func whtsAppButtonAction(_ sender: Any) {
        
        let phoneNumber = self.phoneNumber
        let appURL = URL(string: "https://wa.me/\(phoneNumber)")!
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appURL)
            }
        }
        
    }
    
    @IBAction func extendTimeButtonAction(_ sender: Any) {
        
        let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "ExtendTimeViewController") as! ExtendTimeViewController
        VC.height = 600 //self.view.frame.height - 100
        VC.topCornerRadius = 8
        VC.presentDuration = 0.5
        VC.dismissDuration = 0.5
        VC.popupDelegate = self
        
        VC.auctionId = auctionId
        VC.cardId = cardId
        
        self.present(VC, animated: true, completion: nil)
        
    }
    
    @IBAction func acceptButtonAction(_ sender: Any) {
        
        performUpdateStatusAgree(status: "agree")
        
    }
    
    @IBAction func rejectButtonOutlet(_ sender: Any) {
        
        performUpdateStatusDisAgree(status: "disagree")
        
    }
    
    @IBAction func payDoneButtonOutlet(_ sender: Any) {
        
        performUpdateStatusPayDone(status: "confirm_payment_and_delivery")
        
    }
    
    @IBAction func VaccinationsTapped(_ sender: Any) {
        
        let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "CardVaccinationsViewController") as? CardVaccinationsViewController
        VC?.cardId = cardId
        navigationController?.pushViewController(VC!, animated: false)
        
    }
    @IBAction func ownersTapped(_ sender: Any) {
        
        let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "CardOwnersViewController") as? CardOwnersViewController
        VC?.cardId = cardId
        navigationController?.pushViewController(VC!, animated: false)
        
    }
    
    @IBAction func infoTapped(_ sender: Any) {
        
        let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "CardInfoViewController") as? CardInfoViewController
        VC?.cardId = cardId
        navigationController?.pushViewController(VC!, animated: false)
        
    }
    
    
    @objc func changeImage() {
        
        //slider.count
        if counter < 5 {
            let index = IndexPath.init(item: counter, section: 0)
            self.saleAuctionProductBannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.saleAuctionProductBannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageControl.currentPage = counter
            counter = 1
        }
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension AuctionProductDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = saleAuctionProductBannerCollectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryDetailsCollectionViewCell", for: indexPath) as? SubCategoryDetailsCollectionViewCell else { return UICollectionViewCell() }
        let item = images[indexPath.row]
        cell.imageOutlet.loadImage(URLS.baseImageURL+(item))
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = saleAuctionProductBannerCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.saleAuctionProductBannerCollectionView.contentOffset, size: self.saleAuctionProductBannerCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.saleAuctionProductBannerCollectionView.indexPathForItem(at: visiblePoint) {
            self.pageControl.currentPage = visibleIndexPath.row
        }
    }
    
}

extension AuctionProductDetailsViewController {
    
    //MARK:- SetUp startOtpTimer
    public func startOtpTimer() {
        
        self.totalTime = finalTotal
        
        self.timer2 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    //MARK:- SetUp updateTimer
    @objc func updateTimer() {
        
        print(self.totalTime)
        print(self.timeFormatted(self.totalTime))
        
        if self.totalTime <= 0 {
            self.timerLabel.text = "00 : 00 : 00"
            self.clockImage.image = UIImage(named: "asset-2")
            self.timer2?.invalidate()
            
            extendTimeButtonOutlet.isHidden = true
            payDoneStack.isHidden = true
            payDoneButtonOutlet.isHidden = true
            
            if self.isOwnerId == HelperConstant.getUserId() {
                self.offerView.isHidden = true
                self.acceptRejectView.isHidden = false
                self.offerViewHeight.constant = 0 //220
                self.acceptRejectViewHeight.constant = 250
                self.waitingForAcceptButtonAction.isHidden = false
                self.waitingForAceptButonHeight.constant = 55
                self.contactWhatsAppView.isHidden = false
                self.contactWhatsAppViewHeight.constant = 55
                
                self.congarateView.isHidden = true
                self.congarateViewHeight.constant = 0
                self.biddingView.isHidden = true
                self.yourLucklabel.isHidden = true
                self.yourLuckImage.isHidden = true
                self.biddingViewHeight.constant = 0
                
                if self.bidCounter == 0 {
                    
                    self.acceptRejectView.isHidden = true
                    self.acceptRejectViewHeight.constant = 0
                    
                }else {
                    
                    self.acceptRejectView.isHidden = false
                    self.acceptRejectViewHeight.constant = 250
                    
                }
                
            }else {
                self.offerView.isHidden = false
                self.acceptRejectView.isHidden = true
                self.offerViewHeight.constant = 130
                self.acceptRejectViewHeight.constant = 0
                
                //self.congarateView.isHidden = false
                //self.congarateViewHeight.constant = 70
                self.biddingView.isHidden = false
                self.yourLucklabel.isHidden = false
                self.yourLuckImage.isHidden = false
                self.biddingViewHeight.constant =  210 //230
                
            }
            
            self.backToHomeButton.isHidden = false
            self.backToHomeView.isHidden = false
            self.backToHomeViewHeight.constant = 55
            self.plusButtonOutlet.isEnabled = false
            self.minusButtonOutlet.isEnabled = false
            self.addBidButton.isHidden = true
            //self.getCardData(id: cardId, userId: HelperConstant.getUserId() ?? 0)
            self.getLastOffer()
            self.getAuctionStatus()
            
            self.contactWhatsAppView.isHidden = false
            self.contactWhatsAppViewHeight.constant = 55
            self.waitingForAcceptButtonAction.isHidden = false
            self.waitingForAceptButonHeight.constant = 55
            
            if self.lastOfferUserId == HelperConstant.getUserId() {
                self.winView.isHidden = false
            }else {
                self.winView.isHidden = true
            }
            
        }else if self.totalTime <= 2700 {
            
            self.timerLabel.labelFlash()
            
            if self.isStockAuction == true {
                
                self.extendTimeButtonOutlet.isHidden = true
                
            }else {
                
                self.extendTimeButtonOutlet.isEnabled = true
                
                self.extendTimeButtonOutlet.setTitleColor(.white, for: .normal)
                
                self.extendTimeButtonOutlet.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                self.extendTimeButtonOutlet.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                self.extendTimeButtonOutlet.gradientLayer.colors = [DesignSystem.Colors.PrimaryLightBlue.color.cgColor, DesignSystem.Colors.PrimaryOrange.color.cgColor]
                
            }
            
            if self.isOwnerId == HelperConstant.getUserId() {
                self.offerView.isHidden = true
                self.acceptRejectView.isHidden = true
                self.offerViewHeight.constant = 0 //220
                self.acceptRejectViewHeight.constant = 0
                
                self.congarateView.isHidden = true
                self.congarateViewHeight.constant = 0
                self.biddingView.isHidden = true
                self.yourLucklabel.isHidden = true
                self.yourLuckImage.isHidden = true
                self.biddingViewHeight.constant = 0
                
            }else {
                self.offerView.isHidden = true
                self.acceptRejectView.isHidden = true
                self.offerViewHeight.constant = 0
                self.acceptRejectViewHeight.constant = 0
                
                self.congarateView.isHidden = false
                self.congarateViewHeight.constant = 70
                self.biddingView.isHidden = false
                self.yourLucklabel.isHidden = false
                self.yourLuckImage.isHidden = false
                self.biddingViewHeight.constant =  210 //230
                
            }
            
            self.timerLabel.text = self.timeFormatted(self.totalTime)
            self.timerLabel.textColor = DesignSystem.Colors.PrimaryDarkRed.color
            self.clockImage.image = UIImage(named: "asset-2")
            totalTime -= 1
        }else {
            
            if self.isStockAuction == true {
                
                self.extendTimeButtonOutlet.isHidden = true
                
            }else {
                
                self.extendTimeButtonOutlet.isEnabled = false
                
                self.extendTimeButtonOutlet.setTitleColor(.black, for: .normal)
                
                self.extendTimeButtonOutlet.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                self.extendTimeButtonOutlet.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                self.extendTimeButtonOutlet.gradientLayer.colors = [DesignSystem.Colors.ButtonBG.color.cgColor, DesignSystem.Colors.ButtonBG.color.cgColor]
                
            }
            
            if self.isOwnerId == HelperConstant.getUserId() {
                self.offerView.isHidden = true
                self.acceptRejectView.isHidden = true
                self.offerViewHeight.constant = 0 //220
                self.acceptRejectViewHeight.constant = 0
                
                self.congarateView.isHidden = true
                self.congarateViewHeight.constant = 0
                self.biddingView.isHidden = true
                self.yourLucklabel.isHidden = true
                self.yourLuckImage.isHidden = true
                self.biddingViewHeight.constant = 0
                
            }else {
                self.offerView.isHidden = true
                self.acceptRejectView.isHidden = true
                self.offerViewHeight.constant = 0
                self.acceptRejectViewHeight.constant = 0
                
                //self.congarateView.isHidden = false
                //self.congarateViewHeight.constant = 70
                self.biddingView.isHidden = false
                self.yourLucklabel.isHidden = false
                self.yourLuckImage.isHidden = false
                self.biddingViewHeight.constant = 210
                
            }
            
            self.timerLabel.text = self.timeFormatted(self.totalTime) // will show timer
            self.timerLabel.textColor = DesignSystem.Colors.PrimaryBlack.color
            self.clockImage.image = UIImage(systemName: "clock.fill")
            
            totalTime -= 1
            
        }
        
    }
    //MARK:- SetUp timeFormatted
    func timeFormatted(_ totalSeconds: Int) -> String {
        
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hour: Int = totalSeconds / 3600
        
        return hour > 0 ? String(format: "%02d:%02d:%02d", hour, minutes, seconds) : String(format: "%02d:%02d", minutes, seconds)
        
    }
    
}


// MARK: - AddSaleAuctionModel
struct RealTimeModel: Codable {
    let data: RealTimeItem?
}

// MARK: - Item
struct RealTimeItem: Codable {
    let minimumBiding: Int?
    let offer: RealTimeOffer?

    enum CodingKeys: String, CodingKey {
        case minimumBiding = "minimum_biding"
        case offer
    }
}

// MARK: - Offer
struct RealTimeOffer: Codable {
    let id, userID, cardID, auctionID: Int?
    let createdAt, updatedAt, deletedAt: String?
    let price: String?
    let currency: String?
    let minimumBidding: Double?
    let user: RealTimeUser?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case cardID = "card_id"
        case auctionID = "auction_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case price, currency
        case minimumBidding = "minimum_bidding"
        case user
    }
}

// MARK: - User
struct RealTimeUser: Codable {
    let id: Int?
    let name, mobile, phoneCode, image: String?
    let fcmToken: String?

    enum CodingKeys: String, CodingKey {
        case id, name, mobile
        case phoneCode = "phone_code"
        case image
        case fcmToken = "fcm_token"
    }
}

// MARK: - AddSaleAuctionModel
struct ISUserBidModel: Codable {
    let code: Int?
    let message: String?
    let item: ISUserBidItem?
}

// MARK: - Item
struct ISUserBidItem: Codable {
    let id, userID, cardID, auctionID: Int?
    let createdAt, updatedAt, deletedAt: String?
    let price: String?
    let dollar, currency: String?
    let user: ISUserBidUser?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case cardID = "card_id"
        case auctionID = "auction_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case price, dollar, currency, user
    }
}

// MARK: - User
struct ISUserBidUser: Codable {
    let id: Int?
    let name, mobile, phoneCode, image: String?
    let fcmToken: String?

    enum CodingKeys: String, CodingKey {
        case id, name, mobile
        case phoneCode = "phone_code"
        case image
        case fcmToken = "fcm_token"
    }
}

struct UpdateTime: Codable {
    let auction_id: Int?
    let card_id: String?
    let end_date: Int?
}

//// MARK: - AddSaleAuctionModel
//struct RealTimeModel: Codable {
//    let data: RealTimeData?
//}
//
//// MARK: - DataClass
//struct RealTimeData: Codable {
//    let id, userID, cardID, auctionID: Int?
//    let createdAt, updatedAt, deletedAt, price: String?
//    let user: RealTimeUser?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case userID = "user_id"
//        case cardID = "card_id"
//        case auctionID = "auction_id"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case deletedAt = "deleted_at"
//        case price, user
//    }
//}
//
//// MARK: - User
//struct RealTimeUser: Codable {
//    let id: Int?
//    let name, email, mobile, phoneCode: String?
//    let packageID: Int?
//    let emailVerifiedAt, image, paymentMethod, type: String?
//    let otp, createdAt, updatedAt: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, email, mobile
//        case phoneCode = "phone_code"
//        case packageID = "package_id"
//        case emailVerifiedAt = "email_verified_at"
//        case image
//        case paymentMethod = "payment_method"
//        case type, otp
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}

extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970)
    }
}
