//
//  ParticipatingAuctionsViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 14/08/2022.
//

import UIKit
import Combine
import Alamofire

class ParticipatingAuctionsViewController: BaseViewViewController {
    
    @IBOutlet weak var collectionContainer: UIView!
    @IBOutlet weak var participatingAuctionsCollection: UICollectionView!{
        didSet{
            
            participatingAuctionsCollection.delegate = self
            participatingAuctionsCollection.dataSource = self
            
            participatingAuctionsCollection.register(UINib(nibName: "ParticipatingAuctionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ParticipatingAuctionCollectionViewCell")
            
        }
    }
    
    @IBOutlet weak var emptyView: UIView!
    
    var subscriber = Set<AnyCancellable>()
    
    private var viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        participatingAuctionsCollection.collectionViewLayout = createCompositionalLayout()
        
        Task {
            do {
                
                let myCards = try await viewModel.profileMyCards(type: "subscribe", id: HelperConstant.getUserId())
                print(myCards)
            }catch {
                // tell the user something went wrong, I hope
                debugPrint(error)
            }
        }
        
        sinkToLoading()
        sinkToReLoading()
        sinkToProfileMyAuctionsModelPublisher()
        sinkToProfileMyAuctionsDataPublisher()
        
        getProfileData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionContainer.roundCorners([.topLeft, .topRight], radius: 20)
    }
    
    func getProfileData() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")"
        ]
        
        //showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/auth/profile?user_id=20", method: .get, parameters: nil, headers: headers)
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
    
    func sinkToLoading() {
//        self.viewModel.loadinState
//            .sink { [weak self] state in
//                self?.handleActivityIndicator(state: state)
//            }.store(in: &subscriber)
        self.viewModel.loadState
            .sink { [weak self] (state) in
                guard let self = self else { return }
                if state {
                    print("show Loading")
                    self.showIndecator()
                }else {
                    print("dismiss Loading")
                    self.hideIndecator()
                }
                
                
                
            }.store(in: &subscriber)
    }
    
    func sinkToReLoading() {
//        self.viewModel.loadinState
//            .sink { [weak self] state in
//                self?.handleActivityIndicator(state: state)
//            }.store(in: &subscriber)
        self.viewModel.reloadingState
            .sink { [weak self] (state) in
                guard let self = self else { return }
                if state {
                    print("show Loading")
                    self.participatingAuctionsCollection.reloadData()
                }
            }.store(in: &subscriber)
    }
    
    func sinkToProfileMyAuctionsModelPublisher() {
        viewModel.profileMyCardsModelPublisher.sink { [weak self] (result) in
            guard let self = self else { return }
            if result?.code == 200 {
//                let stroyboard = UIStoryboard(name: "Authentication", bundle: nil)
//                let VC = stroyboard.instantiateViewController(withIdentifier: "VeificationViewController") as? VeificationViewController
//                VC?.phone = (self.countryCode ?? "") + (self.phoneTF.text ?? "")
//                VC?.countryCode = self.countyCodeTF.text
//                VC?.homeOrNot = false
//                self.navigationController?.pushViewController(VC!, animated: true)
                
//                if self.viewModel.profileMyAuctionsModel?.item?.isEmpty == true {
//                    self.emptyView.isHidden = false
//                }else {
//                    self.emptyView.isHidden = true
//                }
                
                if result?.message == "Unauthenticated." {
                    
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
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }
        }.store(in: &subscriber)
    }
    
    func sinkToProfileMyAuctionsDataPublisher() {
        viewModel.profileMyCardsDataPublisher.sink { [weak self] (result) in
            guard let self = self else { return }
            if result?.isEmpty == true {
                self.emptyView.isHidden = false
            }else {
                self.emptyView.isHidden = true
            }
        }.store(in: &subscriber)
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
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.35))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        //section.orthogonalScrollingBehavior = .continuous
        
        return section
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension ParticipatingAuctionsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.profileMyCardsModel?.item?.cards?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = participatingAuctionsCollection.dequeueReusableCell(withReuseIdentifier: "ParticipatingAuctionCollectionViewCell", for: indexPath) as? ParticipatingAuctionCollectionViewCell else { return UICollectionViewCell() }
        
        let item  = viewModel.profileMyCardsModel?.item?.cards?[indexPath.row]
        //let item2  = viewModel.profileMyCardsModel?.item
        cell.imageCard.loadImage(URLS.baseImageURL+(item?.mainImage ?? ""))
        cell.titleLabel.text = item?.name
        cell.nameLabel.text = item?.owner?.name ?? "" //item?.owner?.name ?? ""
        cell.priceLabel.text = item?.price //"\(item?.price ?? 0.0)"
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item  = viewModel.profileMyCardsModel?.item?.cards?[indexPath.row]
        
//        let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
//        let VC = storyborad.instantiateViewController(withIdentifier: "SalesAuctionsProductsViewController") as? SalesAuctionsProductsViewController
//
//        print(indexPath.row)
//
//        VC?.auctionId = item?.auctionID
//
//        navigationController?.pushViewController(VC!, animated: false)
        
        let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "AuctionProductDetailsViewController") as? AuctionProductDetailsViewController
        VC?.auctionId = item?.auctionID
        VC?.cardId = item?.id
        
//        VC?.price = "\(item.price ?? 0.0)"
//        VC?.images = item.images ?? []
//        VC?.desc = item.notes
//        VC?.time = item.endDate ?? 0
        //VC?.ownerName = item
        //VC?.ownerImage = item
        
        navigationController?.pushViewController(VC!, animated: false)
        
    }
    
}
