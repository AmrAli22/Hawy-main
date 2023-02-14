//
//  LiveAuctionsViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 14/08/2022.
//

import UIKit
import Alamofire

class LiveAuctionsViewController: BaseViewViewController {
    
    @IBOutlet weak var currentView: UIView!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var currentButtonOutlet: UIButton!
    @IBOutlet weak var commingView: UIView!
    @IBOutlet weak var commingLabel: UILabel!
    @IBOutlet weak var commingButtonOutlet: UIButton!
    @IBOutlet weak var collectionContainer: UIView!
    @IBOutlet weak var liveAuctionTableView: UITableView! {
        didSet {
            liveAuctionTableView.separatorStyle = .none
            //salesAuctionTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
            
            liveAuctionTableView.register(UINib(nibName: "LiveAuctionsTableViewCell", bundle: nil), forCellReuseIdentifier: "LiveAuctionsTableViewCell")
            liveAuctionTableView.dataSource = self
            liveAuctionTableView.delegate = self
        }
    }
    
    @IBOutlet weak var emptyView: UIView!
    
    let firstColor = DesignSystem.Colors.PrimaryBlue.color
    let secondColor = DesignSystem.Colors.PrimaryOrange.color
    
    var nowORnot = true
    var auctionData = [LiveAuctionItem]()
    
    var auction_id : Int?
    var card_id : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentView.setGradient(firstColor: firstColor, secondColor: secondColor)
        DispatchQueue.main.async {
            self.commingView.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
            self.currentLabel.textColor = .white
            self.commingLabel.textColor = .black
        }
        
        getLiveCommingAuctions(type: "now")
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionContainer.roundCorners([.topLeft, .topRight], radius: 20)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func currentButtonAction(_ sender: Any) {
        
        currentView.setGradient(firstColor: firstColor, secondColor: secondColor)
        DispatchQueue.main.async {
            self.commingView.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
            self.currentLabel.textColor = .white
            self.commingLabel.textColor = .black
        }
        getLiveNowAuctions(type: "now")
    }
    
    @IBAction func commingButtonAction(_ sender: Any) {
        
        commingView.setGradient(firstColor: firstColor, secondColor: secondColor)
        DispatchQueue.main.async {
            self.currentView.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
            self.currentLabel.textColor = .black
            self.commingLabel.textColor = .white
        }
        
        getLiveCommingAuctions(type: "coming")
        
    }
    
}

extension LiveAuctionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
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
        return auctionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = liveAuctionTableView.dequeueReusableCell(withIdentifier: "LiveAuctionsTableViewCell", for: indexPath) as? LiveAuctionsTableViewCell else { return UITableViewCell() }
        
        let item = auctionData[indexPath.row]
        
        cell.titleLabel.text = item.name ?? ""
        cell.nameLabel.text = item.user ?? ""
        
        let endTime = (item.endDate ?? 0)
        let currentTime = Int(Date.currentTimeStamp)
        
        //cell.dateLabel.text = "\(item?.startDate ?? 0)"
        let formatter3 = DateFormatter()
        formatter3.dateFormat = " dd-MM-yyyy"
        print(formatter3.string(from: Date(timeIntervalSince1970: TimeInterval(item.startDate ?? 0))))
        cell.dateLabel.text = formatter3.string(from: Date(timeIntervalSince1970: TimeInterval(item.startDate ?? 0)))
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = auctionData[indexPath.row]

        //MARK: -TodayWORKHERE
        
//        let VC = AuctionLiveVideo()
//        VC.auctionID = item.id
//        navigationController?.pushViewController(VC, animated: false)
  
//        let story = UIStoryboard(name: "Auctions", bundle:nil)
//        let vc = story.instantiateViewController(withIdentifier: "ChoseCardToStartBid") as! ChoseCardToStartBid
        
        let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "SalesAuctionsProductsViewController") as? SalesAuctionsProductsViewController
        
        print(indexPath.row)
        VC?.isLive = true
        
        VC?.auctionId = item.id
        VC?.titleType = 1
        
        navigationController?.pushViewController(VC!, animated: false)
        
        
//        vc.auction_ID = item.id
//        navigationController?.pushViewController(vc, animated: false)
    }
    
}

extension LiveAuctionsViewController {
    
    func getLiveCommingAuctions(type: String?) {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator() //
        AF.request("https://hawy-kw.com/api/auctions/live?auction_date=\(type ?? "")&time_from=\(Int(Date.currentTimeStamp))", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(LiveAuctionModel.self, from: response.data!)
                
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
                    
                    if self.auctionData.isEmpty == true {
                        
                   //     self.emptyView.isHidden = false
                    }else {
                        self.emptyView.isHidden = true
                    }
                    
                    self.liveAuctionTableView.reloadData()
                    
                }
                self.hideIndecator()
            } catch let error{
                print("error\(error)")
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    func getLiveNowAuctions(type: String?) {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")"
        ]
        
        showIndecator() //
        AF.request("https://hawy-kw.com/api/auctions/live?auction_date=\(type ?? "")&time_from=\(Int(Date.currentTimeStamp))", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(LiveAuctionModel.self, from: response.data!)
                
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
                    
                    if self.auctionData.isEmpty == true {
                        
                    //    self.emptyView.isHidden = false
                    }else {
                        self.emptyView.isHidden = true
                    }
                    
                    self.liveAuctionTableView.reloadData()
                    
                }
                self.hideIndecator()
            } catch let error{
                print("error\(error)")
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
}
