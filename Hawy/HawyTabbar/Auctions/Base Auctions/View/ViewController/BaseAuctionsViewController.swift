//
//  BaseAuctionsViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 11/08/2022.
//

import UIKit
import Combine
import Alamofire

class BaseAuctionsViewController: UIViewController {
    
    @IBOutlet weak var collectionContainer: UIView!
    @IBOutlet weak var auctionsCollectionView: UICollectionView! {
        didSet {
            
            auctionsCollectionView.dataSource = self
            auctionsCollectionView.delegate = self
            
            auctionsCollectionView.register(UINib(nibName: "BannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BannerCollectionViewCell")
            auctionsCollectionView.register(UINib(nibName: "AucationsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AucationsCollectionViewCell")
            
        }
    }
    
    var images = ["hummer-1", "subAuc", "livee", "sale"]
    var titles = ["Sale Aucations".localized, "Participating Auctions".localized ,"Live Auctions".localized, "Stock Auctions".localized]
    
    var subscriber = Set<AnyCancellable>()
    
    private var viewModel = HomeViewModel()
    
    @Published var sliderData = [SliderAuctionData]()
    
    @IBOutlet weak var notificationButton: UIButton!
    
    var timer = Timer()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auctionsCollectionView.semanticContentAttribute = .forceRightToLeft
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
        
        auctionsCollectionView.collectionViewLayout = createCompositionalLayout()
        
        Task {
            let slider = try await viewModel.getSlider()
            print(slider)
            sinkToLoading()
            sinkToSliderModel()
            sinkToSliderData()
            ReloadingState()
            
            
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        readNotification()
        
    }
    
    override func viewDidLayoutSubviews() {
        //super.updateViewConstraints()
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionContainer.roundCorners([.topLeft, .topRight], radius: 20)
            self.auctionsCollectionView.contentInset.top = 20
            self.auctionsCollectionView.contentInset.bottom = 100
            
            //self.auctionsCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
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
                    self.auctionsCollectionView.reloadData()
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
            
            
            for type in result ?? [] {
                if type.type == "ad" {
                    
                    //self.sliderData.append(SliderAuctionData(id: type.id, auction_id: type.auction_id, card_id: type.card_id, name: type.name, itemDescription: type.itemDescription, color: type.color, type: type.type, image: type.image, date: type.date, start_color: type.start_color, end_color: type.end_color))
                    
                }else if type.type == "welcome" {

                    //self.sliderData.append(SliderAuctionData(id: type.id, auction_id: type.auction_id, card_id: type.card_id, name: type.name, itemDescription: type.itemDescription, color: type.color, type: type.type, image: type.image, date: type.date, start_color: type.start_color, end_color: type.end_color))

                }else {
                    
                    self.sliderData.append(SliderAuctionData(id: type.id, auction_id: type.auction_id, card_id: type.card_id, name: type.name, itemDescription: type.itemDescription, color: type.color, type: type.type, image: type.image, date: type.date, start_color: type.start_color, end_color: type.end_color))
                    
                }
            }
            
            //self.sliderData = result ?? []
        }.store(in: &subscriber)
    }
    
    @objc func changeImage() {
        
        //slider.count
        if counter < sliderData.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.auctionsCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            //pageControl.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.auctionsCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
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
            return createFirstSection()
        case 1:
            return createFourthSection()
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
    
    func createFourthSection() -> NSCollectionLayoutSection {
        
        let inset: CGFloat = 5
        
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.27))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        //section.orthogonalScrollingBehavior = .continuous
        
        // supplementary
        let hearderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: hearderSize, elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
        
    }
    
    @IBAction func notificationButtonTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Notifications", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        
        navigationController?.pushViewController(VC, animated: true)
        
    }
    
}

extension BaseAuctionsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return section == 2 ? 15 : 5
        switch section {
        case 0:
            return sliderData.count
        case 1:
            return 4
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
//            guard let cell = auctionsCollectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as? BannerCollectionViewCell else { return UICollectionViewCell() }
//
//            return cell
            
//            let item = sliderData[indexPath.row]
//            if item.type != "ad" {
//
//            }else {
//                return UICollectionViewCell()
//            }
            let item = sliderData[indexPath.row]
            guard let cell = auctionsCollectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as? BannerCollectionViewCell else { return UICollectionViewCell() }
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
            
        case 1:
            guard let cell = auctionsCollectionView.dequeueReusableCell(withReuseIdentifier: "AucationsCollectionViewCell", for: indexPath) as? AucationsCollectionViewCell else { return UICollectionViewCell() }
            
            
            
            if indexPath.row == 0 {
                cell.arrowImage.image = UIImage(named: "Group 52687")
            }else if indexPath.row == 1 {
                cell.arrowImage.image = UIImage(named: "Group 52686")
            }else if indexPath.row == 2 {
                cell.arrowImage.image = UIImage(named: "Group 52688")
            }else {
                cell.arrowImage.image = UIImage(named: "Group 52689")
            }
            
            if indexPath.row == 0 {
                
                cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                cell.containerView.gradientLayer.colors = [DesignSystem.Colors.PrimaryLightBlue.color.cgColor, DesignSystem.Colors.PrimaryClearBlue.color.cgColor]
                
            }else if indexPath.row == 1 {
                
                cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                cell.containerView.gradientLayer.colors =  [DesignSystem.Colors.PrimaryLightPurple.color.cgColor, DesignSystem.Colors.PrimaryClearPurple.color.cgColor]
                
            }else if indexPath.row == 2 {
                
                cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                cell.containerView.gradientLayer.colors = [DesignSystem.Colors.PrimaryLightRed.color.cgColor, DesignSystem.Colors.PrimaryClearRed.color.cgColor]
                
            }else {
                cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                cell.containerView.gradientLayer.colors = [DesignSystem.Colors.PrimaryClearGreen.color.cgColor, DesignSystem.Colors.PrimaryLightGreen.color.cgColor]
                
            }
            
            cell.imageType.image = UIImage(named: images[indexPath.row])
            cell.titleLabel.text = titles[indexPath.row]
            
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
            
        case 0:
            
            let item = sliderData[indexPath.row]
            if item.type == "live_auction" { //live_auction //sales_auction
                
//                let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
//                let VC = storyborad.instantiateViewController(withIdentifier: "LiveAuctionsDetailsViewController") as? LiveAuctionsDetailsViewController
//
//                VC?.auction_id = item.auction_id
//
//                navigationController?.pushViewController(VC!, animated: false)
                
                let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
                let VC = storyborad.instantiateViewController(withIdentifier: "SalesAuctionsProductsViewController") as? SalesAuctionsProductsViewController
                
                print(indexPath.row)
                
                VC?.isLive = true
                VC?.auctionId = item.auction_id
                
                navigationController?.pushViewController(VC!, animated: false)
                
            }else if item.type == "ad" {
                
                let item  = sliderData[indexPath.row]
                
                
                
                let storyborad = UIStoryboard(name: "Profile", bundle: nil)
                let VC = storyborad.instantiateViewController(withIdentifier: "ShowAddedCardDetailsViewController") as? ShowAddedCardDetailsViewController
                VC?.cardId = item.card_id
                //VC?.myProfile = self.myProfile
                navigationController?.pushViewController(VC!, animated: false)
                
            }else {
                
                //let item = viewModel.profileMyAuctionsModel?.item?[indexPath.row]
                
                let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
                let VC = storyborad.instantiateViewController(withIdentifier: "SalesAuctionsProductsViewController") as? SalesAuctionsProductsViewController
                
//                VC?.name = item.name ?? ""
//                VC?.user = item.owner?.name ?? ""
//                VC?.date = "\(item.startDate ?? 0)"
//                VC?.image = item.owner?.image ?? ""
//                VC?.bidsCount = item.bidCounter ?? 0
                print(indexPath.row)
                //VC?.cards = item.cards ?? []
                VC?.auctionId = item.auction_id
                
                navigationController?.pushViewController(VC!, animated: false)
                
//                let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
//                let VC = storyborad.instantiateViewController(withIdentifier: "AuctionProductDetailsViewController") as? AuctionProductDetailsViewController
//
//                VC?.auctionId = item.id
//                VC?.cardId = item.id
//
//                //VC?.price = "\(item.price ?? 0.0)"
//                //VC?.images = item.images ?? []
//                //VC?.desc = item.notes
//                //VC?.time = item.endDate ?? 0
//
//                navigationController?.pushViewController(VC!, animated: false)
                
            }
            //break
        case 1:
            
            if indexPath.row == 0 {
                let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
                let VC = storyborad.instantiateViewController(withIdentifier: "SalesAuctionViewController") as? SalesAuctionViewController
                navigationController?.pushViewController(VC!, animated: false)
            }else if indexPath.row == 1 {
                let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
                let VC = storyborad.instantiateViewController(withIdentifier: "ParticipatingAuctionsViewController") as? ParticipatingAuctionsViewController
                navigationController?.pushViewController(VC!, animated: false)
            }else if indexPath.row == 2 {
                let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
                let VC = storyborad.instantiateViewController(withIdentifier: "LiveAuctionsViewController") as? LiveAuctionsViewController
                navigationController?.pushViewController(VC!, animated: false)
            }else {
                let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
                let VC = storyborad.instantiateViewController(withIdentifier: "StockAuctionViewController") as? StockAuctionViewController
                navigationController?.pushViewController(VC!, animated: false)
            }
            
        default:
            break
        }
    }
    
}
