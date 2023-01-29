//
//  SplashViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 04/08/2022.
//

import UIKit
import Alamofire

// MARK: - AddSaleAuctionModel
struct SplashModel: Codable {
    let code: Int?
    let message: String?
    let item: SplashItem?
}

// MARK: - Item
struct SplashItem: Codable {
    let firstPage, secondPage, thirdPage: String?

    enum CodingKeys: String, CodingKey {
        case firstPage = "first_page"
        case secondPage = "second_page"
        case thirdPage = "third_page"
    }
}

class SplashViewController: BaseViewViewController {
    
    @IBOutlet weak var splashCollectionView: UICollectionView!{
        didSet {
            
            splashCollectionView.dataSource = self
            splashCollectionView.delegate = self
            
            splashCollectionView.register(UINib(nibName: "SplashCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SplashCollectionViewCell")
            
        }
    }
    
    @IBOutlet weak var startNowButtonOutlet: GradientButton!
    
    var images2: [String] = []
    
    var images = ["firstOnboard", "secondOnboard", "thirdOnboard"]
    var desc = [
        "Hawy application is one of the leading applications In the world of Auctions",
        "You always want to be on the lookout for the best auctions that contain unique animals Here is the right place",
        "We have a lot of auctions you can use Allegiance auction - Stock Exchange - Live"
    ]
    
    let seconds = TimeZone.current.secondsFromGMT()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage          =  UIImage()
            navigationController?.navigationBar.barTintColor         =  .clear
            navigationController?.navigationBar.tintColor            =  .clear
            navigationController?.navigationBar.titleTextAttributes  =  [.foregroundColor: UIColor.white]
            navigationController?.setNavigationBarHidden(true, animated: false)
        
        getSplashData()
        
        HelperConstant.saveOffst(offset: seconds)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage          =  UIImage()
        navigationController?.navigationBar.barTintColor         =  .clear
        navigationController?.navigationBar.tintColor            =  .clear
        navigationController?.navigationBar.titleTextAttributes  =  [.foregroundColor: UIColor.white]
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func getSplashData() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")"
        ]
        
        showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/entrance", method: .get, parameters: nil, headers: headers).responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(SplashModel.self, from: response.data!)
                
                if productResponse.code == 200 {
                    print("success")
                    
                    self.images2.append(productResponse.item?.firstPage ?? "")
                    self.images2.append(productResponse.item?.secondPage ?? "")
                    self.images2.append(productResponse.item?.thirdPage ?? "")
                    
                    self.splashCollectionView.reloadData()
                    
                }
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    @IBAction func startNowButtonAction(_ sender: Any) {
        let stroyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let VC = stroyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        navigationController?.pushViewController(VC!, animated: false)
    }
}

extension SplashViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return section == 2 ? 15 : 5
        return images2.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = splashCollectionView.dequeueReusableCell(withReuseIdentifier: "SplashCollectionViewCell", for: indexPath) as? SplashCollectionViewCell else { return UICollectionViewCell() }
        
        if indexPath.row == 0 {
            
            cell.firstCircleView.backgroundColor = DesignSystem.Colors.PrimaryBlue.color
            cell.firstNumLable.textColor = DesignSystem.Colors.PrimaryBlue.color
            
            cell.secondCircleView.backgroundColor = DesignSystem.Colors.PrimaryGray.color
            cell.secondNumLable.textColor = DesignSystem.Colors.PrimaryGray.color
            
            cell.thirdCircleView.backgroundColor = DesignSystem.Colors.PrimaryGray.color
            cell.thirdNumLable.textColor = DesignSystem.Colors.PrimaryGray.color
            
        }else if indexPath.row == 1 {
            
            cell.firstCircleView.backgroundColor = DesignSystem.Colors.PrimaryGray.color
            cell.firstNumLable.textColor = DesignSystem.Colors.PrimaryGray.color
            
            cell.secondCircleView.backgroundColor = DesignSystem.Colors.PrimaryBlue.color
            cell.secondNumLable.textColor = DesignSystem.Colors.PrimaryBlue.color
            
            cell.thirdCircleView.backgroundColor = DesignSystem.Colors.PrimaryGray.color
            cell.thirdNumLable.textColor = DesignSystem.Colors.PrimaryGray.color
            
        }else {
            
            cell.firstCircleView.backgroundColor = DesignSystem.Colors.PrimaryGray.color
            cell.firstNumLable.textColor = DesignSystem.Colors.PrimaryGray.color
            
            cell.secondCircleView.backgroundColor = DesignSystem.Colors.PrimaryGray.color
            cell.secondNumLable.textColor = DesignSystem.Colors.PrimaryGray.color
            
            cell.thirdCircleView.backgroundColor = DesignSystem.Colors.PrimaryBlue.color
            cell.thirdNumLable.textColor = DesignSystem.Colors.PrimaryBlue.color
            
        }
        
        cell.splashImage.image = UIImage(named: images[indexPath.row])
        cell.splashTitle.text = images2[indexPath.row]
        
        return cell
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.splashCollectionView.contentOffset, size: self.splashCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.splashCollectionView.indexPathForItem(at: visiblePoint) {
            //self.pageControl.currentPage = visibleIndexPath.row
            if visibleIndexPath.row == 2 {
                startNowButtonOutlet.isHidden = false
            }else {
                startNowButtonOutlet.isHidden = true
            }
        }
    }
    
}

extension SplashViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = splashCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

class ArabicCollectionFlowLayout: UICollectionViewFlowLayout {
    
    override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        
        if AppLocalization.currentAppleLanguage() == "ar" {
            
            return true
            
        }else{
            
            return false
            
        }
    }
    
}
