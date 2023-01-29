//
//  LiveAuctionTmesViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 22/10/2022.
//

import UIKit
import Alamofire

class LiveAuctionTmesViewController: BaseViewViewController {
    
    @IBOutlet weak var timesCollectionView: UICollectionView!
    @IBOutlet weak var timeView: UIView!
    
    var timesData = [LiveAuctionDateCheckModelItem]()
    
    var timeDate: Int64?
    
    var backData: ((_ dateId: Int, _ dateFromTo: String) -> Void)?
    var timeId: Int?
    var timeFromTo: String?
    
    var index = -1
    
    var spoiling = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timesCollectionView.delegate = self
        timesCollectionView.dataSource = self
        
        performTimes(times: timeDate, type: spoiling)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            
            self.timeView.roundCornersWithMask([.topLeading, .topTrailing], radius: 20)
            
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chooseTimeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.backData?(self.timeId ?? 0, self.timeFromTo ?? "")
        })
    }
    
    func performTimes(times: Int64?, type: String?) { //url: String, parameters: [String:Any]
        
        //let url = "https://hawy-kw.com/api/auctions/live/time/list?date=\(times ?? 0.0)&type=\(type ?? "")"
        let url = "https://hawy-kw.com/api/auctions/live/time/list?date=\(times ?? 0)&type=\(type ?? "")"
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
//        showIndecator()
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
                        let forgetPasswordRequest = try decoder.decode(LiveAuctionDateCheckModel.self, from: data)
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
                            
                            self.timesData = forgetPasswordRequest.item ?? []
                            self.timesCollectionView.reloadData()
                            
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

extension LiveAuctionTmesViewController: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = timesCollectionView.dequeueReusableCell(withReuseIdentifier: "LiveTimesCollectionViewCell", for: indexPath) as? LiveTimesCollectionViewCell else { return UICollectionViewCell() }
        
        let item = timesData[indexPath.row]
        
        if index == indexPath.row {
            if item.available == true {
                cell.containerView.backgroundColor = DesignSystem.Colors.PrimaryBlue.color
            }else {
                cell.containerView.backgroundColor = DesignSystem.Colors.PrimaryDarkRed.color
            }
        }else {
            cell.containerView.backgroundColor = DesignSystem.Colors.PrimaryGray
                .color
        }
        
        
        cell.timeLabelOutlet.text = "\(item.timeFrom ?? "") - \(item.timeTo ?? "")"
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = timesData[indexPath.row]
        print(indexPath.row)
        index = indexPath.row
        timeId = item.id
        timeFromTo = "\(item.timeFrom ?? "") - \(item.timeTo ?? "")"
        timesCollectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 10) / 2, height: 55)
    }
    
}
