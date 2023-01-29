//
//  subCategoryDetailsViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 11/08/2022.
//

import UIKit
import Alamofire

class subCategoryDetailsViewController: BaseViewViewController {
    
    @IBOutlet weak var bannerContainerView: UIView!
    
    @IBOutlet weak var subCategoryBannerCollectionView: UICollectionView!{
        didSet {
            
            subCategoryBannerCollectionView.dataSource = self
            subCategoryBannerCollectionView.delegate = self
            //subCategoryCollectionView.contentInset.top = 30
            subCategoryBannerCollectionView.register(UINib(nibName: "SubCategoryDetailsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SubCategoryDetailsCollectionViewCell")
            
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var animalNameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var fatherNameLabel: UILabel!
    @IBOutlet weak var motherNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var noteLabel: UITextView!
    
    @IBOutlet weak var ownerUserImage: UIImageView!
    
    @IBOutlet weak var colorStatusView: UIView!
    @IBOutlet weak var availableWithLabel: UILabel!
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var profileButton: UIButton!
    
    
    var timer = Timer()
    var counter = 0
    
    var catId: Int?
    
    var images: [String] = []
    
    var owners = [String]()
    var inoculations = [String]()
    
    var ownerId = 0
    
    var newOwner = 0
    var newName = ""
    var newPhone = ""
    var newImage = ""
    var newCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCardData(id: catId, userId: HelperConstant.getUserId() ?? 0)
        
        
//        DispatchQueue.main.async {
//            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
//        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bannerContainerView.roundCorners([.bottomLeft, .bottomRight], radius: 20)
        let gradient = UIImage.gradientImage(bounds: ownerUserImage.bounds, colors: [DesignSystem.Colors.PrimaryBlue.color, DesignSystem.Colors.PrimaryOrange.color])
        let gradientColor = UIColor(patternImage: gradient)
        ownerUserImage.layer.borderColor = gradientColor.cgColor
        ownerUserImage.layer.borderWidth = 3
    }
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        
        //guard let ownerId = self.ownerId ?? 0 else { return }
        
        if self.ownerId == HelperConstant.getUserId() {
            print("this is my profile")
        }else {
            
            let storyborad = UIStoryboard(name: "HawyTabbar", bundle: nil)
            let VC = storyborad.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
            VC?.myProfile = false
            VC?.ownerId = self.ownerId
            VC?.newName = newName
            VC?.newPhone = newPhone
            VC?.newImage = newImage
            VC?.newCode = newCode
            present(VC!, animated: true, completion: nil)
            
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
                
                if productResponse.code == 200 {
                    print("success")
                    
                    self.animalNameLabel.text = productResponse.item?.name ?? ""
                    self.typeLabel.text = productResponse.item?.categoryName ?? ""
                    self.fatherNameLabel.text = productResponse.item?.fatherName ?? ""
                    self.motherNameLabel.text = productResponse.item?.motherName ?? ""
                    self.ageLabel.text = productResponse.item?.age ?? ""
                    self.noteLabel.text = productResponse.item?.notes ?? ""
                    
                    self.ownerId = productResponse.item?.owner?.id ?? 0
                    
                    self.ownerUserImage.loadImage(URLS.baseImageURL+(productResponse.item?.owner?.image ?? ""))
                    
                    if productResponse.item?.images?.isEmpty == true {
                        self.images.append(productResponse.item?.mainImage ?? "")
                    }else {
                        self.images = productResponse.item?.images ?? []
                    }
                    
                    
                    self.pageControl.numberOfPages = self.images.count
                    
                    for owner in productResponse.item?.owners ?? [] {
                        self.owners.append(owner.name ?? "")
                    }
                    
                    for inoculation in productResponse.item?.inoculations ?? [] {
                        self.inoculations.append(inoculation.name ?? "")
                    }
                    
                    self.newOwner = productResponse.item?.owner?.id ?? 0
                    
                    self.ownerId = productResponse.item?.owner?.id ?? 0
                    self.newName = productResponse.item?.owner?.name
                    ?? ""
                    self.newPhone = productResponse.item?.owner?.mobile ?? ""
                    self.newImage = productResponse.item?.owner?.image ?? ""
                    
                    if productResponse.item?.status == "pending" {
                        self.colorStatusView.backgroundColor = .lightGray
                        self.availableWithLabel.text = "pending"
                    }else if productResponse.item?.status == "active" {
                        self.colorStatusView.backgroundColor = .systemGreen
                        self.availableWithLabel.text = "Available"
                    }else if productResponse.item?.status == "purchased" {
                        self.colorStatusView.backgroundColor = .systemRed
                        self.availableWithLabel.text = "Available with"
                        self.ownerImage.loadImage(URLS.baseImageURL+(productResponse.item?.owner?.image ?? ""))
                    }else {
                        self.colorStatusView.backgroundColor = .black
                        self.availableWithLabel.text = "Lost"
                    }
                    
                    self.subCategoryBannerCollectionView.reloadData()
                    
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
    
    
    @objc func changeImage() {
        
        //slider.count
        if counter < images.count {
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
    
    @IBAction func VaccinationsTapped(_ sender: Any) {
        
        let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "CardVaccinationsViewController") as? CardVaccinationsViewController
        VC?.cardId = catId
        navigationController?.pushViewController(VC!, animated: false)
        
    }
    @IBAction func ownersTapped(_ sender: Any) {
        
        let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "CardOwnersViewController") as? CardOwnersViewController
        VC?.cardId = catId
        navigationController?.pushViewController(VC!, animated: false)
        
    }
    
//    @IBAction func infoTapped(_ sender: Any) {
//        
//        let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
//        let VC = storyborad.instantiateViewController(withIdentifier: "CardInfoViewController") as? CardInfoViewController
//        VC?.cardId = catId
//        navigationController?.pushViewController(VC!, animated: false)
//        
//    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension subCategoryDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = subCategoryBannerCollectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryDetailsCollectionViewCell", for: indexPath) as? SubCategoryDetailsCollectionViewCell else { return UICollectionViewCell() }
        
        let item = images[indexPath.row]
        cell.imageOutlet.loadImage(URLS.baseImageURL+(item))
        
        return cell
        
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
