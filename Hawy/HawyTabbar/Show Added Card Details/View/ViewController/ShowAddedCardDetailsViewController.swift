//
//  ShowAddedCardDetailsViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 31/08/2022.
//

import UIKit
import Alamofire

class ShowAddedCardDetailsViewController: BaseViewViewController, BottomPopupDelegate {
    
    @IBOutlet weak var bannerContainerView: UIView!
    
    @IBOutlet weak var subCategoryBannerCollectionView: UICollectionView!{
        didSet {
            
            subCategoryBannerCollectionView.dataSource = self
            subCategoryBannerCollectionView.delegate = self
            //subCategoryCollectionView.contentInset.top = 30
            subCategoryBannerCollectionView.register(UINib(nibName: "ShowAddedCardDetailsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ShowAddedCardDetailsCollectionViewCell")
            subCategoryBannerCollectionView.register(UINib(nibName: "ShowAddedVideoDetailsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ShowAddedVideoDetailsCollectionViewCell")
            
        }
    }
    
    @IBOutlet weak var whatsAppButton: UIButton!
    @IBOutlet weak var menuButtonOutlet: UIButton!
    @IBOutlet weak var animalNameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var fatherNameLabel: UILabel!
    @IBOutlet weak var motherNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var noteLabel: UITextView!
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var ownerUserImage: UIImageView!
    @IBOutlet weak var firstOwnerView: UIView!
    @IBOutlet weak var secondOwnerView: UIView!
    
    @IBOutlet weak var transferView: UIView!
    @IBOutlet weak var transferHeight: NSLayoutConstraint!
    
    @IBOutlet weak var colorStatusView: UIView!
    @IBOutlet weak var availableWithLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var spoiltByAdminView: UIView!
    @IBOutlet weak var spoiltByAdminViewHeight: NSLayoutConstraint!
    @IBOutlet weak var adminNameLabel: UILabel!
    @IBOutlet weak var adminImage: UIImageView!
    
    var timer = Timer()
    var counter = 0
    
    var cardId: Int?
    //var owners = [ShowCardDetailsInoculation]()
    //var inoculations = [ShowCardDetailsInoculation]()
    var images = [String]()
    var videoURL: String?
    
    var owners = [String]()
    var inoculations = [String]()
    var mainImage = ""
    var video = ""
    
    var myProfile: Bool?
    var ownerId = 0
    var newOwner = 0
    var newName = ""
    var newPhone = ""
    var newImage = ""
    var newCode = ""
    
    var adminId = 0
    var adminName = ""
    var adminCode = ""
    var adminphone = ""
    var admiinImage = ""
    
    var name: String?
    var mother_name: String?
    var father_name: String?
    var age: String?
    var category_id: Int?
    var notes: String?
    var status: String?
    //var inoculations: String?
    //var owners: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if myProfile == false {
            menuButtonOutlet.isHidden = true
        }else {
            menuButtonOutlet.isHidden = false
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCardData(id: cardId, userId: HelperConstant.getUserId() ?? 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bannerContainerView.roundCorners([.bottomLeft, .bottomRight], radius: 20)
        let gradient = UIImage.gradientImage(bounds: ownerUserImage.bounds, colors: [DesignSystem.Colors.PrimaryBlue.color, DesignSystem.Colors.PrimaryOrange.color])
        let gradientColor = UIColor(patternImage: gradient)
        ownerUserImage.layer.borderColor = gradientColor.cgColor
        ownerUserImage.layer.borderWidth = 3
    }
    
    @objc func changeImage() {
        
        //slider.count
        if counter < 5 {
            let index = IndexPath.init(item: counter, section: 0)
            self.subCategoryBannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.subCategoryBannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageControl.currentPage = counter
            counter = 1
        }
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        if myProfile == false {
            dismiss(animated: true, completion: nil)
        }else {
            navigationController?.popViewController(animated: true)
        }
        
        
//        let story = UIStoryboard(name: "HawyTabbar", bundle:nil)
//        let vc = story.instantiateViewController(withIdentifier: "HawyTabbarController") as! HawyTabbarController
//        UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    @IBAction func menuButtonAction(_ sender: Any) {
        
        let storyborad = UIStoryboard(name: "Profile", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "ToSelectEditeViewController") as! ToSelectEditeViewController
        VC.modalPresentationStyle = .overCurrentContext
        VC.modalTransitionStyle = .crossDissolve
        VC.cardId = cardId
        //VC.owners = owners
        //VC.inoculations = inoculations
        VC.showDetails = self
        
        VC.name = name
        VC.mother_name = mother_name
        VC.father_name = father_name
        VC.age = age
        VC.category_id = category_id
        VC.notes = notes
        VC.status = status
        //var inoculations: String?
        //var owners: String?
        
        present(VC, animated: true, completion: nil)
        //navigationController?.pushViewController(VC, animated: true)
        
    }
    
    @IBAction func transfereOwnerButtonAction(_ sender: Any) {
        
        let storyborad = UIStoryboard(name: "Profile", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "TransferOwnershipCardViewController") as! TransferOwnershipCardViewController
        VC.height = 385 //self.view.frame.height - 100
        VC.topCornerRadius = 8
        VC.presentDuration = 0.5
        VC.dismissDuration = 0.5
        VC.popupDelegate = self
        VC.cardId = cardId
        
        //VC.delegateAction = self
        //        VC.dataBackClouser = { [weak self] selected, value in
        //            guard let self = self else { return }
        //            print(selected, value)
        //            self.selectedLanguage = selected
        //            self.valueLanguage = value
        //            self.myLanguagesTFOutlet.text = value.joined(separator: ",")
        //        }
        self.present(VC, animated: true, completion: nil)
        
    }
    
    @IBAction func VaccinationsTapped(_ sender: Any) {
        
        let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "CardVaccinationsViewController") as? CardVaccinationsViewController
        VC?.cardId = cardId
        navigationController?.pushViewController(VC!, animated: false)
        
    }
    @IBAction func ownersTapped(_ sender: Any) {
        
        let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "CardOwnersViewController") as? CardOwnersViewController
        VC?.cardId = cardId
        navigationController?.pushViewController(VC!, animated: false)
        
    }
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        
        //guard let ownerId = self.ownerId ?? 0 else { return }
        
//        if self.ownerId == HelperConstant.getUserId() {
//            print("this is my profile")
//        }else {
//
//            let storyborad = UIStoryboard(name: "HawyTabbar", bundle: nil)
//            let VC = storyborad.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
//            VC?.myProfile = false
//            VC?.ownerId = self.ownerId
//            present(VC!, animated: true, completion: nil)
//
//        }
        
        let storyborad = UIStoryboard(name: "HawyTabbar", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
        VC?.myProfile = false
        VC?.ownerId = self.ownerId
        VC?.newName = newName
        VC?.newPhone = newPhone
        VC?.newImage = newImage
        VC?.newCode = newCode
        print(newOwner)
        present(VC!, animated: true, completion: nil)
        
        
    }
    
    @IBAction func adminButtonTapped(_ sender: Any) {
        
        let storyborad = UIStoryboard(name: "HawyTabbar", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
        VC?.myProfile = false
        VC?.ownerId = self.adminId
        VC?.newName = self.adminName
        VC?.newPhone = self.adminphone
        VC?.newImage = self.admiinImage
        VC?.newCode = self.adminCode
        print(newOwner)
        present(VC!, animated: true, completion: nil)
        
    }
    
    @IBAction func whatsAppButtonTapped(_ sender: Any) {
        
        let phoneNumber = self.adminphone
        let appURL = URL(string: "https://wa.me/\(phoneNumber)")!
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appURL)
            }
        }
        
    }
    
    
    func getCardData(id: Int?, userId: Int?) {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/auth/profile/cards/show?id=\(id ?? 0)&user_id=\(userId ?? 0)", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(ShowCardDetailsModel.self, from: response.data!)
                
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
                
                if productResponse.code == 200 {
                    print("success")
                    
                    self.animalNameLabel.text = productResponse.item?.name ?? ""
                    self.typeLabel.text = productResponse.item?.categoryName ?? ""
                    self.fatherNameLabel.text = productResponse.item?.fatherName ?? ""
                    self.motherNameLabel.text = productResponse.item?.motherName ?? ""
                    self.ageLabel.text = productResponse.item?.age ?? ""
                    self.noteLabel.text = productResponse.item?.notes ?? ""
                    
                    self.name = productResponse.item?.name ?? ""
                    self.mother_name = productResponse.item?.motherName ?? ""
                    self.father_name = productResponse.item?.fatherName ?? ""
                    self.age = productResponse.item?.age ?? ""
                    self.category_id = productResponse.item?.categoryID ?? 0
                    self.notes = productResponse.item?.notes ?? ""
                    self.status = "lost"
                    
                    if productResponse.item?.images?.isEmpty == true {
                        self.images.append(productResponse.item?.mainImage ?? "")
                    }else {
                        self.images = productResponse.item?.images ?? []
                    }
                    
                    self.videoURL = productResponse.item?.video ?? "" //URL(string: productResponse.item?.video ?? "")
                    
                    self.pageControl.numberOfPages = self.images.count
                    
                    for owner in productResponse.item?.owners ?? [] {
                        self.owners.append(owner.name ?? "")
                    }
                    
                    for inoculation in productResponse.item?.inoculations ?? [] {
                        self.inoculations.append(inoculation.name ?? "")
                    }
                    
                    guard let ownerId = productResponse.item?.owner?.id else { return }
                    
                    self.adminId = productResponse.item?.conductor?.id ?? 0
                    self.adminName = productResponse.item?.conductor?.name ?? ""
                    self.adminCode = productResponse.item?.conductor?.code ?? ""
                    self.adminphone = productResponse.item?.conductor?.mobile ?? ""
                    self.admiinImage = productResponse.item?.conductor?.image ?? ""
                    
                   
                        if productResponse.item?.conducted_by == "me" {
                            self.spoiltByAdminView.isHidden = true
                            self.spoiltByAdminViewHeight.constant = 0
                        }else {
                            
                            if productResponse.item?.conductor == nil {
                                
                                self.spoiltByAdminView.isHidden = false
                                self.spoiltByAdminViewHeight.constant = 100
                                self.adminNameLabel.text = "Waiting For Conductor".localized
                                self.whatsAppButton.isHidden = true
                                self.adminImage.isHidden = true
                               
                            }else{
                                
                                self.spoiltByAdminView.isHidden = false
                                self.spoiltByAdminViewHeight.constant = 100
                                self.adminNameLabel.text = productResponse.item?.conductor?.name
                                self.adminImage.loadImage(URLS.baseImageURL+(productResponse.item?.conductor?.image ?? ""))
                            }
                       
                        }
                    
                        
                    if self.ownerId == HelperConstant.getUserId() {
                        self.firstOwnerView.isHidden = false
                        self.secondOwnerView.isHidden = true
                        
                        self.transferView.isHidden = false
                        self.transferHeight.constant = 130
                        
                        self.menuButtonOutlet.isHidden = false
                        
                    }else {
                        self.firstOwnerView.isHidden = true
                        self.secondOwnerView.isHidden = false
                        self.ownerUserImage.loadImage(URLS.baseImageURL+(productResponse.item?.owner?.image ?? ""))
                        
                        self.transferView.isHidden = true
                        self.transferHeight.constant = 0
                        
                        self.menuButtonOutlet.isHidden = true
                        
                    }
                    
//                    if productResponse.item?.purchasedTo == nil {
//
////                        self.ownerId = productResponse.item?.owner?.id ?? 0
////
////                        self.firstOwnerView.isHidden = false
////                        self.secondOwnerView.isHidden = true
//
//                        self.transferView.isHidden = false
//                        self.transferHeight.constant = 130
//
//                        self.menuButtonOutlet.isHidden = false
//
//                    }else{
//                        self.newOwner = productResponse.item?.purchasedTo?.id ?? 0
//
//                        self.ownerId = productResponse.item?.purchasedTo?.id ?? 0
//                        self.newName = productResponse.item?.purchasedTo?.name
//                        ?? ""
//                        self.newPhone = productResponse.item?.purchasedTo?.mobile ?? ""
//                        self.newImage = productResponse.item?.purchasedTo?.image ?? ""
//
//                        self.firstOwnerView.isHidden = true
//                        self.secondOwnerView.isHidden = false
//                        self.ownerUserImage.loadImage(URLS.baseImageURL+(productResponse.item?.owner?.image ?? ""))
//
//                        self.transferView.isHidden = true
//                        self.transferHeight.constant = 0
//
//                        self.menuButtonOutlet.isHidden = true
//
//                    }
                    
                    self.newOwner = productResponse.item?.owner?.id ?? 0
                    
                    self.ownerId = productResponse.item?.owner?.id ?? 0
                    self.newName = productResponse.item?.owner?.name
                    ?? ""
                    self.newPhone = productResponse.item?.owner?.mobile ?? ""
                    self.newImage = productResponse.item?.owner?.image ?? ""
                    
                    if productResponse.item?.status == "pending" {
                        
                        self.colorStatusView.backgroundColor = .lightGray
                        self.availableWithLabel.text = "pending"
                        self.ownerUserImage.isHidden = true
                        self.profileButton.isHidden = true
                        self.transferView.isHidden = true
                        self.transferHeight.constant = 0
                        self.menuButtonOutlet.isHidden = true
                        self.secondOwnerView.layer.borderColor = UIColor.lightGray.cgColor
                        
                    }else if productResponse.item?.status == "active" {
                        
//                        if self.ownerId == HelperConstant.getUserId() {
//
//                            self.colorStatusView.backgroundColor = .systemGreen
//                            self.availableWithLabel.text = "Available"
//                            self.ownerUserImage.isHidden = true
//                            self.profileButton.isHidden = true
//                            self.transferView.isHidden = false
//                            self.transferHeight.constant = 130
//                            self.menuButtonOutlet.isHidden = false
//                            self.secondOwnerView.layer.borderColor = UIColor.systemGreen.cgColor
//
//                        }else {
//
//                            self.colorStatusView.backgroundColor = .systemRed
//                            self.availableWithLabel.text = "Available with"
//                            self.ownerUserImage.loadImage(URLS.baseImageURL+(productResponse.item?.owner?.image ?? ""))
//                            self.transferView.isHidden = true
//                            self.transferHeight.constant = 0
//                            self.menuButtonOutlet.isHidden = true
//                            self.secondOwnerView.layer.borderColor = UIColor.systemRed.cgColor
//
//                        }
                        
                        self.colorStatusView.backgroundColor = .systemGreen
                        self.availableWithLabel.text = "Available"
                        self.ownerUserImage.isHidden = true
                        self.profileButton.isHidden = true
                        self.transferView.isHidden = false
                        self.transferHeight.constant = 130
                        self.menuButtonOutlet.isHidden = false
                        self.secondOwnerView.layer.borderColor = UIColor.systemGreen.cgColor
                        
                    }else if productResponse.item?.status == "purchased" {
                        
                        self.colorStatusView.backgroundColor = .systemRed
                        self.availableWithLabel.text = "Available with"
                        self.ownerUserImage.loadImage(URLS.baseImageURL+(productResponse.item?.owner?.image ?? ""))
                        self.ownerUserImage.isHidden = false
                        self.profileButton.isHidden = false
                        self.transferView.isHidden = true
                        self.transferHeight.constant = 0
                        self.menuButtonOutlet.isHidden = true
                        self.secondOwnerView.layer.borderColor = UIColor.systemRed.cgColor
                        
                    }else {
                        
                        self.colorStatusView.backgroundColor = .black
                        self.availableWithLabel.text = "Lost"
                        self.ownerUserImage.isHidden = true
                        self.profileButton.isHidden = true
                        self.transferView.isHidden = true
                        self.transferHeight.constant = 0
                        self.menuButtonOutlet.isHidden = true
                        self.secondOwnerView.layer.borderColor = UIColor.black.cgColor
                        
                    }
                    
                    self.subCategoryBannerCollectionView.reloadData()
                    
                }
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
}

extension ShowAddedCardDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
//        if videoURL != nil {
//            return 2
//        }else {
//            return 1
//        }
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return images.count
        }else {
//            if videoURL != nil {
//                return 1
//            }else {
//                return 0
//            }
            return 1
        }
        
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = subCategoryBannerCollectionView.dequeueReusableCell(withReuseIdentifier: "ShowAddedCardDetailsCollectionViewCell", for: indexPath) as? ShowAddedCardDetailsCollectionViewCell else { return UICollectionViewCell() }
            
            let item = images[indexPath.row]
            cell.imageOutlet.loadImage(URLS.baseImageURL+(item))
            
            return cell
            
        }else {
            
            guard let cell = subCategoryBannerCollectionView.dequeueReusableCell(withReuseIdentifier: "ShowAddedVideoDetailsCollectionViewCell", for: indexPath) as? ShowAddedVideoDetailsCollectionViewCell else { return UICollectionViewCell() }
            
            
            cell.videoView.contentMode = .scaleAspectFill
            cell.videoView.player?.isMuted = true
            cell.videoView.repeat = .once
            
            //self.videoURL = URL(string: productResponse.item?.video ?? "") //URL(string: "\(movieUrl)")
            
            //cell.videoView.url = self.videoURL
            //cell.videoView.player?.play()
            
            //cell.loadVideo(url: videoURL)
            
            return cell

            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = subCategoryBannerCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.subCategoryBannerCollectionView.contentOffset, size: self.subCategoryBannerCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.subCategoryBannerCollectionView.indexPathForItem(at: visiblePoint) {
            self.pageControl.currentPage = visibleIndexPath.row
        }
    }
    
}
