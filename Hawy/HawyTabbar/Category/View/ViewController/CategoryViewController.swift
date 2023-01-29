//
//  CategoryViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 07/08/2022.
//

import UIKit
import Combine
import Alamofire

class CategoryViewController: BaseViewViewController {
    
    @IBOutlet weak var tcategoryTitleLabel: UILabel!
    @IBOutlet weak var collectionContainer: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!{
        didSet {
            
            categoryCollectionView.dataSource = self
            categoryCollectionView.delegate = self
            categoryCollectionView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 50, right: 0)
            categoryCollectionView.register(UINib(nibName: "SecondCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SecondCategoryCollectionViewCell")
            
        }
    }
    
    var action: (() -> Void)?
    weak var homeViewController:HomeVC?
    weak var subCategoryViewController: SubCategoryViewController?
    
    private var viewModel = SubCategoryViewModel()
    var subscriber = Set<AnyCancellable>()
    
    var cardsData = [MyCardsItem]()
    var cardsData2 = [CategoryData]()
    @Published var subCategoryData = [SubCategoryData]()
    var subCategoryID: Int?
    
    var categoryTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryCollectionView.collectionViewLayout = createCompositionalLayout()
        
        tcategoryTitleLabel.text = categoryTitle ?? ""
        
        //getProfileAuctions()
        getSubCategories()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionContainer.roundCorners([.topLeft, .topRight], radius: 20)
        
        Task {
//            let subCategory = try await viewModel.getSubCategory(categoryId: subCategoryID)
//            print(subCategory)
//            sinkToLoading()
//            sinkToCategoryModel()
//            sinkToCategoryData()
//            ReloadingState()
            
        }
        
    }
    
    func sinkToLoading() {
//        self.viewModel.loadinState
//            .sink { [weak self] state in
//                self?.handleActivityIndicator(state: state)
//            }.store(in: &subscriber)
        viewModel.loadState
            .sink { [weak self] state in
                guard let self = self else { return }
                if state {
                    print("show Loading")
                }else {
                    print("dismiss Loading")
                }
            }.store(in: &subscriber)
        
    }
    
    func ReloadingState() {
        
        viewModel.reloadingState
            .sink { [weak self] state in
                guard let self = self else { return }
                if state {
                    self.categoryCollectionView.reloadData()
                }else {
                    print("not ReloadData")
                }
            }.store(in: &subscriber)
        
    }
    
    func sinkToCategoryModel() {
        viewModel.subCategoryModelPublisher.sink { [weak self] result in
            guard let self = self else { return }
            if result?.code == 200 {
                print("show Sliders")
            }
        }.store(in: &subscriber)
    }
    
    func sinkToCategoryData() {
        viewModel.subCategoryDataPublisher.sink { [weak self] result in
            guard let self = self else { return }
            print(result)
            self.subCategoryData = result ?? []
            
            
            
        }.store(in: &subscriber)
    }
    
    func getProfileAuctions() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator() //
        AF.request("https://hawy-kw.com/api/auth/profile/cards?type=other&category_id=\(subCategoryID ?? 0)&user_id=\(HelperConstant.getUserId() ?? 0)", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(MyCardsModel.self, from: response.data!)
                
                if productResponse.code == 200 {
                    print("success")
                    self.cardsData = productResponse.item?.cards ?? []
                    self.categoryCollectionView.reloadData()
                    
                    if self.cardsData.isEmpty == true {
                        self.emptyView.isHidden = false
                    }else {
                        self.emptyView.isHidden = true
                    }
                    
                }
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
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    func getSubCategories() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator() //
        AF.request("https://hawy-kw.com/api/subCategories?category_id=\(subCategoryID ?? 0)", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(CategoryModel.self, from: response.data!)
                
                if productResponse.code == 200 {
                    print("success")
                    self.cardsData2 = productResponse.item ?? []
                    self.categoryCollectionView.reloadData()
                    
                    if self.cardsData2.isEmpty == true {
                        self.emptyView.isHidden = false
                    }else {
                        self.emptyView.isHidden = true
                    }
                    
                }
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
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (index, environment) -> NSCollectionLayoutSection? in
            
            return self?.createSectionFor(index: index, environment: environment)
            
        }
        return layout
    }
    
    func createSectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        switch index {
        case 0:
            return createFourthSection()
        default:
            return createFourthSection()
        }
    }
    
    func createFourthSection() -> NSCollectionLayoutSection {
        
        let inset: CGFloat = 5
        
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.15))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        //section.orthogonalScrollingBehavior = .continuous
        
        return section
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
        //action?()
        
    }
    
}

extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let firstAnimation = CollectionViewAnimationFactory.makeSlideIn(duration: 0.5, delayFactor: 0.05)
            let secondAnimation = CollectionViewAnimationFactory.makeFade(duration: 0.5, delayFactor: 0.05)
            let thirdAnimation = CollectionViewAnimationFactory.makeMoveUpWithBounce(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
            let fourthAnimation = CollectionViewAnimationFactory.makeMoveUpWithFade(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
            //
            let animator = CollectionViewAnimator(animation: firstAnimation)
            animator.animate(cell: cell, at: indexPath, in: collectionView)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsData2.count //cardsData  subCategoryData
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "SecondCategoryCollectionViewCell", for: indexPath) as? SecondCategoryCollectionViewCell else { return UICollectionViewCell() }
        //cell.containerView.backgroundColor = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
        //cell.layer.cornerRadius = 10
        let item = cardsData2[indexPath.row]
        cell.containerView.backgroundColor = UIColor().colorWithHexString(hexString: item.color ?? "")
        cell.catImage.setImageWith(URLS.baseImageURL+(item.image ?? ""), UIImage(named: ""))
        cell.titleLabel.text = item.name
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        let item = cardsData2[indexPath.row]
        let storyborad = UIStoryboard(name: "HawyTabbar", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "SubCategoryViewController") as? SubCategoryViewController
        VC?.cardID = item.id
        navigationController?.pushViewController(VC!, animated: false)
        
//        if subCategoryViewController == nil {
//            subCategoryViewController = Storyboard.HawyTabbar.viewController(SubCategoryViewController.self)
//            
//            if subCategoryViewController?.parent == nil {
//                
//                self.addChild(subCategoryViewController!)
//                subCategoryViewController?.categoryViewController = self
//                //self.containerView.addSubview(categoryVC!.view)
//                self.view.addSubview(subCategoryViewController!.view)
//                subCategoryViewController?.didMove(toParent: self)
//                subCategoryViewController?.action = {
//                    self.subCategoryViewController?.willMove(toParent: nil)
//                    self.subCategoryViewController?.view.removeFromSuperview()
//                    self.subCategoryViewController?.removeFromParent()
//                    self.subCategoryViewController = nil
//                }
//                //self.view.bringSubviewToFront(self.containerView)
//                
//            }
//            
//        }
        
    }
    
}
