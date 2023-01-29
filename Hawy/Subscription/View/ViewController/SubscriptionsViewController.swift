//
//  SubscriptionsViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 08/08/2022.
//

import UIKit
import Alamofire

class SubscriptionsViewController: BaseViewViewController {
    
    @IBOutlet weak var packagesCollectionView: UICollectionView!{
        didSet {
            let flowLayout = ZoomAndSnapFlowLayout()
            packagesCollectionView.collectionViewLayout = flowLayout
            packagesCollectionView.contentInsetAdjustmentBehavior = .always
            packagesCollectionView.dataSource = self
            packagesCollectionView.delegate = self
            packagesCollectionView.register(UINib(nibName: "SubscriptionsPackagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SubscriptionsPackagesCollectionViewCell")
            
        }
    }
    
    //@IBOutlet weak var sectionsTableView: UITableView! //TableViewAdjustedHeight
    @IBOutlet weak var sectionsTableView: UITableView!
    @IBOutlet weak var sectionsTableHeight: NSLayoutConstraint!
    
    var index = 0
    
    var subscriptionItem = [SubscriptionItem]()
    var subscriptionCategoey = [SubscriptionCategoey]()
    
    var packageId = 0
    var catIds: [Int] = []
    var numSel = 0
    var price = "0.0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        getSubscribtionData()
    }
    
    func setTableView() {
        
        sectionsTableView.register(UINib(nibName: "SectionsOfPackagesTableViewCell", bundle: nil), forCellReuseIdentifier: "SectionsOfPackagesTableViewCell")
        
        let sectionsTableViewFrame = CGRect(x: 0, y: 0, width: sectionsTableView.frame.size.width, height: 1)
        sectionsTableView.tableFooterView = UIView(frame: sectionsTableViewFrame)
        sectionsTableView.tableHeaderView = UIView(frame: sectionsTableViewFrame)
        
        sectionsTableView.delegate = self
        sectionsTableView.dataSource = self
        sectionsTableView.allowsMultipleSelection = true
        
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        
        DispatchQueue.main.async { [weak self] in
            //your code here
            guard let self = self else { return }
            
            self.sectionsTableHeight.constant = self.sectionsTableView.contentSize.height
            
        }
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
        submitSubscruption()
        
    }
    
    func getSubscribtionData() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")"
        ]
        
        showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/packages", method: .get, parameters: nil, headers: headers).responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(SubscriptionModel.self, from: response.data!)
                
                if productResponse.code == 200 {
                    print("success")
                    
                    self.subscriptionItem = productResponse.item ?? []
                    self.subscriptionCategoey = productResponse.item?[0].categoeies ?? []
                    
                    self.packageId = productResponse.item?[0].id ?? 0
                    
                    let num = productResponse.item?[0].categoryNumber
                    self.numSel = Int(num ?? "0") ?? 0
                    
                    self.price = productResponse.item?[0].price ?? "0.0"
                    
                    self.packagesCollectionView.reloadData()
                    self.sectionsTableView.reloadData()
                    
                }
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    func submitSubscruption() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")"
        ]
        
        let param : [String: Any] = [
            
            "package_id" : packageId,
            "payment_method" : "card",
            "category_id" : catIds
            
        ]
        
        showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/packages/store", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(SubmitSubscriptionModel.self, from: response.data!)
                
                if productResponse.code == 200 {
                    print("success")
                    
                    if self.price == "0.00" {
                        
                        let story = UIStoryboard(name: "HawyTabbar", bundle:nil)
                        let vc = story.instantiateViewController(withIdentifier: "HawyTabbarController") as! HawyTabbarController
                        UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                        
                    }else {
                        
                        let stroyboard = UIStoryboard(name: "Subscriptions", bundle: nil)
                        let VC = stroyboard.instantiateViewController(withIdentifier: "PaymetViewController") as? PaymetViewController
                        self.navigationController?.pushViewController(VC!, animated: true)
                        
                    }
                    
                }else{
                    ToastManager.shared.showError(message: productResponse.message ?? "", view: self.view)
                }
                
                
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
}

extension SubscriptionsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        DispatchQueue.main.async {
//            let firstAnimation = CollectionViewAnimationFactory.makeSlideIn(duration: 0.5, delayFactor: 0.05)
//            let secondAnimation = CollectionViewAnimationFactory.makeFade(duration: 0.5, delayFactor: 0.05)
//            let thirdAnimation = CollectionViewAnimationFactory.makeMoveUpWithBounce(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
//            let fourthAnimation = CollectionViewAnimationFactory.makeMoveUpWithFade(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
//            //
//            let animator = CollectionViewAnimator(animation: firstAnimation)
//            animator.animate(cell: cell, at: indexPath, in: collectionView)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subscriptionItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = packagesCollectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionsPackagesCollectionViewCell", for: indexPath) as? SubscriptionsPackagesCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.containerView.layer.borderWidth = 0
        cell.containerView.layer.borderColor = UIColor.clear.cgColor
        
        if indexPath.row == index {
            cell.containerView.layer.borderWidth = 2
            cell.containerView.layer.borderColor = DesignSystem.Colors.PrimaryYellow.color.cgColor
        }
        
        let item = subscriptionItem[indexPath.row]
        
        cell.packageNameLabel.text = item.name
        cell.packagePriceLabel.text = "\(item.price ?? "0.0")"
        cell.packageDescLabel.text = item.itemDescription
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.row
        
        let item = subscriptionItem[index].categoeies
        subscriptionCategoey = item ?? []
        packageId = subscriptionItem[index].id ?? 0
        numSel = Int(subscriptionItem[index].categoryNumber ?? "") ?? 0
        price = subscriptionItem[index].price ?? "0.0"
        packagesCollectionView.reloadData()
        sectionsTableView.reloadData()
    }
    
}

extension SubscriptionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
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
        return subscriptionCategoey.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = sectionsTableView.dequeueReusableCell(withIdentifier: "SectionsOfPackagesTableViewCell", for: indexPath) as? SectionsOfPackagesTableViewCell else { return UITableViewCell() }
        
        let item = subscriptionCategoey[indexPath.row]
        
        cell.titleLabel.text = item.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            if let cell = sectionsTableView.cellForRow(at: indexPath) as? SectionsOfPackagesTableViewCell {
                
                let array = subscriptionCategoey[indexPath.row]
                
                if cell.isSelected == true {
                    
                    if numSel > catIds.count {
                        
                        cell.set()
                        catIds.append(array.id ?? 0)
                        print(catIds)
                        print(indexPath.row)
                        
                    }else {
                        
                        cell.isSelected = false
                        ToastManager.shared.showError(message: "Can't select categories, number of category to select is".localized+" \(numSel) " + "category".localized, view: self.view)
                        
                    }
                    
                }else {
                    cell.unSet()
                    if let index = catIds.firstIndex(of: array.id ?? 0) {
                        catIds.remove(at: index)
                        print(catIds)
                    }
                    
                }
                
            }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if let cell = sectionsTableView.cellForRow(at: indexPath) as? SectionsOfPackagesTableViewCell {

            let array = subscriptionCategoey[indexPath.row]
            
            if cell.isSelected == true {
                
                if numSel > catIds.count {
                    
                    cell.set()
                    catIds.append(array.id ?? 0)
                    print(catIds)
                    print(indexPath.row)
                    
                }else {
                    
                    cell.isSelected = false
                    ToastManager.shared.showError(message: "Can't select categories, number of category to select is".localized+" \(numSel) " + "category".localized, view: self.view)
                    
                }
                
            }else {
                cell.unSet()
                if let index = catIds.firstIndex(of: array.id ?? 0) {
                    catIds.remove(at: index)
                    print(catIds)
                }
                
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
