//
//  AcceptTranseferOwnerShipViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 23/12/2022.
//

import UIKit
import Alamofire

class AcceptTranseferOwnerShipViewController: BaseViewViewController {
    
    @IBOutlet weak var titleLAbel: UILabel!
    @IBOutlet weak var dateLAbel: UILabel!
    @IBOutlet weak var descTV: UITextView!
    
    var cardId: Int?
    
    var screenTitle: String?
    var desc: String?
    var date: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLAbel.text = screenTitle
        dateLAbel.text = date
        descTV.text = desc
        
    }
    
    @IBAction func showCardButtonTapped(_ sender: Any) {
        
        
        
    }
    
    @IBAction func acceptButtonTapped(_ sender: Any) {
        
        performRequestUpdateTime()
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func performRequestUpdateTime() { //url: String, parameters: [String:Any]
        
        let url = "https://hawy-kw.com/api/auth/profile/cards/ownership/status"
        
        let param: [String: Any] = [
            
            "card_id" : cardId ?? 0
            
        ]
        
        print(param)
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")"
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
                        let forgetPasswordRequest = try decoder.decode(AcceptOwnershipTransfereModel.self, from: data)
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
                            //self.navigationController?.popViewController(animated: true)
                            
                            let story = UIStoryboard(name: "HawyTabbar", bundle:nil)
                            let vc = story.instantiateViewController(withIdentifier: "HawyTabbarController") as! HawyTabbarController
                            vc.isAddCard = true
                            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                            
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


// MARK: - AddSaleAuctionModel
struct AcceptOwnershipTransfereModel: Codable {
    let code: Int?
    let message: String?
    let item: AcceptOwnershipTransfereItem?
}

// MARK: - Item
struct AcceptOwnershipTransfereItem: Codable {
    let id, auctionID: Int?
    let type, name, price, motherName: String?
    let fatherName, age, status: String?
    let startDate, endDate: Int?
    let currency, bidMaxPrice: String?
    let bidCounter: Int?
    let notes, conductedBy: String?
    let conductorAvailable: Bool?
    let documentationNumber: String?
    let conductor: AcceptOwnershipTransfereConductor?
    let categoryID: Int?
    let categoryName, mainImage, video: String?
    let images: [String]?
    let owners, inoculations, joinedUsers: [AcceptOwnershipTransfereConductor]?
    let owner, purchasedTo: AcceptOwnershipTransfereConductor?

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

// MARK: - Conductor
struct AcceptOwnershipTransfereConductor: Codable {
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
