//
//  ToSelectEditeViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 03/10/2022.
//

import UIKit
import Alamofire

// MARK: - AddSaleAuctionModel
struct DeleteCardModel: Codable {
    let code: Int
    let message: String
}

class ToSelectEditeViewController: BaseViewViewController {
    
    var cardId: Int?
    //var owners = [ShowCardDetailsInoculation]()
    //var inoculations = [ShowCardDetailsInoculation]()
    var images = [String]()
    var owners = [String]()
    var inoculations = [String]()
    var mainImage = ""
    var video = ""
    
    var name: String?
    var mother_name: String?
    var father_name: String?
    var age: String?
    var category_id: Int?
    var notes: String?
    var status: String?
    //var inoculations: String?
    //var owners: String?
    
    weak var showDetails: ShowAddedCardDetailsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))

        view.addGestureRecognizer(tap)

        view.isUserInteractionEnabled = true

        getCardData(id: cardId, userId: HelperConstant.getUserId() ?? 0)
        
        
    }
    
    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        //self.navigationController?.popViewController(animated: true)
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func editeDataButtonAction(_ sender: Any) {
        
        let storyborad = UIStoryboard(name: "Profile", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "ProfileCardDetailsViewController") as! ProfileCardDetailsViewController
        //VC.orderName.removeAll()
        //VC.propertyName.removeAll()
        VC.orderName = inoculations
        VC.propertyName = owners
        VC.cardId = cardId
        
        if showDetails != nil {
            dismiss(animated: false) {
                self.showDetails?.navigationController?.pushViewController(VC, animated: true)
            }
        }else{
            navigationController?.pushViewController(VC, animated: true)
        }
        
    }
    
    @IBAction func editeAttachmentButtonAction(_ sender: Any) {
        
        let storyborad = UIStoryboard(name: "Profile", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "ProfileCardAttachedViewController") as! ProfileCardAttachedViewController
        VC.cardId = cardId
        
        if showDetails != nil {
            dismiss(animated: false) {
                self.showDetails?.navigationController?.pushViewController(VC, animated: true)
            }
        }else{
            navigationController?.pushViewController(VC, animated: true)
        }
        
    }
    
    @IBAction func deleteCardButtonAction(_ sender: Any) {
        performRequest()
    }
    
    @IBAction func lostButtonAction(_ sender: Any) {
        performRequestLost()
    }
    
    func performRequestLost() { //url: String, parameters: [String:Any]
        
        let url = "https://hawy-kw.com/api/auth/profile/cards/\(cardId ?? 0)/update"
        
        //cardData.append(contentsOf: [AddCardFromHomeToAuctionModel(id: 9, price: "100", name:), AddCardFromHomeToAuctionModel(id: 8, price: "120")])
        
        
        let param: [String: Any] = [
            
            "name" : name ?? "",
            "mother_name": mother_name ?? "",
            "father_name": father_name ?? "",
            "age": age ?? "",
            "category_id": "\(category_id ?? 0)" ,
            "notes": notes ?? "",
            "status": "lost",
            "inoculations": owners,
            "owners": inoculations
            
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
                        let forgetPasswordRequest = try decoder.decode(ShowCardDetailsModel.self, from: data)
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
                            self.navigationController?.popViewController(animated: true)
                            //self.dismiss(animated: true, completion: nil)
                            
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
    
    func performRequest() { //url: String, parameters: [String:Any]
    
        let url = "https://hawy-kw.com/api/auth/profile/cards/\(cardId ?? 0)/delete"
        
        //cardData.append(contentsOf: [AddCardFromHomeToAuctionModel(id: 9, price: "100", name:), AddCardFromHomeToAuctionModel(id: 8, price: "120")])
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator()
        AF.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers) // //URLEncoding.httpBody
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
                        let forgetPasswordRequest = try decoder.decode(DeleteCardModel.self, from: data)
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
                            let story = UIStoryboard(name: "HawyTabbar", bundle:nil)
                            let vc = story.instantiateViewController(withIdentifier: "HawyTabbarController") as! HawyTabbarController
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
                    print("success")
                    
                    DispatchQueue.main.async {
                        
                        for owner in productResponse.item?.owners ?? [] {
                            self.owners.append(owner.name ?? "")
                        }
                        
                        for inoculation in productResponse.item?.inoculations ?? [] {
                            self.inoculations.append(inoculation.name ?? "")
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
    
}
