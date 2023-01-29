//
//  NotificationViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 04/11/2022.
//

import UIKit
import Alamofire

class NotificationViewController: BaseViewViewController {
    
    @IBOutlet weak var notificationTableView: UITableView!
    
    var notification = [NotificationItem]()
    
    var notificationReverse = [NotificationItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationTableView.delegate = self
        notificationTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNotification()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func getNotification() { //url: String, parameters: [String:Any]
        
        let url = "https://hawy-kw.com/api/notifications"
        
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
                        let forgetPasswordRequest = try decoder.decode(NotificationModel.self, from: data)
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
                            
                            self.notification = forgetPasswordRequest.item?.reversed() ?? []
                            self.notificationReverse = self.notification.reversed()
                            self.notificationTableView.reloadData()
                            
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
    
    
}

extension NotificationViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationReverse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = notificationTableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as? NotificationTableViewCell else { return UITableViewCell() }
        
        let item = notificationReverse[indexPath.row]
        
        
        cell.titleLabel.text = item.title
        cell.dateLabel.text = item.createdAt
        cell.auctionLabel.text = item.type
        
        if item.type == "salse" {
            
            cell.auctionLabel.textColor = DesignSystem.Colors.PrimaryBlue.color
            cell.auctionImage.image = UIImage(named: "Search results for Auctions - Flaticon-2")
            cell.userImageOutlet.loadImage(URLS.baseImageURL+(item.image ?? ""))
            
        }else if item.type == "live" {
            
            cell.auctionLabel.textColor = DesignSystem.Colors.PrimaryDarkRed.color
            cell.auctionImage.image = UIImage(named: "Live - Free technology icons-2")
            cell.userImageOutlet.loadImage(URLS.baseImageURL+(item.image ?? ""))
            
        }else if item.type == "ad" {
            
            cell.auctionLabel.textColor = .systemPurple
            cell.auctionImage.image = UIImage(named: "")
            cell.userImageOutlet.loadImage(URLS.baseImageURL+(item.image ?? ""))
            
        }else if item.type == "stock" {
            
            cell.auctionLabel.textColor = DesignSystem.Colors.PrimaryGreen.color
            cell.auctionImage.image = UIImage(named: "Search results for Auction - Flaticon-2 (1)")
            cell.userImageOutlet.image = UIImage(named: "stock2")
            cell.userImageOutlet.contentMode = .scaleToFill
            
        }else if item.type == "package" {
            
            cell.auctionLabel.textColor = DesignSystem.Colors.PrimaryBlack.color
            cell.auctionImage.image = UIImage(named: "Search results for Auction - Flaticon-2 (1)")
            cell.userImageOutlet.image = UIImage(named: "stock2")
            cell.userImageOutlet.contentMode = .scaleAspectFit
            
        }else {
            
            cell.auctionLabel.textColor = DesignSystem.Colors.PrimaryOrange.color
            cell.auctionImage.image = UIImage(named: "Mask Group 69")
            cell.userImageOutlet.image = UIImage(named: "transfer")
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = notificationReverse[indexPath.row]
        
        if item.type == "salse" {
            
            let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
            let VC = storyborad.instantiateViewController(withIdentifier: "SalesAuctionsProductsViewController") as? SalesAuctionsProductsViewController
            
            print(indexPath.row)
            
            VC?.titleType = 0
            VC?.auctionId = item.auction_id
            
            navigationController?.pushViewController(VC!, animated: false)
            
        }else if item.type == "live" {
            
            let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
            let VC = storyborad.instantiateViewController(withIdentifier: "SalesAuctionsProductsViewController") as? SalesAuctionsProductsViewController
            
            print(indexPath.row)
            VC?.isLive = true
            
            VC?.auctionId = item.auction_id
            VC?.titleType = 1
            
            navigationController?.pushViewController(VC!, animated: false)
            
        }else if item.type == "ad" {
            
            let storyborad = UIStoryboard(name: "Profile", bundle: nil)
            let VC = storyborad.instantiateViewController(withIdentifier: "ShowAddedCardDetailsViewController") as? ShowAddedCardDetailsViewController
            VC?.cardId = item.card
            //VC?.myProfile = self.myProfile
            navigationController?.pushViewController(VC!, animated: false)
            
        }else if item.type == "package" {
            
        }else if item.type == "stock" {
            
            let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
            let VC = storyborad.instantiateViewController(withIdentifier: "SalesAuctionsProductsViewController") as? SalesAuctionsProductsViewController
            
            print(indexPath.row)
            
            print(item.auction_id)
            VC?.auctionId = item.auction_id
            
            VC?.titleType = 2
            
            navigationController?.pushViewController(VC!, animated: false)
            
        }else if item.type == "ownership" {
            
            let storyborad = UIStoryboard(name: "Notifications", bundle: nil)
            let VC = storyborad.instantiateViewController(withIdentifier: "AcceptTranseferOwnerShipViewController") as? AcceptTranseferOwnerShipViewController
            
            VC?.cardId = item.card
            VC?.desc = item.message
            VC?.date = item.createdAt
            VC?.screenTitle = item.title
            
            navigationController?.pushViewController(VC!, animated: false)
            
        }else {
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
