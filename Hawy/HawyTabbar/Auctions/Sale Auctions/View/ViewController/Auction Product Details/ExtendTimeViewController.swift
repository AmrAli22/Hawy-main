//
//  ExtendTimeViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 07/10/2022.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class ExtendTimeViewController: BottomPopupViewController {
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .ballClipRotatePulse, color: DesignSystem.Colors.PrimaryBlue.color, padding: 0)
    
    lazy var containerOfLoading: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.15)
        return view
        
    }()
    
    @IBOutlet weak var timeTableView: UITableView!
    
    
    var selected_Index : Int?
    var height: CGFloat?
    //var Delegate : AddNewAddress!
    //var delegateAction: delegate?
    //var delegYourAdderss: delegateAddress?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    var auctionId: Int?
    var cardId:Int?
    var timesData = [TimesItem]()
    var timeId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeTableView.delegate = self
        timeTableView.dataSource = self
        
        getTimes()
        
        
    }
    
    @IBAction func extendTimeButtonAction(_ sender: Any) {
        
        if timeId == 0 {
            ToastManager.shared.showError(message: "Please, select the extended time".localized, view: self.view)
        }else {
            performRequestUpdateTime()
        }
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func getPopupHeight() -> CGFloat {
        return height ?? CGFloat(600)
    }
    
    override func getPopupTopCornerRadius() -> CGFloat {
        return 35
    }
    
    override func getPopupPresentDuration() -> Double {
        return presentDuration ?? 1.0
    }
    
    override func getPopupDismissDuration() -> Double {
        return dismissDuration ?? 1.0
    }
    
    override func shouldPopupDismissInteractivelty() -> Bool {
        return shouldDismissInteractivelty ?? false
    }
    
    func showIndecator() {
        addLoaderToView(mainView: view, containerOfLoading: containerOfLoading, loading: loading)
    }
    
    func hideIndecator() {
        removeLoader(containerOfLoading: containerOfLoading, loading: loading)
    }
    
    func getTimes() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/auctions/sales/times", method: .get, parameters: nil, headers: headers).responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(TimesModel.self, from: response.data!)
                
                if productResponse.code == 200 {
                    
                    self.timesData = productResponse.item ?? []
                    print(self.timesData)
                    self.timeTableView.reloadData()
                }
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    func performRequestUpdateTime() { //url: String, parameters: [String:Any]
        
        let url = "https://hawy-kw.com/api/auctions/sales/update"
        
        let param: [String: Any] = [
            
            "card_id" : cardId ?? 0,
            "auction_id": auctionId ?? 0,
            "time_id" : timeId ?? 0
            
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
                        let forgetPasswordRequest = try decoder.decode(ExtendTimesModel.self, from: data)
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
                            self.dismiss(animated: true, completion: nil)
                            
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

extension ExtendTimeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = timeTableView.dequeueReusableCell(withIdentifier: "ExtendTimeTableViewCell", for: indexPath) as? ExtendTimeTableViewCell else { return UITableViewCell() }
        
        let item = timesData[indexPath.row]
        
        cell.nameLabel.text = item.name
        cell.priceLabel.text = "\(item.price ?? 0)" + (HelperConstant.getCurrency() ?? "K.D") //"K.D".localized
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = timesData[indexPath.row]
        timeId = item.id ?? 0
        print(timeId)
    }
    
}
