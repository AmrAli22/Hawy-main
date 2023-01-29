//
//  CardOwnersViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 10/10/2022.
//

import UIKit
import Alamofire

class CardOwnersViewController: BaseViewViewController {
    
    @IBOutlet weak var collectionContainer: UIView!
    @IBOutlet weak var cardOwnersTableView: UITableView! {
        didSet {
            cardOwnersTableView.separatorStyle = .none
            //salesAuctionTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
            
            cardOwnersTableView.register(UINib(nibName: "CardOwnersTableViewCell", bundle: nil), forCellReuseIdentifier: "CardOwnersTableViewCell")
            cardOwnersTableView.dataSource = self
            cardOwnersTableView.delegate = self
        }
    }
    
    @IBOutlet weak var emptyView: UIView!
    
    var owners = [ShowCardDetailsInoculation]()
    
    var cardId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCardData(id: cardId, userId: HelperConstant.getUserId() ?? 0)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionContainer.roundCorners([.topLeft, .topRight], radius: 20)
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
        AF.request("https://hawy-kw.com/api/auth/profile/cards/show?id=\(id ?? 0)&user_id=\(userId ?? 0)", method: .get, parameters: nil, headers: headers)
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
                    self.owners = productResponse.item?.owners ?? []
                    self.cardOwnersTableView.reloadData()
                    
                    if self.owners.isEmpty == true {
                        self.emptyView.isHidden = false
                    }else {
                        self.emptyView.isHidden = true
                    }
                    
                }
                
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    @IBAction func backToCardButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension CardOwnersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return owners.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = cardOwnersTableView.dequeueReusableCell(withIdentifier: "CardOwnersTableViewCell", for: indexPath) as? CardOwnersTableViewCell else { return UITableViewCell() }
        
        let item = owners[indexPath.row]
        
        cell.titleLabel.text = item.name ?? ""
        
        if indexPath.row == owners.count - 1 {
            cell.lineView.isHidden = true
        }else {
            cell.lineView.isHidden = false
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = owners[indexPath.row]
        
        let storyborad = UIStoryboard(name: "HawyTabbar", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
        VC?.myProfile = false
        VC?.ownerId = item.id
//        VC?.newName = newName
//        VC?.newPhone = newPhone
//        VC?.newImage = newImage
//        VC?.newCode = newCode
//        print(newOwner)
        present(VC!, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

