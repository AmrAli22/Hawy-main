//
//  ChooseCategoryForAuctionViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 08/12/2022.
//

import UIKit
import Combine
import Alamofire

class ChooseCategoryForAuctionViewController: BottomPopupViewController {
    
    @IBOutlet weak var categoryTableView: UITableView!{
        
        didSet {
            
            categoryTableView.delegate = self
            categoryTableView.dataSource = self
            
            categoryTableView.register(UINib(nibName: "ChooseCategoryForAuctionTableViewCell", bundle: nil), forCellReuseIdentifier: "ChooseCategoryForAuctionTableViewCell")
            
            let typesTableViewFrame = CGRect(x: 0, y: 0, width: categoryTableView.frame.size.width, height: 1)
            categoryTableView.tableFooterView = UIView(frame: typesTableViewFrame)
            categoryTableView.tableHeaderView = UIView(frame: typesTableViewFrame)
            
        }
        
    }
    
    var subscriber = Set<AnyCancellable>()
    
    private var categoryViewModel = CategoryViewModel()
    @Published var categoryData = [CategoryData]()
    var subcat = [SubCategoryData]()
    var isBeforeAuc = false
    
    var catID = -1
    var catName = ""
    
    var returnBack: ((String, Int) -> Void)?
    
    var selected_Index : Int?
    var height: CGFloat?
    //var Delegate : AddNewAddress!
    //var delegateAction: delegate?
    //var delegYourAdderss: delegateAddress?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            
            let category = try await categoryViewModel.getCategory()
            print(category)
            sinkToCategoryModel()
            sinkToCategoryData()
            ReloadingState()
            
            getProfileData()
            
            if isBeforeAuc {
                getSubCat()
            }
        }
        
    }
    
    override func getPopupHeight() -> CGFloat {
        return height ?? CGFloat(450)
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
    
    func ReloadingState() {
        
        categoryViewModel.reloadingState
            .sink { [weak self] state in
                guard let self = self else { return }
                if state {
                    self.categoryTableView.reloadData()
                }else {
                    print("not ReloadData")
                }
            }.store(in: &subscriber)
        
    }
    func sinkToCategoryModel() {
        categoryViewModel.categoryModelPublisher.sink { [weak self] result in
            guard let self = self else { return }
            if result?.code == 200 {
                print("show Sliders")
            }
//            else if result?.code == 401 {
//
//            }
        }.store(in: &subscriber)
    }
    
    func sinkToCategoryData() {
        categoryViewModel.categoryDataPublisher.sink { [weak self] result in
            guard let self = self else { return }
            print(result)
            self.categoryData = result ?? []
        }.store(in: &subscriber)
    }
    
    func getProfileData() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")"
        ]
        
        //showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/auth/profile?user_id=\(HelperConstant.getUserId() ?? 0)", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(ProfileModel.self, from: response.data!)
                
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
                
                //self.hideIndecator()
            } catch {
                //self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    @IBAction func chooseButtonTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: {
            self.returnBack!(self.catName, self.catID)
        })
        
    }
    
    
}

extension ChooseCategoryForAuctionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isBeforeAuc ? subcat.count : categoryData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = categoryTableView.dequeueReusableCell(withIdentifier: "ChooseCategoryForAuctionTableViewCell", for: indexPath) as? ChooseCategoryForAuctionTableViewCell else { return UITableViewCell() }
        
        if isBeforeAuc {
            let item = subcat[indexPath.row]
            cell.titleLabel.text = item.name
        }else{
            let item = categoryData[indexPath.row]
            cell.titleLabel.text = item.name
        }
        
    
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = categoryTableView.cellForRow(at: indexPath) as? ChooseCategoryForAuctionTableViewCell else { return }
        
        if isBeforeAuc {
            let item = subcat[indexPath.row]
    
            cell.set()
            
            catID = item.id ?? -1
            catName = item.name ?? ""
        }else{
            let item = categoryData[indexPath.row]
            
            cell.set()
            
            catID = item.id ?? -1
            catName = item.name ?? ""
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        guard let cell = categoryTableView.cellForRow(at: indexPath) as? ChooseCategoryForAuctionTableViewCell else { return }
        
        //let item = categoryData[indexPath.row]
        
        cell.unSet()
        
        //catID = -1
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}


extension ChooseCategoryForAuctionViewController {
    
    func getSubCat() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")"
        ]
        
        //showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/categories/sub", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(SubCategoryModel.self, from: response.data!)
                
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
                    
                }else{
                    
                    self.subcat = productResponse.item ?? [SubCategoryData]()
                    self.categoryTableView.reloadData()
                }
                
                //self.hideIndecator()
            } catch {
                //self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
}
