//
//  HomeVC.swift
//  Hawy
//
//  Created by ahmed abu elregal on 06/08/2022.
//

import UIKit
import Combine
import Alamofire

class HomeVC: BaseViewViewController {
    
    @IBOutlet weak var homeCollectionView: UICollectionView! {
        didSet {
            
            homeCollectionView.dataSource = self
            homeCollectionView.delegate = self
            //homeCollectionView.register(UINib(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: "header", withReuseIdentifier: "HeaderView")
            //homeCollectionView.register(UINib(nibName: "BannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BannerCollectionViewCell")
            homeCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
            
        }
    }
    
    @IBOutlet weak var sliderCollectionView: UICollectionView! {
        didSet {
            
            sliderCollectionView.dataSource = self
            sliderCollectionView.delegate = self
            //homeCollectionView.register(UINib(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: "header", withReuseIdentifier: "HeaderView")
            sliderCollectionView.register(UINib(nibName: "BannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BannerCollectionViewCell")
            //homeCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
            
        }
    }
    @IBOutlet weak var sliderCollectionHeight: NSLayoutConstraint!
    
    @IBOutlet weak var notificationButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    weak var categoryVC:CategoryViewController?
    
    
    var subscriber = Set<AnyCancellable>()
    
    private var viewModel = HomeViewModel()
    private var categoryViewModel = CategoryViewModel()
    
    @Published var sliderData = [SliderData]()
    @Published var categoryData = [CategoryData]()
    
    var time: Int?
    var currentTime: Int?
    
    var timer = Timer()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeCollectionView.collectionViewLayout = createCompositionalLayout()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task {
            
            if HelperConstant.getToken() == "" || HelperConstant.getToken() == nil {
                print("Cant show slider")
            }else {
                let slider = try await viewModel.getSlider()
                print(slider)
                
                getProfileData()
                readNotification()
                
            }
            
            
            let category = try await categoryViewModel.getCategory()
            print(category)
            sinkToLoading()
            sinkToSliderModel()
            sinkToSliderData()
            sinkToCategoryModel()
            sinkToCategoryData()
            ReloadingState()
            
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        //super.updateViewConstraints()
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            //self.homeCollectionView.contentInset.top = 30
            self.homeCollectionView.contentInset.bottom = 50
            
            //self.homeCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
            
        }
        
    }
    
//    override func viewWillLayoutSubviews() {
//        super.updateViewConstraints()
//
//        DispatchQueue.main.async { [weak self] in
//            //your code here
//            guard let self = self else { return }
//
//            self.sliderCollectionHeight.constant = self.sliderCollectionView.contentSize.height
//
//        }
//
//    }
    
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
    
    func readNotification() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")"
        ]
        
        //showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/notifications/status", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(ReadNotificationModel.self, from: response.data!)
                
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
                //
                if productResponse.item?.status == true {
                    self.notificationButton.setImage(UIImage(named: "notification"), for: .normal)
                }else {
                    self.notificationButton.setImage(UIImage(named: "Group 52267"), for: .normal)
                }
                
                //self.hideIndecator()
            } catch {
                //self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
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
                    //self.homeCollectionView.reloadData()
                    self.sliderCollectionView.reloadData()
                }else {
                    print("not ReloadData")
                }
            }.store(in: &subscriber)
        categoryViewModel.reloadingState
            .sink { [weak self] state in
                guard let self = self else { return }
                if state {
                    self.homeCollectionView.reloadData()
                }else {
                    print("not ReloadData")
                }
            }.store(in: &subscriber)
        
    }
    
    func sinkToSliderModel() {
        viewModel.sliderModelPublisher.sink { [weak self] result in
            guard let self = self else { return }
            if result?.code == 200 {
                print("show Sliders")
            }
        }.store(in: &subscriber)
    }
    
    func sinkToSliderData() {
        viewModel.sliderDataPublisher.sink { [weak self] result in
            guard let self = self else { return }
            print(result)
            self.sliderData = result ?? []
            
            if self.sliderData.count == 0 {
                self.sliderCollectionHeight.constant = 0
                self.sliderCollectionView.isHidden = true
            }else {
                self.sliderCollectionHeight.constant = 160
                self.sliderCollectionView.isHidden = false
                DispatchQueue.main.async {
                    self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
                }
                
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
    
    @objc func changeImage() {
        
        //slider.count
        if counter < sliderData.count {
            let index = IndexPath(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            //pageControl.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            //pageControl.currentPage = counter
            counter = 1
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
            return createCategorySection()
        case 1:
            return createCategorySection()
        default:
            return createFirstSection()
        }
    }
    
    func createFirstSection() -> NSCollectionLayoutSection {
        
        let inset: CGFloat = 5
        
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // group
        var height = 0.0
        if HelperConstant.getToken() == "" || HelperConstant.getToken() == nil || sliderData.isEmpty == true {
            print("Cant show slider")
            height = 0.0
        }else {
            height = 0.24
        }
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        return section
        
    }
    
    func createCategorySection() -> NSCollectionLayoutSection {
        
        let inset: CGFloat = 5
        
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: 10, bottom: inset, trailing: 10)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        //section.orthogonalScrollingBehavior = .continuous
        
        return section
        
    }
    
    func createSecondSection() -> NSCollectionLayoutSection {
        
        let inset: CGFloat = 5
        
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(0.25))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        // supplementary
        let hearderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: hearderSize, elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
        
    }
    
    func createThirdSection() -> NSCollectionLayoutSection {
        
        let inset: CGFloat = 5
        
        // item
        let smallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
        let smallitem = NSCollectionLayoutItem(layoutSize: smallItemSize)
        smallitem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let largeitem = NSCollectionLayoutItem(layoutSize: largeItemSize)
        largeitem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // group
        let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1))
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitems: [smallitem])
        
        let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.3))
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitems: [largeitem, verticalGroup, verticalGroup])
        
        // section
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        
        // supplementary
        let hearderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: hearderSize, elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
        
    }
    
    func createFourthSection() -> NSCollectionLayoutSection {
        
        let inset: CGFloat = 5
        
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.25))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        //section.orthogonalScrollingBehavior = .continuous
        
        // supplementary
        let hearderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: hearderSize, elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
        
    }
    
    func createZoomedSection() -> NSCollectionLayoutSection {
        
        let inset: CGFloat = 5
        
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 3.0), heightDimension: .fractionalWidth(1.0 / 3.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        // supplementary
        let hearderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: hearderSize, elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.7
                let maxScale: CGFloat = 1.1
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        
        return section
        
    }
    
    func createFifthSection() -> NSCollectionLayoutSection {
        
        let inset: CGFloat = 5
        
        // item
        let smallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.25))
        let smallitem = NSCollectionLayoutItem(layoutSize: smallItemSize)
        smallitem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.75), heightDimension: .fractionalHeight(1))
        let largeitem = NSCollectionLayoutItem(layoutSize: largeItemSize)
        largeitem.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // group
        let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1))
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitem: smallitem, count: 3)
        
        let horizontalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.4))
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizontalGroupSize, subitems: [verticalGroup, largeitem])
        
        // section
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        
        // supplementary
        let hearderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: hearderSize, elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
        
    }
    
    func createZooomedSection() -> NSCollectionLayoutSection {
        let carouselItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .absolute(200)))
        carouselItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 2, bottom: 2, trailing: 2)
        
        let carouselGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200)), subitems: [carouselItem])
        
        let carouselSection = NSCollectionLayoutSection(group: carouselGroup)
        carouselSection.orthogonalScrollingBehavior = .paging
        
        carouselSection.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.7
                let maxScale: CGFloat = 1.1
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        return carouselSection
//        let layout = UICollectionViewCompositionalLayout(section: carouselSection)
//        return layout
    }
    
    @IBAction func settingButtonTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "HawyTabbar", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        VC.homeVC = self
        present(VC, animated: true, completion: nil)
        //navigationController?.pushViewController(VC, animated: true)
        
    }
    
    @IBAction func notificationButtonTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Notifications", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        
        navigationController?.pushViewController(VC, animated: true)
        
    }
    
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if collectionView == sliderCollectionView {
            //self.viewWillLayoutSubviews()
            //self.sliderCollectionView.layoutIfNeeded()
        }else {
            
//            DispatchQueue.main.async {
//                let firstAnimation = CollectionViewAnimationFactory.makeSlideIn(duration: 0.5, delayFactor: 0.05)
//                let secondAnimation = CollectionViewAnimationFactory.makeFade(duration: 0.5, delayFactor: 0.05)
//                let thirdAnimation = CollectionViewAnimationFactory.makeMoveUpWithBounce(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
//                let fourthAnimation = CollectionViewAnimationFactory.makeMoveUpWithFade(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
//                //
//                let animator = CollectionViewAnimator(animation: firstAnimation)
//                animator.animate(cell: cell, at: indexPath, in: collectionView)
//            }
            
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1 //2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return section == 2 ? 15 : 5
//        switch section {
//        case 0:
//            return sliderData.count //viewModel.sliderData?.count ?? 0
//        case 1:
//            return categoryData.count
//        default:
//            return 0
//        }
        
        if collectionView == sliderCollectionView {
            return sliderData.count
        }else {
            return categoryData.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        switch indexPath.section {
//        case 0:
//            let item = sliderData[indexPath.row]
//
//            guard let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as? BannerCollectionViewCell else { return UICollectionViewCell() }
//            //cell.containerView.backgroundColor = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
//            //cell.layer.cornerRadius = 10
//
//            cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//            cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
//            cell.containerView.gradientLayer.colors = [UIColor().colorWithHexString(hexString: item.start_color ?? "").cgColor, UIColor().colorWithHexString(hexString: item.end_color ?? "").cgColor]
//
//            cell.sliderImage.loadImage(URLS.baseImageURL+(item.image ?? ""))
//            cell.sliderTitle.text = item.name
//            cell.sliderDate.text = item.date
//            cell.sliderAuctionTitle.text = item.type
//            cell.sliderDesc.text = item.itemDescription
//            return cell
//
//        case 1:
//            guard let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
//            //cell.containerView.backgroundColor = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
//            //cell.layer.cornerRadius = 10
//
//            let item = categoryData[indexPath.row]
//            cell.containerView.backgroundColor = UIColor().colorWithHexString(hexString: item.color ?? "")
//            cell.categoryImage.loadImage(URLS.baseImageURL+(item.image ?? ""))
//            cell.titleLabel.text = item.name
//
//            return cell
//        default:
//            return UICollectionViewCell()
//        }
        
        if collectionView == sliderCollectionView {
            
            let item = sliderData[indexPath.row]
            
            guard let cell = sliderCollectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as? BannerCollectionViewCell else { return UICollectionViewCell() }
            //cell.containerView.backgroundColor = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
            //cell.layer.cornerRadius = 10
            
            cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            cell.containerView.gradientLayer.colors = [UIColor().colorWithHexString(hexString: item.start_color ?? "").cgColor, UIColor().colorWithHexString(hexString: item.end_color ?? "").cgColor]
            
            cell.sliderImage.loadImage(URLS.baseImageURL+(item.image ?? ""))
            cell.sliderTitle.text = item.name
            cell.sliderDate.text = item.date
            cell.sliderAuctionTitle.text = item.type
            cell.sliderDesc.text = item.itemDescription
            return cell
            
        }else {
            
            guard let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
            //cell.containerView.backgroundColor = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
            //cell.layer.cornerRadius = 10
            
            let item = categoryData[indexPath.row]
            cell.containerView.backgroundColor = UIColor().colorWithHexString(hexString: item.color ?? "")
            cell.categoryImage.loadImage(URLS.baseImageURL+(item.image ?? ""))
            cell.titleLabel.text = item.name
            
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
//        switch indexPath.section {
//
//        case 0:
//
//            let item = sliderData[indexPath.row]
//
//            //self.time = (item.item?.startDate ?? 0)// * 1000
//            //self.currentTime = Int(Date.currentTimeStamp)
//
//            if item.type == "live_auction" { //live_auction //sales_auction
//
////                let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
////                let VC = storyborad.instantiateViewController(withIdentifier: "LiveAuctionsDetailsViewController") as? LiveAuctionsDetailsViewController
////
////                VC?.auction_id = item.auction_id
////
////                navigationController?.pushViewController(VC!, animated: false)
//
//                let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
//                let VC = storyborad.instantiateViewController(withIdentifier: "SalesAuctionsProductsViewController") as? SalesAuctionsProductsViewController
//
//                print(indexPath.row)
//
//                VC?.isLive = true
//                VC?.auctionId = item.auction_id
//
//                navigationController?.pushViewController(VC!, animated: false)
//
//            }else if item.type == "ad" {
//
//                let item  = sliderData[indexPath.row]
//
//                let storyborad = UIStoryboard(name: "Profile", bundle: nil)
//                let VC = storyborad.instantiateViewController(withIdentifier: "ShowAddedCardDetailsViewController") as? ShowAddedCardDetailsViewController
//                VC?.cardId = item.card_id
//                //VC?.myProfile = self.myProfile
//                navigationController?.pushViewController(VC!, animated: false)
//
//            }else if item.type == "welcome" {
//
//            }else {
//
//                //let item = viewModel.profileMyAuctionsModel?.item?[indexPath.row]
//
//                let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
//                let VC = storyborad.instantiateViewController(withIdentifier: "SalesAuctionsProductsViewController") as? SalesAuctionsProductsViewController
//
//                print(indexPath.row)
//
//                VC?.auctionId = item.auction_id
//
//                navigationController?.pushViewController(VC!, animated: false)
//
//            }
//
//        case 1:
//
//            if HelperConstant.getToken() == "" || HelperConstant.getToken() == nil {
//
//                let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
//
//
//                    let story = UIStoryboard(name: "Authentication", bundle:nil)
//                    let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                    UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
//                    UIApplication.shared.windows.first?.makeKeyAndVisible()
//
//                }
//                let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
//                alert.addAction(okAction)
//                alert.addAction(cancelAction)
//                present(alert, animated: true, completion: nil)
//
//            }else {
//
//                let item = categoryData[indexPath.row]
//
//                if item.has_subscription == false {
//
//                    let alert = UIAlertController(title: "", message: "please, make Subscription for this category".localized, preferredStyle: .alert)
//                    let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
//
//                        let story = UIStoryboard(name: "Subscriptions", bundle:nil)
//                        let vc = story.instantiateViewController(withIdentifier: "SubscriptionsViewController") as! SubscriptionsViewController
//                        self.navigationController?.pushViewController(vc, animated: false)
//
//                    }
//                    let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
//                    alert.addAction(okAction)
//                    alert.addAction(cancelAction)
//                    present(alert, animated: true, completion: nil)
//
//                }else {
//
//                    if item.has_sub == true {
//
//                        let storyborad = UIStoryboard(name: "HawyTabbar", bundle: nil)
//                        let VC = storyborad.instantiateViewController(withIdentifier: "CategoryViewController") as? CategoryViewController
//                        VC?.subCategoryID = item.id
//                        VC?.categoryTitle = item.name
//                        navigationController?.pushViewController(VC!, animated: false)
//
//                    }else {
//
//                        //let item = cardsData2[indexPath.row]
//                        let storyborad = UIStoryboard(name: "HawyTabbar", bundle: nil)
//                        let VC = storyborad.instantiateViewController(withIdentifier: "SubCategoryViewController") as? SubCategoryViewController
//                        VC?.cardID = item.id
//                        navigationController?.pushViewController(VC!, animated: false)
//
////                        let storyborad = UIStoryboard(name: "HawyTabbar", bundle: nil)
////                        let VC = storyborad.instantiateViewController(withIdentifier: "CategoryViewController") as? CategoryViewController
////                        VC?.subCategoryID = item.id
////                        VC?.categoryTitle = item.name
////                        navigationController?.pushViewController(VC!, animated: false)
//
//                    }
//
//                }
//
//            }
//
////            if categoryVC == nil {
////                categoryVC = Storyboard.HawyTabbar.viewController(CategoryViewController.self)
////
////                if categoryVC?.parent == nil {
////
////                    self.addChild(categoryVC!)
////                    categoryVC?.homeViewController = self
////                    //self.containerView.addSubview(categoryVC!.view)
////                    self.view.addSubview(categoryVC!.view)
////                    categoryVC?.didMove(toParent: self)
////                    categoryVC?.action = {
////                        self.categoryVC?.willMove(toParent: nil)
////                        self.categoryVC?.view.removeFromSuperview()
////                        self.categoryVC?.removeFromParent()
////                        self.categoryVC = nil
////                    }
////                    //self.view.bringSubviewToFront(self.containerView)
////
////                }
////
////            }
//
//        default:
//            break
//        }
        
        if collectionView == sliderCollectionView {
            
            let item = sliderData[indexPath.row]
            
            //self.time = (item.item?.startDate ?? 0)// * 1000
            //self.currentTime = Int(Date.currentTimeStamp)
            
            if item.type == "live_auction" { //live_auction //sales_auction
                
//                let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
//                let VC = storyborad.instantiateViewController(withIdentifier: "LiveAuctionsDetailsViewController") as? LiveAuctionsDetailsViewController
//
//                VC?.auction_id = item.auction_id
//
//                navigationController?.pushViewController(VC!, animated: false)
                
//                let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
//                let VC = storyborad.instantiateViewController(withIdentifier: "SalesAuctionsProductsViewController") as? SalesAuctionsProductsViewController
//                let VC = NewLiveViewController()
//                print(indexPath.row)
//
//                //VC.isLive = true
//                VC.auction_id = item.auction_id
//
                let VC = AuctionLiveVideo()
                VC.auctionID = item.auction_id
                navigationController?.pushViewController(VC, animated: false)
   
                
            }else if item.type == "ad" {
                
                let item  = sliderData[indexPath.row]
                
                let storyborad = UIStoryboard(name: "Profile", bundle: nil)
                let VC = storyborad.instantiateViewController(withIdentifier: "ShowAddedCardDetailsViewController") as? ShowAddedCardDetailsViewController
                VC?.cardId = item.card_id
                //VC?.myProfile = self.myProfile
                navigationController?.pushViewController(VC!, animated: false)
                
            }else if item.type == "welcome" {
                
                let storyborad = UIStoryboard(name: "Notifications", bundle: nil)
                let VC = storyborad.instantiateViewController(withIdentifier: "WelcomrDescriptionViewController") as? WelcomrDescriptionViewController
                
                print(indexPath.row)
                
                VC?.date = item.date
                VC?.welcomeTitle = item.name
                VC?.desc = item.itemDescription
                
                navigationController?.pushViewController(VC!, animated: false)
                
            }else {
                
                //let item = viewModel.profileMyAuctionsModel?.item?[indexPath.row]
                
                let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
                let VC = storyborad.instantiateViewController(withIdentifier: "SalesAuctionsProductsViewController") as? SalesAuctionsProductsViewController
                
                print(indexPath.row)
                
                VC?.auctionId = item.auction_id
                
                navigationController?.pushViewController(VC!, animated: false)
                
            }
            
        }else {
            
            if HelperConstant.getToken() == "" || HelperConstant.getToken() == nil {
                
                let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
                    
                    
                    let story = UIStoryboard(name: "Authentication", bundle:nil)
                    let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                    
                }
                let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
                
            }else {
                
                let item = categoryData[indexPath.row]
                
                if item.has_subscription == false {
                    
                    let alert = UIAlertController(title: "", message: "please, make Subscription for this category".localized, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
                        
                        let story = UIStoryboard(name: "Subscriptions", bundle:nil)
                        let vc = story.instantiateViewController(withIdentifier: "SubscriptionsViewController") as! SubscriptionsViewController
                        self.navigationController?.pushViewController(vc, animated: false)
                        
                    }
                    let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    alert.addAction(cancelAction)
                    present(alert, animated: true, completion: nil)
                    
                }else {
                    
                    if item.has_sub == true {
                        
                        let storyborad = UIStoryboard(name: "HawyTabbar", bundle: nil)
                        let VC = storyborad.instantiateViewController(withIdentifier: "CategoryViewController") as? CategoryViewController
                        VC?.subCategoryID = item.id
                        VC?.categoryTitle = item.name
                        navigationController?.pushViewController(VC!, animated: false)
                        
                    }else {
                        
                        //let item = cardsData2[indexPath.row]
                        let storyborad = UIStoryboard(name: "HawyTabbar", bundle: nil)
                        let VC = storyborad.instantiateViewController(withIdentifier: "SubCategoryViewController") as? SubCategoryViewController
                        VC?.cardID = item.id
                        navigationController?.pushViewController(VC!, animated: false)
                        
//                        let storyborad = UIStoryboard(name: "HawyTabbar", bundle: nil)
//                        let VC = storyborad.instantiateViewController(withIdentifier: "CategoryViewController") as? CategoryViewController
//                        VC?.subCategoryID = item.id
//                        VC?.categoryTitle = item.name
//                        navigationController?.pushViewController(VC!, animated: false)
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == sliderCollectionView {
            
//            if self.sliderData.count == 0 {
//                //self.sliderCollectionHeight.constant = 0
//                return CGSize(width: (sliderCollectionView.frame.size.width), height: 0)
//
//            }else {
//                //self.sliderCollectionHeight.constant = 160
//                return CGSize(width: (sliderCollectionView.frame.size.width), height: 160)
//
//            }
            
            return CGSize(width: (sliderCollectionView.frame.size.width), height: 160)
            
        }else {
            return CGSize()
        }
        
    }
    
}

// MARK: - AddSaleAuctionModel
struct ReadNotificationModel: Codable {
    let code: Int?
    let message: String?
    let item: ReadNotificationItem?
}

// MARK: - Item
struct ReadNotificationItem: Codable {
    let status: Bool?
}
