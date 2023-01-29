//
//  AddStockAuctionViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 07/10/2022.
//

import UIKit
import Alamofire

class AddStockAuctionViewController: BaseViewViewController {
    
    @IBOutlet weak var scrollViewOutlet: UIScrollView!
    @IBOutlet weak var containerViewInScrollViewOutlet: UIView!
    
    @IBOutlet weak var cardsTableView: UITableView!
    @IBOutlet weak var cardsTableViewHeight: NSLayoutConstraint!
    
    private var viewModel = ProfileViewModel()
    
    var auctionId: Int?
    var cardData = [AddCardFromHomeToAuctionModel]()
    //var backData: ((Int) -> Void)?
    var catId: Int?
    var cardName: String?
    var cardImage: String?
    var stockPrice: String?
    
    var catID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardsTableView.register(UINib(nibName: "AddSaleAuctionFromHomeCarddsTableViewCell", bundle: nil), forCellReuseIdentifier: "AddSaleAuctionFromHomeCarddsTableViewCell")
        
        cardsTableView.tableFooterView = UIView()
        cardsTableView.separatorStyle = .none
        
        cardsTableView.delegate = self
        cardsTableView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.cardsTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            
            self.scrollViewOutlet.roundCorners([.topLeft, .topRight], radius: 20)
            self.containerViewInScrollViewOutlet.roundCorners([.topLeft, .topRight], radius: 20)
            
            self.cardsTableViewHeight.constant = self.cardsTableView.contentSize.height
            
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        
        DispatchQueue.main.async {
            
            self.cardsTableViewHeight.constant = self.cardsTableView.contentSize.height
            
        }
    }
    
    @objc
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func chooseCardsButtonAction(_ sender: Any) {
        
        let storyborad = UIStoryboard(name: "HawyTabbar", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "AddCardAdFromProfileViewController") as? AddCardAdFromProfileViewController
        VC?.backData = { [weak self] (data, cardID, cardNAme, cardIMage) in
            guard let self = self else { return }
            self.cardData = data
            self.catId = cardID
            self.cardName = cardNAme
            self.cardImage = cardIMage
            //self.cardData.removeAll()
            self.cardData.append(AddCardFromHomeToAuctionModel(name: self.cardName, price: "", id: self.catId, image: self.cardImage))
            print(data)
            print(self.cardData)
            print(self.catId)
            print(self.cardName)
            print(self.cardImage)
            self.viewWillLayoutSubviews()
            self.cardsTableView.reloadData()
        }
        VC?.catID = catID
        VC?.fromStock = true
        VC?.titleLabel = "Add Stock card".localized
        navigationController?.pushViewController(VC!, animated: false)
        
    }
    
    func performRequest() { //url: String, parameters: [String:Any]
        
        let url = "https://hawy-kw.com/api/auctions/market/attachCards"
        
        //cardData.append(contentsOf: [AddCardFromHomeToAuctionModel(id: 9, price: "100", name:), AddCardFromHomeToAuctionModel(id: 8, price: "120")])
        
        let dicArray = cardData.map{$0.toDictionary()}
        if let data = try? JSONSerialization.data(withJSONObject: dicArray, options: .prettyPrinted){
            print(data)
            let str = String(bytes: data, encoding: .utf8)
            print(str) //Prints a string of "\n\n"
        }
        print(dicArray)
        
        let param: [String: Any] = [
            
            "auction_id" : auctionId ?? 0,
            "card_id":  catId ?? 0,
            "price": stockPrice ?? 0.0
            
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
                        let forgetPasswordRequest = try decoder.decode(AddStockAuctionModel.self, from: data)
                        print(forgetPasswordRequest)
                        
                        if forgetPasswordRequest.code == 200 {
                            
                            print("success")
//                            let story = UIStoryboard(name: "HawyTabbar", bundle:nil)
//                            let vc = story.instantiateViewController(withIdentifier: "HawyTabbarController") as! HawyTabbarController
//                            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
//                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                            
                            let stroyboard = UIStoryboard(name: "Subscriptions", bundle: nil)
                            let VC = stroyboard.instantiateViewController(withIdentifier: "AuctionAdsPAymentViewController") as? AuctionAdsPAymentViewController
                            
                            VC?.type = 2
                            VC?.startDate = forgetPasswordRequest.item?.startDate ?? 0
                            VC?.endDate = forgetPasswordRequest.item?.endDate ?? 0
                            VC?.total = forgetPasswordRequest.item?.subscribePrice ?? "0.0"
                            
                            self.navigationController?.pushViewController(VC!, animated: true)
                            
                        }else if forgetPasswordRequest.code == 422 {
                            ToastManager.shared.showError(message: forgetPasswordRequest.message ?? "", view: self.view)
                        }
                        
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
    
    @IBAction func publishButtonAction(_ sender: Any) {
        
        //getProductDetails()
        performRequest()
        
    }
    
}

extension AddStockAuctionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
        cardsTableView.layoutIfNeeded()
        
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
        
        return cardData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = cardsTableView.dequeueReusableCell(withIdentifier: "AddSaleAuctionFromHomeCarddsTableViewCell", for: indexPath) as? AddSaleAuctionFromHomeCarddsTableViewCell else { return UITableViewCell() }
        
        let item = cardData[indexPath.row]
        
        cell.titleLabel.text = item.name
        cell.priceLabel.text = ""
        cell.cardImage.loadImage(URLS.baseImageURL+(item.image ?? ""))
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        cardData.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete".localized) { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            let item = self.cardData[indexPath.row]
            self.cardData.remove(at: indexPath.row)
            if let index2 = self.cardData.firstIndex(of: AddCardFromHomeToAuctionModel(name: item.name, price: item.price, id: item.id, image: item.image)) {
                self.cardData.remove(at: index2)
                print("cardData is : \(self.cardData)")
                
            }
            self.cardsTableView.beginUpdates()
            self.cardsTableView.deleteRows(at: [indexPath], with: .automatic)
            self.cardsTableView.endUpdates()
            self.viewWillLayoutSubviews()
            self.cardsTableView.layoutIfNeeded()
            completionHandler(true)
            
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
        
    }
    
}
