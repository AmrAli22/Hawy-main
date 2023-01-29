//
//  ChoseCardToStartBid.swift
//  Hawy
//
//  Created by Amr Ali on 20/01/2023.
//


import UIKit
import Combine
import Alamofire
import PusherSwift

class ChoseCardToStartBid: BaseViewViewController, PusherDelegate {
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var conductorType: UILabel!
    @IBOutlet weak var intialPrice: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            collectionView.collectionViewLayout = layout
                    collectionView.dataSource = self
                    collectionView.delegate = self

            
            collectionView.register(UINib(nibName: "ChoseCardToStartCardCell", bundle: nil), forCellWithReuseIdentifier: "ChoseCardToStartCardCell")
            
        }
    }

    var index = -1
    var arrayInt: [Int] = []
    
    var subscriber = Set<AnyCancellable>()
    
    var maxCards: Int?
    var liveCardId: Int?
    var live: Bool?
    
    var type: Int?
    
    var catID: Int?
    var auction_ID : Int?
    
    var pusher: Pusher!
    var pusherTime: Pusher!
    var bidPusher: Pusher!
    let decoder = JSONDecoder()
    
    private var viewModel = ProfileViewModel()
    var cardData = [Card]()

    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    @objc
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getCardsData()
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
    
    func getCardsData() {
        
        var auction_ID = self.auction_ID ?? 0
        var user_ID = HelperConstant.getUserId() ?? 0
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")"
        ]
        
        //showIndecator() //?user_id=20
        let url = "https://hawy-kw.com/api/auctions/sales/show?auction_id=\(auction_ID)&user_id=\(user_ID)"
        AF.request(url, method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(AuctionDataToSelectCard.self, from: response.data!)
                
                print("PRODUCTREPSOSNKS \(productResponse)")
                
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
                
                self.cardData = productResponse.item?.cards ?? []
                self.name.text = productResponse.item?.name
                self.conductorType.text = productResponse.item?.conductedBy
                self.intialPrice.text = "Intial Price : \(productResponse.item?.openPrice ?? "0.0")"
                //self.userImage.loadImage("\(productResponse.item?.owner?.image)")
                self.userImage.loadImage(URLS.baseImageURL+(productResponse.item?.owner?.image ?? ""))
                let date = Date(timeIntervalSince1970: Double(productResponse.item?.startDate ?? 0))
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
                dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
                let strDate = dateFormatter.string(from: date)
                
                
                self.dateTimeLabel.text = strDate
                self.collectionView.reloadData()
                self.listenToChangesFromUSDPusher(auction_id: auction_ID)
                self.listenToChangesFromKWDPusher(auction_id: auction_ID)
            }  catch let parseError {
                
                print("JSON Error \(parseError.localizedDescription)")
            }
        }
    }
    
 
    
    @IBAction func addCardsButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
      
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        //backData?(cardData, liveCardId)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ChoseCardToStartBid: UICollectionViewDelegate, UICollectionViewDataSource  , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       let width = ((collectionView.frame.width - 10 ) / 2)
       return CGSize(width: width, height: 160)
   }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("CardDataCount\(cardData.count)")
        return cardData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChoseCardToStartCardCell", for: indexPath) as! ChoseCardToStartCardCell

        
        let item = cardData[indexPath.row]
        cell.NameOfCard.text = item.name
        cell.costOfCard.text = (item.price ?? "0") + " " + (item.currency ?? "USD")
        cell.CardImage.loadImage(URLS.baseImageURL+(item.mainImage ?? ""))
        cell.isConductorHere = item.conductorAvailable ?? false
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
                let VC = AuctionLiveVideo()
                VC.auctionID = cardData[indexPath.row].id
                navigationController?.pushViewController(VC, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
     }
   
    func listenToChangesFromUSDPusher(auction_id: Int?) {
       
       print("auction_id: \(auction_id)")
       // Instantiate Pusher
       bidPusher = Pusher(
           key: "65b581feebecaee4af62",
           options: PusherClientOptions(host: .cluster("eu"))
       )
       
       // Subscribe to a pusher channel
       let channel = bidPusher.subscribe("auction.\(auction_id ?? 0)")
       
       bidPusher.delegate = self
       
       bidPusher.connect()
       
       // Bind to an event called "order-event" on the event channel and fire
       // the callback when the event is triggerred
       
       let eventNamee = #"App\Events\ApiDataListener"#
       print("App\\Events\\ApiDataListener")
       
       print(eventNamee)
       
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
           //let decoded = try? self.decoder.decode(RealTimeModel.self, from: jsonData)
//           guard let data = decoded else {
//               print("Could not decode message")
//               return
//           }
           
           self.getCardsData()
//           self.view.layoutIfNeeded()
//           self.cardsTableViewHeight.constant = self.cardsTableView.contentSize.height
//           self.view.layoutIfNeeded()
           
       //    print("\(data.data) says \(data.data)")
           
       })
       
   }
    
    
    func listenToChangesFromKWDPusher(auction_id: Int?) {
       
       print("auction_id: \(auction_id)")
       // Instantiate Pusher
       bidPusher = Pusher(
           key: "65b581feebecaee4af62",
           options: PusherClientOptions(host: .cluster("eu"))
       )
       
       // Subscribe to a pusher channel
       let channel = bidPusher.subscribe("auction.\(auction_id ?? 0)")
       
       bidPusher.delegate = self
       
       bidPusher.connect()
       
       // Bind to an event called "order-event" on the event channel and fire
       // the callback when the event is triggerred
       
       let eventNamee = #"App\Events\ApiDataListener"#
       print("App\\Events\\ApiDataListener")
       
       print(eventNamee)
       
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
           //let decoded = try? self.decoder.decode(RealTimeModel.self, from: jsonData)
//           guard let data = decoded else {
//               print("Could not decode message")
//               return
//           }
           
           self.getCardsData()
           
       //    print("\(data.data) says \(data.data)")
           
       })
       
   }
    
    
    
    
}
