//
//  AddSaleAuctionCardFromHomeViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 14/09/2022.
//

import UIKit
import Combine
import Alamofire

class AddSaleAuctionCardFromHomeViewController: BaseViewViewController {
    
    @IBOutlet weak var screenTitleLable: UILabel!
    @IBOutlet weak var salesAuctionsProductsCollectionView: UICollectionView!{
        didSet {
            
            salesAuctionsProductsCollectionView.dataSource = self
            salesAuctionsProductsCollectionView.delegate = self
            //subCategoryCollectionView.contentInset.top = 30
            salesAuctionsProductsCollectionView.register(UINib(nibName: "AddSaleAuctionCardFromHomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddSaleAuctionCardFromHomeCollectionViewCell")
            
            
        }
    }
    
    @IBOutlet weak var containerOfPrice: UIView!
    @IBOutlet weak var subContainerOfPrice: UIView!
    
    @IBOutlet weak var auctionPriceView: UIView!
    @IBOutlet weak var auctionPriceTF: UITextField!
    
    @IBOutlet weak var emptyView: UIView!
    
    lazy var label1: PaddedLabel = {
        let label = PaddedLabel()
        label.text = "Primary price"
        label.backgroundColor = DesignSystem.Colors.SecondBackground.color
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    
    var index = -1
    var arrayInt: [Int] = []
    
    var subscriber = Set<AnyCancellable>()
    
    var maxCards: Int?
    var liveCardId: Int?
    var live: Bool?
    
    var type: Int?
    
    var catID: Int?
    
    private var viewModel = ProfileViewModel()
    @Published var  cards = [MyCardsItem]()
    
    var cardData = [AddCardFromHomeToAuctionModel]()
    
    var backData: (([AddCardFromHomeToAuctionModel], _ liveCardId: Int?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if type == 0 {
            screenTitleLable.text = "Add sale auction".localized
        }else if type == 1 {
            screenTitleLable.text = "Add live auction".localized
        }
        
        auctionPriceTF.delegate = self
        
//        if self.live == true {
//            salesAuctionsProductsCollectionView.allowsMultipleSelection = false
//        }else {
//            salesAuctionsProductsCollectionView.allowsMultipleSelection = true
//        }
        
        salesAuctionsProductsCollectionView.allowsMultipleSelection = true
        salesAuctionsProductsCollectionView.collectionViewLayout = createCompositionalLayout()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        containerOfPrice.addGestureRecognizer(tap)
        
        auctionPriceView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
        auctionPriceView.layer.borderWidth = 1
        auctionPriceView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
        auctionPriceView.layer.cornerRadius = 15
        auctionPriceView.layer.masksToBounds = true
        label1.isHidden = true
        
        containerOfPrice.addSubview(label1)
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.topAnchor.constraint(equalTo: auctionPriceView.topAnchor, constant: -10).isActive = true
        label1.leadingAnchor.constraint(equalTo: auctionPriceView.leadingAnchor, constant: 15).isActive = true
        
//        Task {
//            do {
//                let myCards = try await viewModel.profileMyCards(type: "auction", id: HelperConstant.getUserId())
//                print(myCards)
//            }catch {
//                // tell the user something went wrong, I hope
//                debugPrint(error)
//            }
//        }
//
//        sinkToLoading()
//        sinkToReLoading()
//        sinkToProfileMyAuctionsModelPublisher()
        
        getCardsData()
        getProfileData()
    }
    
    @objc
    func dismissKeyboard() {
        self.view.endEditing(true)
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
    
    func getCardsData() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")"
        ]
        
        //showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/auth/profile/cards?type=auction&user_id=\(HelperConstant.getUserId() ?? 0)&category_id=\(catID ?? 0)", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(MyCardsModel.self, from: response.data!)
                
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
                
                self.cards = productResponse.item?.cards ?? []
                self.salesAuctionsProductsCollectionView.reloadData()
                
                if self.cards.isEmpty == true {
                    self.emptyView.isHidden = false
                }else {
                    self.emptyView.isHidden = true
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
                    self.salesAuctionsProductsCollectionView.reloadData()
                }
            }.store(in: &subscriber)
    }
    
    func sinkToProfileMyAuctionsModelPublisher() {
        viewModel.profileMyCardsModelPublisher.sink { [weak self] (result) in
            guard let self = self else { return }
            
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
            
            if result?.code == 200 {
                self.cards = result?.item?.cards ?? []
                
                if self.live == true {
                    self.maxCards = 100 //1
                }else {
                    self.maxCards = 100 //Int(result?.item?.maxSelection ?? "")
                }
                
                
                if self.cards.isEmpty == true {
                    self.emptyView.isHidden = false
                }else {
                    self.emptyView.isHidden = true
                }
                
            }
        }.store(in: &subscriber)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        if auctionPriceTF.text?.isEmpty == false {
            
            
            
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = salesAuctionsProductsCollectionView.cellForItem(at: indexPath) as? AddSaleAuctionCardFromHomeCollectionViewCell {
                
                if cell.isSelected {
                    
                    var item = cards[indexPath.row]
                    
                    
                    //You can change this method according to your need.
                    cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                    cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                    cell.containerView.gradientLayer.colors = [DesignSystem.Colors.PrimaryBlue.color.cgColor, DesignSystem.Colors.PrimaryOrange.color.cgColor]
                    
                    item.price = auctionPriceTF.text ?? "" //Double(auctionPriceTF.text ?? "")
                    cell.priceValue.text = auctionPriceTF.text
                    cell.currencyLabel.text = (HelperConstant.getCurrency() ?? "K.D") //"K.D".localized
                    
                    cardData.append(AddCardFromHomeToAuctionModel(name: item.name, price: auctionPriceTF.text, id: item.id, image: item.mainImage))
                    print("cardData is : \(cardData)")
                    
                    containerOfPrice.isHidden = true
                    subContainerOfPrice.isHidden = true
                    auctionPriceTF.text = ""
                    auctionPriceTF.resignFirstResponder()
                    
                    cell.isSelected = true
                }
                else {
                    //You can change this method according to your need.
                    cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                    cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                    cell.containerView.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
                    
                    containerOfPrice.isHidden = true
                    subContainerOfPrice.isHidden = true
                    auctionPriceTF.text = ""
                    auctionPriceTF.resignFirstResponder()
                    
                    cell.isSelected = false
                }
                
                
            }
            
            
            
        }else {
            
            ToastManager.shared.showError(message: "Please, Enter primary price", view: self.view)
            
        }
        
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        containerOfPrice.isHidden = true
        subContainerOfPrice.isHidden = true
        
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = salesAuctionsProductsCollectionView.cellForItem(at: indexPath) as? AddSaleAuctionCardFromHomeCollectionViewCell {
            
            if cell.isSelected {
                //You can change this method according to your need.
                
                cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                cell.containerView.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
                cell.isSelected = false
            }
            else {
                //You can change this method according to your need.
                
                cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                cell.containerView.gradientLayer.colors = [DesignSystem.Colors.PrimaryBlue.color.cgColor, DesignSystem.Colors.PrimaryOrange.color.cgColor]
                cell.isSelected = true
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
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.35))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        //section.orthogonalScrollingBehavior = .continuous
        
        return section
        
    }
    
    @IBAction func addCardsButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        backData?(cardData, liveCardId)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        //backData?(cardData, liveCardId)
    }
    
}

extension AddSaleAuctionCardFromHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = salesAuctionsProductsCollectionView.dequeueReusableCell(withReuseIdentifier: "AddSaleAuctionCardFromHomeCollectionViewCell", for: indexPath) as? AddSaleAuctionCardFromHomeCollectionViewCell else { return UICollectionViewCell() }
        
        let item = cards[indexPath.row]
        cell.titleLabel.text = item.name
        cell.cardImage.loadImage(URLS.baseImageURL+(item.mainImage ?? ""))
        
        //indexPath.row == index
        if cell.isSelected {

            cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            cell.containerView.gradientLayer.colors = [DesignSystem.Colors.PrimaryBlue.color.cgColor, DesignSystem.Colors.PrimaryOrange.color.cgColor]
            

        }else {

            cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            cell.containerView.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]

        }
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        
        index = indexPath.row
        //containerOfPrice.isHidden = false
        //subContainerOfPrice.isHidden = false
        
        if let cell = salesAuctionsProductsCollectionView.cellForItem(at: indexPath) as? AddSaleAuctionCardFromHomeCollectionViewCell {
            
            
            if cell.isSelected {
                
                var item = cards[indexPath.row]
                
                
                //You can change this method according to your need.
                cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                cell.containerView.gradientLayer.colors = [DesignSystem.Colors.PrimaryBlue.color.cgColor, DesignSystem.Colors.PrimaryOrange.color.cgColor]
                
                item.price = auctionPriceTF.text ?? "" //Double(auctionPriceTF.text ?? "")
                cell.priceValue.text = auctionPriceTF.text
                cell.currencyLabel.text = "" //(HelperConstant.getCurrency() ?? "K.D") //"K.D".localized
                
                cardData.append(AddCardFromHomeToAuctionModel(name: item.name, price: "", id: item.id, image: item.mainImage))
                print("cardData is : \(cardData)")
                
                containerOfPrice.isHidden = true
                subContainerOfPrice.isHidden = true
                auctionPriceTF.text = ""
                auctionPriceTF.resignFirstResponder()
                
                cell.isSelected = true
            }
            else {
                //You can change this method according to your need.
                cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                cell.containerView.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
                
                containerOfPrice.isHidden = true
                subContainerOfPrice.isHidden = true
                auctionPriceTF.text = ""
                auctionPriceTF.resignFirstResponder()
                
                cell.isSelected = false
                
                let item = cards[indexPath.row]
                
                if let index = cardData.firstIndex(of: AddCardFromHomeToAuctionModel(name: item.name, price: "", id: item.id, image: item.mainImage)) {
                    cardData.remove(at: index)
                    print("cardData is : \(cardData)")
                    
                }
                
            }
            
            
//            if cardData.count < maxCards ?? 0 {
//
//                if cell.isSelected {
//
//                    var item = cards[indexPath.row]
//
//
//                    //You can change this method according to your need.
//                    cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//                    cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
//                    cell.containerView.gradientLayer.colors = [DesignSystem.Colors.PrimaryBlue.color.cgColor, DesignSystem.Colors.PrimaryOrange.color.cgColor]
//
//                    item.price = Double(auctionPriceTF.text ?? "")
//                    cell.priceValue.text = auctionPriceTF.text
//                    cell.currencyLabel.text = ""
//
//                    cardData.append(AddCardFromHomeToAuctionModel(name: item.name, price: auctionPriceTF.text, id: item.id, image: item.mainImage))
//                    print("cardData is : \(cardData)")
//
//                    containerOfPrice.isHidden = true
//                    subContainerOfPrice.isHidden = true
//                    auctionPriceTF.text = ""
//                    auctionPriceTF.resignFirstResponder()
//
//                    //cell.isSelected = true
//                    print(salesAuctionsProductsCollectionView.indexPathsForSelectedItems)
//                }
//                else {
//                    //You can change this method according to your need.
//                    cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//                    cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
//                    cell.containerView.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
//
//                    containerOfPrice.isHidden = true
//                    subContainerOfPrice.isHidden = true
//                    auctionPriceTF.text = ""
//                    auctionPriceTF.resignFirstResponder()
//
//                    let item = cardData[indexPath.row]
//
//                    if let index = cardData.firstIndex(of: AddCardFromHomeToAuctionModel(name: item.name, price: item.price, id: item.id, image: item.image)) {
//                        cardData.remove(at: index)
//                        print("cardData is : \(cardData)")
//
//                    }
//
//                    //cell.isSelected = false
//                }
                
//                cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//                cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
//                cell.containerView.gradientLayer.colors = [DesignSystem.Colors.PrimaryBlue.color.cgColor, DesignSystem.Colors.PrimaryOrange.color.cgColor]
//
//                let item = cards[indexPath.row]
//
//                cardData.append(AddCardFromHomeToAuctionModel(name: item.name, price: "", id: item.id, image: item.mainImage))
//                print("cardData is : \(cardData)")
//                liveCardId = item.id
                
//                if cell.isSelected {
//
//                    cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//                    cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
//                    cell.containerView.gradientLayer.colors = [DesignSystem.Colors.PrimaryBlue.color.cgColor, DesignSystem.Colors.PrimaryOrange.color.cgColor]
//
//                    var item = cards[indexPath.row]
//
//                    cardData.append(AddCardFromHomeToAuctionModel(name: item.name, price: auctionPriceTF.text, id: item.id, image: item.mainImage))
//                    print("cardData is : \(cardData)")
//                    liveCardId = item.id
//
//                    cell.isSelected = true
//
//                }else {
//
//                    cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//                    cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
//                    cell.containerView.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
//
//                    let item = cardData[indexPath.row]
//
//                    if let index = cardData.firstIndex(of: AddCardFromHomeToAuctionModel(name: item.name, price: item.price, id: item.id, image: item.image)) {
//                        cardData.remove(at: index)
//                        print("cardData is : \(cardData)")
//
//                        cell.isSelected = false
//
//                    }
//
//                }
                //salesAuctionsProductsCollectionView.reloadData()
//                if cell.isSelected {
//
//                    var item = cards[indexPath.row]
//
//                    print(maxCards)
//                    //You can change this method according to your need.
//
//                    cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//                    cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
//                    cell.containerView.gradientLayer.colors = [DesignSystem.Colors.PrimaryBlue.color.cgColor, DesignSystem.Colors.PrimaryOrange.color.cgColor]
//
//                    //item.price = Double(auctionPriceTF.text ?? "")
//                    //cell.priceValue.text = auctionPriceTF.text
//                    //cell.currencyLabel.text = "K.D"
//
//                    cardData.append(AddCardFromHomeToAuctionModel(name: item.name, price: auctionPriceTF.text, id: item.id, image: item.mainImage))
//                    print("cardData is : \(cardData)")
//                    liveCardId = item.id
//
//                    //containerOfPrice.isHidden = true
//                    //subContainerOfPrice.isHidden = true
//                    //auctionPriceTF.text = ""
//                    //auctionPriceTF.resignFirstResponder()
//
//                    cell.isSelected = false
//                }
//                else {
//
//                    let item = cardData[indexPath.row]
//
//                    //You can change this method according to your need.
//                    cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//                    cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
//                    cell.containerView.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
//
//                    cell.priceValue.text = ""
//                    cell.currencyLabel.text = ""
//
////                    containerOfPrice.isHidden = true
////                    subContainerOfPrice.isHidden = true
////                    auctionPriceTF.text = ""
////                    auctionPriceTF.resignFirstResponder()
//
//                    if let index = cardData.firstIndex(of: AddCardFromHomeToAuctionModel(name: item.name, price: item.price, id: item.id, image: item.image)) {
//                        cardData.remove(at: index)
//                        print("cardData is : \(cardData)")
//
//                    }
//
//                    cell.isSelected = true
//                }
                
//            }else {
//                //cell.isSelected = true
//                ToastManager.shared.showError(message: "Can't add more than".localized + "\(maxCards ?? 0)".localized + "card", view: self.view)
////                cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
////                cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
////                cell.containerView.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
////
////                cell.priceValue.text = ""
////                cell.currencyLabel.text = ""
////
////                containerOfPrice.isHidden = true
////                subContainerOfPrice.isHidden = true
////                auctionPriceTF.text = ""
////                auctionPriceTF.resignFirstResponder()
//            }
            
            //salesAuctionsProductsCollectionView.reloadData()
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        guard let cell = salesAuctionsProductsCollectionView.cellForItem(at:indexPath) as? AddSaleAuctionCardFromHomeCollectionViewCell else { return }
        
        cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        cell.containerView.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
        
        let item = cards[indexPath.row]
        
        if let index = cardData.firstIndex(of: AddCardFromHomeToAuctionModel(name: item.name, price: "", id: item.id, image: item.mainImage)) {
            cardData.remove(at: index)
            print("cardData is : \(cardData)")
            
        }
        
//        if cardData.count < maxCards ?? 0 {
//            if cell.isSelected {
//                //You can change this method according to your need.
//
//                cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//                cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
//                cell.containerView.gradientLayer.colors = [DesignSystem.Colors.PrimaryBlue.color.cgColor, DesignSystem.Colors.PrimaryOrange.color.cgColor]
//                //cell.isSelected = true
//
//            }
//            else {
//                //You can change this method according to your need.
//
//                cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//                cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
//                cell.containerView.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
//
//                let item = cardData[indexPath.row]
//
//                if let index = cardData.firstIndex(of: AddCardFromHomeToAuctionModel(name: item.name, price: item.price, id: item.id, image: item.image)) {
//                    cardData.remove(at: index)
//                    print("cardData is : \(cardData)")
//
//                }
//
//                //cell.isSelected = false
//
//
//            }
//        }else {
//
//        }
        
        
        
//        if cell.isSelected == false {
//
//            let item = cardData[indexPath.row]
//
//            //You can change this method according to your need.
//            cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//            cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
//            cell.containerView.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
//
//            if let index = cardData.firstIndex(of: AddCardFromHomeToAuctionModel(name: item.name, price: item.price, id: item.id, image: item.image)) {
//                cardData.remove(at: index)
//                print("cardData is : \(cardData)")
//
//            }
//
//            //cell.isSelected = false
//
//        }
        
//        if cardData.count < maxCards ?? 0 {
//
//
//
//        }else {
//
//        }
        
        
        
//        let item = cardData[indexPath.row]
//
//        //You can change this method according to your need.
//        cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
//        cell.containerView.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
//
//        if let index = cardData.firstIndex(of: AddCardFromHomeToAuctionModel(name: item.name, price: item.price, id: item.id, image: item.image)) {
//            cardData.remove(at: index)
//            print("cardData is : \(cardData)")
//
//        }
        
//        if maxCards ?? 0 > cardData.count {
//
//        }
//        else {
//            ToastManager.shared.showError(message: "Can't add more than \(maxCards ?? 0) card", view: self.view)
//        }
        
//        if cardData.count <= 1 {
//            cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//            cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
//            cell.containerView.gradientLayer.colors = [DesignSystem.Colors.PrimaryBlue.color.cgColor, DesignSystem.Colors.PrimaryOrange.color.cgColor]
//        }else {
//            let item = cardData[indexPath.row]
//
//
//            cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//            cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
//            cell.containerView.gradientLayer.colors = [DesignSystem.Colors.PrimaryBlue.color.cgColor, DesignSystem.Colors.PrimaryOrange.color.cgColor]
//
//            cell.priceValue.text = ""
//            cell.currencyLabel.text = ""
//
//            if let index = cardData.firstIndex(of: AddCardFromHomeToAuctionModel(name: item.name, price: "", id: item.id, image: item.image)) {
//                cardData.remove(at: index)
//                print("cardData is : \(cardData)")
//
//            }
//
//            print(salesAuctionsProductsCollectionView.indexPathsForSelectedItems)
//        }

//        if maxCards ?? 0 > cardData.count && cell.isSelected {
//
//            //if cell.isSelected {
//
//                var item = cards[indexPath.row]
//
//                print(maxCards)
//                //You can change this method according to your need.
//
//                cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//                cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
//                cell.containerView.gradientLayer.colors = [DesignSystem.Colors.PrimaryBlue.color.cgColor, DesignSystem.Colors.PrimaryOrange.color.cgColor]
//
//                //item.price = Double(auctionPriceTF.text ?? "")
//                //cell.priceValue.text = auctionPriceTF.text
//                //cell.currencyLabel.text = "K.D"
//
//                cardData.append(AddCardFromHomeToAuctionModel(name: item.name, price: auctionPriceTF.text, id: item.id, image: item.mainImage))
//                print("cardData is : \(cardData)")
//                liveCardId = item.id
//
//                //containerOfPrice.isHidden = true
//                //subContainerOfPrice.isHidden = true
//                //auctionPriceTF.text = ""
//                //auctionPriceTF.resignFirstResponder()
//
//                //cell.isSelected = true
//            //}
////                else {
////
////                    //let item = cardData[indexPath.row]
////
////                    //You can change this method according to your need.
////                    cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
////                    cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
////                    cell.containerView.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
////
////                    cell.priceValue.text = ""
////                    cell.currencyLabel.text = ""
////
////                    containerOfPrice.isHidden = true
////                    subContainerOfPrice.isHidden = true
////                    auctionPriceTF.text = ""
////                    auctionPriceTF.resignFirstResponder()
////
//////                    if let index = cardData.firstIndex(of: AddCardFromHomeToAuctionModel(name: item.name, price: item.price, id: item.id, image: item.image)) {
//////                        cardData.remove(at: index)
//////                        print("cardData is : \(cardData)")
//////
//////                    }
////
////                    cell.isSelected = false
////                }
//
//        }else {
//            //cell.isSelected = true
//            ToastManager.shared.showError(message: "Can't add more than \(maxCards ?? 0) card", view: self.view)
//            cell.containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//            cell.containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
//            cell.containerView.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
//
//            cell.priceValue.text = ""
//            cell.currencyLabel.text = ""
//
//            containerOfPrice.isHidden = true
//            subContainerOfPrice.isHidden = true
//            auctionPriceTF.text = ""
//            auctionPriceTF.resignFirstResponder()
//            let item = cardData[indexPath.row]
//            if let index = cardData.firstIndex(of: AddCardFromHomeToAuctionModel(name: item.name, price: "", id: item.id, image: item.image)) {
//                cardData.remove(at: index)
//                print("cardData is : \(cardData)")
//
//            }
//
//        }
        
        
        
    }
    
}

extension AddSaleAuctionCardFromHomeViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.auctionPriceTF {
            auctionPriceView.backgroundColor = DesignSystem.Colors.SecondBackground.color
            auctionPriceView.layer.borderWidth = 1
            auctionPriceView.layer.borderColor = DesignSystem.Colors.PrimaryOrange.color.cgColor
            auctionPriceView.layer.cornerRadius = 15
            auctionPriceView.layer.masksToBounds = true
            label1.isHidden = false
            
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == self.auctionPriceTF {
            auctionPriceView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
            auctionPriceView.layer.borderWidth = 1
            auctionPriceView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
            auctionPriceView.layer.cornerRadius = 15
            auctionPriceView.layer.masksToBounds = true
            label1.isHidden = true
            
        }
        
    }
    
}
