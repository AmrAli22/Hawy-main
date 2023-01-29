//
//  SubCategoryViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 07/08/2022.
//

import UIKit
import Combine
import Alamofire

class SubCategoryViewController: BaseViewViewController {

    @IBOutlet weak var subCategoryCollectionView: UICollectionView!{
        didSet {
            
            subCategoryCollectionView.dataSource = self
            subCategoryCollectionView.delegate = self
            subCategoryCollectionView.contentInset.top = 30
            self.subCategoryCollectionView.contentInset.bottom = 50
            subCategoryCollectionView.register(UINib(nibName: "SubCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SubCategoryCollectionViewCell")
            
        }
    }
    @IBOutlet weak var emptyView: UIView!
    var action: (() -> Void)?
    weak var categoryViewController:CategoryViewController?
    
    private var viewModel = SubCategoryViewModel()
    var subscriber = Set<AnyCancellable>()
    
    @Published var subCategoryData = [SubCategoryData]()
    var cardID: Int?
    
    var cardsData = [MyCardsItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subCategoryCollectionView.collectionViewLayout = createCompositionalLayout()
        getProfileAuctions()
//        Task {
//
//            let subCategory = try await viewModel.getSubCategory(categoryId: categoryID)
//            print(subCategory)
//            sinkToLoading()
//            sinkToSubCategoryModel()
//            sinkToSubCategoryData()
//            ReloadingState()
//
//        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        subCategoryCollectionView.roundCornersWithMask([.topLeading, .topTrailing], radius: 20)
    }
    
//    func sinkToLoading() {
////        self.viewModel.loadinState
////            .sink { [weak self] state in
////                self?.handleActivityIndicator(state: state)
////            }.store(in: &subscriber)
//        viewModel.loadState
//            .sink { [weak self] state in
//                guard let self = self else { return }
//                if state {
//                    print("show Loading")
//                }else {
//                    print("dismiss Loading")
//                }
//            }.store(in: &subscriber)
//        
//    }
//    
//    func ReloadingState() {
//        
//        viewModel.reloadingState
//            .sink { [weak self] state in
//                guard let self = self else { return }
//                if state {
//                    self.subCategoryCollectionView.reloadData()
//                }else {
//                    print("not ReloadData")
//                }
//            }.store(in: &subscriber)
//        
//    }
//    
//    func sinkToSubCategoryModel() {
//        viewModel.subCategoryModelPublisher.sink { [weak self] result in
//            guard let self = self else { return }
//            if result?.code == 200 {
//                print("show Sliders")
//            }
//        }.store(in: &subscriber)
//    }
//    
//    func sinkToSubCategoryData() {
//        viewModel.subCategoryDataPublisher.sink { [weak self] result in
//            guard let self = self else { return }
//            print(result)
//            self.subCategoryData = result ?? []
//        }.store(in: &subscriber)
//    }
    
    func getProfileAuctions() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator() //
        AF.request("https://hawy-kw.com/api/auth/profile/cards?type=other&category_id=\(cardID ?? 0)&user_id=\(HelperConstant.getUserId() ?? 0)", method: .get, parameters: nil, headers: headers).responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(MyCardsModel.self, from: response.data!)
                
                if productResponse.code == 200 {
                    print("success")
                    
                    self.cardsData = productResponse.item?.cards ?? []
                    self.subCategoryCollectionView.reloadData()
                    
                    if self.cardsData.isEmpty == true {
                        self.emptyView.isHidden = false
                    }else {
                        self.emptyView.isHidden = true
                    }
                    
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
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(230))
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

extension SubCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
        return cardsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = subCategoryCollectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCollectionViewCell", for: indexPath) as? SubCategoryCollectionViewCell else { return UICollectionViewCell() }
        
        let item = cardsData[indexPath.row]
        //cell.containerView.backgroundColor = UIColor().colorWithHexString(hexString: item. ?? "")
        cell.catImage.setImageWith(URLS.baseImageURL+(item.mainImage ?? ""), UIImage(named: ""))
        cell.titleLabel.text = item.name
        cell.nameLabel.text = item.owner?.name
        
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = cardsData[indexPath.row]
        let storyborad = UIStoryboard(name: "HawyTabbar", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "subCategoryDetailsViewController") as? subCategoryDetailsViewController
        VC?.catId = item.id
        navigationController?.pushViewController(VC!, animated: false)
    }
    
}
