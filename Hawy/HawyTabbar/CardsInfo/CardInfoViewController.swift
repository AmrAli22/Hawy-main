//
//  CardInfoViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 10/10/2022.
//

import UIKit
import Alamofire

class CardInfoViewController: BaseViewViewController {
    
    @IBOutlet weak var collectionContainer: UIView!
    @IBOutlet weak var animalNameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var fatherNameLabel: UILabel!
    @IBOutlet weak var motherNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
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
                    self.animalNameLabel.text = productResponse.item?.name ?? ""
                    self.typeLabel.text = productResponse.item?.categoryName ?? ""
                    self.fatherNameLabel.text = productResponse.item?.fatherName ?? ""
                    self.motherNameLabel.text = productResponse.item?.motherName ?? ""
                    self.ageLabel.text = productResponse.item?.age ?? ""
                    
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
