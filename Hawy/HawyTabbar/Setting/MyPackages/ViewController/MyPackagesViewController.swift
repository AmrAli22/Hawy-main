//
//  MyPackagesViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 01/11/2022.
//

import UIKit
import Alamofire

class MyPackagesViewController: BaseViewViewController {
    
    //@IBOutlet weak var packageTableView: UITableView!
    
     //var packages = [MyPackagesItem]()
    
    @IBOutlet weak var packageTitle: UILabel!
    @IBOutlet weak var enddataTitle: UILabel!
    @IBOutlet weak var categoriesTitle: UILabel!
    @IBOutlet weak var numberOfCategory: UILabel!
    @IBOutlet weak var categoriesNumber: UILabel!
    @IBOutlet weak var categoriesDate: UILabel!
    @IBOutlet weak var categoriesPrice: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //packageTableView.dataSource = self
        //packageTableView.delegate = self
        
        performPackage()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.roundCorners([.topLeft, .topRight], radius: 20)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func renewButtonTapped(_ sender: Any) {
        let stroyboard = UIStoryboard(name: "Subscriptions", bundle: nil)
        let VC = stroyboard.instantiateViewController(withIdentifier: "PaymetViewController") as? PaymetViewController
        self.navigationController?.pushViewController(VC!, animated: true)
    }
    
    @IBAction func changeButtonTapped(_ sender: Any) {
        
        let stroyboard = UIStoryboard(name: "Subscriptions", bundle: nil) //HawyTabbar //Subscriptions
        let VC = stroyboard.instantiateViewController(withIdentifier: "SubscriptionsViewController") as? SubscriptionsViewController //HawyTabbarController //SubscriptionsViewController
        self.navigationController?.pushViewController(VC!, animated: true)
        
    }
    
    
    func performPackage() { //url: String, parameters: [String:Any]
        
        let url = "https://hawy-kw.com/api/packages/subscribe"
        
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
                        let forgetPasswordRequest = try decoder.decode(MyPackagesModel.self, from: data)
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
                            
                            self.packageTitle.text = forgetPasswordRequest.item?.name
                            self.enddataTitle.text = forgetPasswordRequest.item?.expiredDate
                            self.categoriesTitle.text = "\(forgetPasswordRequest.item?.categoeies?.compactMap{ $0.name }.joined(separator: "-") ?? "")"
                            self.numberOfCategory.text = "\(forgetPasswordRequest.item?.categoryNumber ?? "")"
                            self.categoriesNumber.text = "categories".localized
                            self.categoriesDate.text = "\(Int(forgetPasswordRequest.item?.duration ?? 0) * 30)  " + "day".localized
                            self.categoriesPrice.text = "\(forgetPasswordRequest.item?.price ?? "0.0")  " + (HelperConstant.getCurrency() ?? "K.D") //"K.D".localized
                            
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

//extension MyPackagesViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        guard let cell = packageTableView.dequeueReusableCell(withIdentifier: "MyPackagesTableViewCell", for: indexPath) as? MyPackagesTableViewCell else { return UITableViewCell() }
//
//        cell.packageTitle.text = ""
//        cell.enddataTitle.text = ""
//        cell.categoriesTitle.text = ""
//        cell.categoriesNumber.text = ""
//        cell.categoriesDate.text = ""
//        cell.categoriesPrice.text = ""
//
//        return cell
//
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 170
//    }
//
//}

// MARK: - AddSaleAuctionModel
struct MyPackagesModel: Codable {
    let code: Int?
    let message: String?
    let item: MyPackagesItem?
}

// MARK: - Item
struct MyPackagesItem: Codable {
    let id: Int?
    let name, itemDescription, star: String?
    let duration: Int?
    let expiredDate, categoryNumber: String?
    let price: String?
    let categoeies: [MyPackagesCategoey]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case itemDescription = "description"
        case star, duration, price
        case expiredDate = "expired_date"
        case categoryNumber = "category_number"
        case categoeies
    }
}

// MARK: - Categoey
struct MyPackagesCategoey: Codable {
    let id: Int?
    let name, color: String?
    let image: String?
    let hasSub, hasSubscription: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, color, image
        case hasSub = "has_sub"
        case hasSubscription = "has_subscription"
    }
}
