//
//  StockAuctionViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 07/10/2022.
//

import UIKit
import Alamofire

class StockAuctionViewController: BaseViewViewController {
    
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var currentView: UIView!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var currentButtonOutlet: UIButton!
    @IBOutlet weak var commingView: UIView!
    @IBOutlet weak var commingLabel: UILabel!
    @IBOutlet weak var commingButtonOutlet: UIButton!
    
    @IBOutlet weak var salesAuctionsProductsCollectionView: UICollectionView!{
        didSet {
            
            salesAuctionsProductsCollectionView.dataSource = self
            salesAuctionsProductsCollectionView.delegate = self
            //subCategoryCollectionView.contentInset.top = 30
            
            salesAuctionsProductsCollectionView.register(UINib(nibName: "CurrentCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: "header", withReuseIdentifier: "HeaderView")
            salesAuctionsProductsCollectionView.register(UINib(nibName: "SalesAuctionsProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SalesAuctionsProductsCollectionViewCell")
            
        }
    }
    
    
    @IBOutlet weak var auctionViewTableView: UITableView!
    @IBOutlet weak var stockNowView: UIView!
    @IBOutlet weak var stockCommingView: UIView!
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyView2: UIView!
    
    var cellRowToTimerMapping: [Int: Timer] = [:]
    var cellRowToPauseFlagMapping: [Int: Bool] = [:]
    
    var auctionData = [StockAuctionItem]()
    var auctionData2 = [StockAuctionItem]()
    
    var cards = [MyAuctionCard]()
    
    var auctionId: Int?
    
    let firstColor = DesignSystem.Colors.PrimaryBlue.color
    let secondColor = DesignSystem.Colors.PrimaryOrange.color
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topContainer.roundCornersWithMask([.topLeading, .topTrailing], radius: 20)
//        stockCommingView.roundCornersWithMask([.topLeading, .topTrailing], radius: 20)
//        stockNowView.roundCornersWithMask([.topLeading, .topTrailing], radius: 20)
//        emptyView.roundCornersWithMask([.topLeading, .topTrailing], radius: 20)
//        emptyView2.roundCornersWithMask([.topLeading, .topTrailing], radius: 20)
        
        commingView.setGradient(firstColor: firstColor, secondColor: secondColor)
        DispatchQueue.main.async {
            self.currentView.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
            self.commingLabel.textColor = .white
            self.currentLabel.textColor = .black
        }
        
        auctionViewTableView.register(UINib(nibName: "CommingStockTableViewCell", bundle: nil), forCellReuseIdentifier: "CommingStockTableViewCell")
        
        
        
        let sectionsTableViewFrame = CGRect(x: 0, y: 0, width: auctionViewTableView.frame.size.width, height: 1)
        auctionViewTableView.tableFooterView = UIView(frame: sectionsTableViewFrame)
        auctionViewTableView.tableHeaderView = UIView(frame: sectionsTableViewFrame)
        
        auctionViewTableView.delegate = self
        auctionViewTableView.dataSource = self
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getStockAuctions(type: "coming")
        getNowStockAuctions(type: "now")
        
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        
//        if let view = salesAuctionsProductsCollectionView.supplementaryView(forElementKind: "header", at: IndexPath(item: 0, section: 0)) as? CurrentCollectionReusableView {
//            
//            view.timer2?.invalidate()
//            
//        }
//        
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        salesAuctionsProductsCollectionView.collectionViewLayout = createCompositionalLayout()
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
        
        // supplementary
        let hearderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .absolute(100))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: hearderSize, elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
        
    }
    
    @IBAction func currentButtonAction(_ sender: Any) {
        
        currentView.setGradient(firstColor: firstColor, secondColor: secondColor)
        DispatchQueue.main.async {
            self.commingView.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
            self.currentLabel.textColor = .white
            self.commingLabel.textColor = .black
        }
        
        stockNowView.isHidden = false
        stockCommingView.isHidden = true
        
        getNowStockAuctions(type: "now")
        
    }
    
    @IBAction func commingButtonAction(_ sender: Any) {
        
        commingView.setGradient(firstColor: firstColor, secondColor: secondColor)
        DispatchQueue.main.async {
            self.currentView.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
            self.currentLabel.textColor = .black
            self.commingLabel.textColor = .white
        }
        
        stockNowView.isHidden = true
        stockCommingView.isHidden = false
        
        getStockAuctions(type: "coming")
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func makeCollepse(button: UIButton) {
        print("tapped")
    }
    
    func getStockAuctions(type: String?) {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator() //
        AF.request("https://hawy-kw.com/api/auctions/market?auction_date=\(type ?? "")&time_from=\(Int(Date.currentTimeStamp))", method: .get, parameters: nil, headers: headers).responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(StockAuctionModel.self, from: response.data!)
                
                if productResponse.code == 200 {
                    print("success")
                    self.auctionData2 = productResponse.item ?? []
                    
                    if self.auctionData2.isEmpty == true {
                        self.emptyView.isHidden = false
                    }else {
                        self.emptyView.isHidden = true
                    }
                    
                    self.auctionViewTableView.reloadData()
                    
                }
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    func getNowStockAuctions(type: String?) {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator() //
        AF.request("https://hawy-kw.com/api/auctions/market?auction_date=\(type ?? "")&time_from=\(Int(Date.currentTimeStamp))", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(StockAuctionModel.self, from: response.data!)
                
                if productResponse.code == 200 {
                    print("success")
                    
                    
                    self.auctionData = productResponse.item ?? []
                    
                    if self.auctionData.isEmpty == true {
                        self.emptyView2.isHidden = false
                    }else {
                        self.emptyView2.isHidden = true
                    }
                    
                    self.salesAuctionsProductsCollectionView.reloadData()
                    
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
    
}

extension StockAuctionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
    
    func handleExpandClose2(button: Int) {
        print("Trying to expand and close section...")

        let section = button

        // we'll try to close the section first by deleting the rows
        var indexPaths = [IndexPath]()
        for row in auctionData[section].cards!.indices {
            print(0, row)
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        //let indexPath = IndexPath(row: 0, section: section)
        //indexPaths.append(indexPath)

        let isExpanded = auctionData[section].isExpanded
        auctionData[section].isExpanded = !isExpanded

        //button.setTitle(isExpanded ? "Open" : "Close", for: .normal)

        if isExpanded {
            salesAuctionsProductsCollectionView.deleteItems(at: indexPaths)
        } else {
            salesAuctionsProductsCollectionView.insertItems(at: indexPaths)
        }
    }
    

    private func makeNetworkCall(completion: @escaping () -> Void) {
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let view = salesAuctionsProductsCollectionView.dequeueReusableSupplementaryView(ofKind: "header", withReuseIdentifier: "HeaderView", for: indexPath) as? CurrentCollectionReusableView else { return UICollectionReusableView() }
        
        let item = auctionData[indexPath.section]
        
//        view.button.addTarget(self, action: #selector(handleExpandClose2), for: .touchUpInside)
//
//        view.button.tag = indexPath.section
        
//        if item.cards?.isEmpty == true {
//            view.button.isEnabled = false
//        }else {
//            view.button.isEnabled = true
//        }
        
         //viewModel.profileMyAuctionsModel?.item?[section]
        
        view.TitleLabel.text = "Hawy launched new stock auction".localized //item.name
        view.firstTimerLabel.text = "\(item.day ?? "")"
        view.startOtpTimer(data: item)
        
        view.button.tag = indexPath.section
        
        view.Click = { tag in
            self.handleExpandClose2(button: tag)
        }
        
        return view
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return auctionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if !auctionData[section].isExpanded {
            return 0
        }
        
        return auctionData[section].cards?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = salesAuctionsProductsCollectionView.dequeueReusableCell(withReuseIdentifier: "SalesAuctionsProductsCollectionViewCell", for: indexPath) as? SalesAuctionsProductsCollectionViewCell else { return UICollectionViewCell() }
        let item = auctionData[indexPath.section].cards?[indexPath.row]
        //let item = cards[indexPath.row]
        
        cell.ownerStackView.isHidden = false
        cell.ownerNameLabel.text = item?.owner?.name ?? ""
        cell.cardImage.loadImage(URLS.baseImageURL+(item?.mainImage ?? ""))
        cell.cardNameLabel.text = item?.name ?? ""
        cell.cardPriceLabel.text = "\(item?.price ?? "0.0")"
        cell.bidMaxPriceLabel.text = "\(item?.bidMaxPrice ?? "0.0") " + "K.D".localized
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = auctionData[indexPath.section].cards?[indexPath.row]
        let item2 = auctionData[indexPath.section]
        
        let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "AuctionProductDetailsViewController") as? AuctionProductDetailsViewController
        VC?.auctionId = item2.id
        VC?.cardId = item?.id
        
        //VC?.tit = 2
        
        VC?.price = "\(item?.price ?? "0.0")"
        VC?.images = item?.images ?? []
        VC?.desc = item?.notes
        VC?.time = item?.endDate ?? 0
        VC?.isStockAuction = true
        //VC?.ownerName = item
        //VC?.ownerImage = item
        
        navigationController?.pushViewController(VC!, animated: false)
        
    }
    
}

extension StockAuctionViewController: UITableViewDelegate, UITableViewDataSource {
    
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return auctionData2.count //viewModel.profileMyAuctionsModel?.item?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !auctionData2[section].isExpanded {
            return 0
        }
        
        return 1 //auctionData.count //auctionData[section].cards?.count ?? 0 //viewModel.profileMyAuctionsModel?.item?[section].cards?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = auctionViewTableView.dequeueReusableCell(withIdentifier: "CommingStockTableViewCell", for: indexPath) as? CommingStockTableViewCell else { return UITableViewCell() }
        
        let item = auctionData2[indexPath.row] //viewModel.profileMyAuctionsModel?.item?[indexPath.section].cards?[indexPath.row]

        cell.totalParticipantValueLabel.text = item.numberOfUsers
        cell.remainingParticipantValueLabel.text = "\(item.usersRemainNumber ?? 0)"
        cell.subscriptionFeeValueLabel.text = "\(item.subscribePrice ?? "0.0")" + "K.D".localized
        cell.commingStockLabel.text = item.itemDescription ?? ""
        cell.SubscribeAction = { [weak self] in
            
            guard let self = self else { return }
            
            let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
            let VC = storyborad.instantiateViewController(withIdentifier: "AddStockAuctionViewController") as? AddStockAuctionViewController
            VC?.auctionId = item.id
            VC?.stockPrice = item.subscribePrice
            VC?.catID = item.category_id
            self.navigationController?.pushViewController(VC!, animated: false)
            
        }
        
        return cell
    }
    
    @objc func handleExpandClose(button: UIButton) {
        print("Trying to expand and close section...")
        
        let section = button.tag
        
        // we'll try to close the section first by deleting the rows
        var indexPaths = [IndexPath]()
//        for row in auctionData[section].cards!.indices {
//            print(0, row)
//            let indexPath = IndexPath(row: row, section: section)
//            indexPaths.append(indexPath)
//        }
        let indexPath = IndexPath(row: 0, section: section)
        indexPaths.append(indexPath)
        
        let isExpanded = auctionData2[section].isExpanded
        auctionData2[section].isExpanded = !isExpanded
        
        //button.setTitle(isExpanded ? "Open" : "Close", for: .normal)
        
        if isExpanded {
            auctionViewTableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            auctionViewTableView.insertRows(at: indexPaths, with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let item1 = auctionData[indexPath.section]
//        let item2 = auctionData[indexPath.section].cards?[indexPath.row]
//
//        let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
//        let VC = storyborad.instantiateViewController(withIdentifier: "AuctionProductDetailsViewController") as? AuctionProductDetailsViewController
//        VC?.auctionId = item1.id
//        VC?.cardId = item2?.id
//        navigationController?.pushViewController(VC!, animated: false)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // first create the custom view
        let myCustomView = UIView()
        
        let stockImage: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "stock")
            imageView.contentMode = .scaleAspectFit
            imageView.layer.masksToBounds = false
            imageView.layer.cornerRadius = 40
            return imageView
        }()
        
        let arrowUpDowmImage: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "Iconly Light Arrow - Down -1")
            imageView.contentMode = .scaleAspectFit
            imageView.layer.masksToBounds = false
            imageView.layer.cornerRadius = 12.5
            return imageView
        }()
        let firstTimerImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "07448c5d1447c49b9630f1fe372af70f")
            imageView.contentMode = .scaleAspectFit
            imageView.layer.masksToBounds = false
            imageView.layer.cornerRadius = 12.5
            return imageView
        }()
        let secondTimerImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "07448c5d1447c49b9630f1fe372af70f")
            imageView.contentMode = .scaleAspectFit
            imageView.layer.masksToBounds = false
            imageView.layer.cornerRadius = 12.5
            return imageView
        }()
        let saleAuctionImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "Search results for Auction - Flaticon-2 (1)")
            imageView.tintColor = .white
            imageView.contentMode = .scaleAspectFit
            imageView.layer.masksToBounds = false
            imageView.layer.cornerRadius = 12.5
            return imageView
        }()
        let TitleLabel: UILabel = {
            let lable = UILabel()
            lable.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            lable.text = "Hamam"
            lable.textColor = .white
            return lable
        }()
        let firstTimerLabel: UILabel = {
            let lable = UILabel()
            lable.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            lable.text = "7-8-2020"
            lable.textColor = .white
            return lable
        }()
        let secondTimerLabel: UILabel = {
            let lable = UILabel()
            lable.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            lable.text = "7-8-2020"
            lable.textColor = .white
            return lable
        }()
        let saleAuctionLabel: UILabel = {
            let lable = UILabel()
            lable.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            lable.text = "Sale auction"
            lable.textColor = .white
            return lable
        }()
        
        let collapseButton:  UIButton = {
            
            let button = UIButton()
            
            button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
            
            button.tag = section
            
            return button
        }()
        
        // create a view cell and attach the custom view to it
        let headerView = UITableViewHeaderFooterView()
        let contentView = headerView.contentView
        let gradientView = GradientView()
        
        contentView.addSubview(myCustomView)
        myCustomView.addSubview(gradientView)
        
        gradientView.addSubview(stockImage)
        gradientView.addSubview(TitleLabel)
        gradientView.addSubview(firstTimerLabel)
        //gradientView.addSubview(secondTimerLabel)
        gradientView.addSubview(saleAuctionLabel)
        
        gradientView.addSubview(arrowUpDowmImage)
        gradientView.addSubview(firstTimerImageView)
        //gradientView.addSubview(secondTimerImageView)
        gradientView.addSubview(saleAuctionImageView)
        gradientView.addSubview(collapseButton)
        
        myCustomView.backgroundColor = UIColor.clear
        headerView.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        gradientView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradientView.gradientLayer.colors = [DesignSystem.Colors.PrimaryLightGreen.color.cgColor, DesignSystem.Colors.PrimaryGreen.color.cgColor]
        gradientView.layer.cornerRadius = 20
        
        // add extra code to pin all the anchors
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        myCustomView.translatesAutoresizingMaskIntoConstraints = false
        stockImage.translatesAutoresizingMaskIntoConstraints = false
        TitleLabel.translatesAutoresizingMaskIntoConstraints = false
        firstTimerLabel.translatesAutoresizingMaskIntoConstraints = false
        secondTimerLabel.translatesAutoresizingMaskIntoConstraints = false
        saleAuctionLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowUpDowmImage.translatesAutoresizingMaskIntoConstraints = false
        firstTimerImageView.translatesAutoresizingMaskIntoConstraints = false
        secondTimerImageView.translatesAutoresizingMaskIntoConstraints = false
        saleAuctionImageView.translatesAutoresizingMaskIntoConstraints = false
        collapseButton.translatesAutoresizingMaskIntoConstraints = false
        
        myCustomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        myCustomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        myCustomView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        myCustomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        gradientView.leadingAnchor.constraint(equalTo: myCustomView.leadingAnchor).isActive = true
        gradientView.trailingAnchor.constraint(equalTo: myCustomView.trailingAnchor).isActive = true
        gradientView.topAnchor.constraint(equalTo: myCustomView.topAnchor).isActive = true
        gradientView.bottomAnchor.constraint(equalTo: myCustomView.bottomAnchor).isActive = true
        
        collapseButton.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor).isActive = true
        collapseButton.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor).isActive = true
        collapseButton.topAnchor.constraint(equalTo: gradientView.topAnchor).isActive = true
        collapseButton.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            
            stockImage.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 5),
            stockImage.centerYAnchor.constraint(equalTo: gradientView.centerYAnchor),
            stockImage.widthAnchor.constraint(equalToConstant: 80),
            stockImage.heightAnchor.constraint(equalToConstant: 80),
            
            TitleLabel.leadingAnchor.constraint(equalTo: stockImage.trailingAnchor, constant: 5),
            TitleLabel.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 15),
            
            arrowUpDowmImage.trailingAnchor.constraint(equalTo: gradientView.trailingAnchor, constant: -30),
            arrowUpDowmImage.centerYAnchor.constraint(equalTo: TitleLabel.centerYAnchor),
            arrowUpDowmImage.widthAnchor.constraint(equalToConstant: 20),
            arrowUpDowmImage.heightAnchor.constraint(equalToConstant: 20),
            
            firstTimerImageView.leadingAnchor.constraint(equalTo: stockImage.trailingAnchor, constant: 5),
            firstTimerImageView.topAnchor.constraint(equalTo: TitleLabel.bottomAnchor, constant: 15),
            firstTimerImageView.widthAnchor.constraint(equalToConstant: 20),
            firstTimerImageView.heightAnchor.constraint(equalToConstant: 20),
            
            firstTimerLabel.leadingAnchor.constraint(equalTo: firstTimerImageView.trailingAnchor, constant: 7),
            firstTimerLabel.centerYAnchor.constraint(equalTo: firstTimerImageView.centerYAnchor),
            
//            secondTimerImageView.leadingAnchor.constraint(equalTo: firstTimerLabel.trailingAnchor, constant: 7),
//            secondTimerImageView.topAnchor.constraint(equalTo: firstTimerImageView.topAnchor),
//            secondTimerImageView.widthAnchor.constraint(equalToConstant: 20),
//            secondTimerImageView.heightAnchor.constraint(equalToConstant: 20),
//
//            secondTimerLabel.leadingAnchor.constraint(equalTo: secondTimerImageView.trailingAnchor, constant: 7),
//            secondTimerLabel.centerYAnchor.constraint(equalTo: secondTimerImageView.centerYAnchor),
            
            saleAuctionImageView.leadingAnchor.constraint(equalTo: firstTimerLabel.trailingAnchor, constant: 7),
            saleAuctionImageView.topAnchor.constraint(equalTo: firstTimerImageView.topAnchor),
            saleAuctionImageView.widthAnchor.constraint(equalToConstant: 20),
            saleAuctionImageView.heightAnchor.constraint(equalToConstant: 20),
            
            saleAuctionLabel.leadingAnchor.constraint(equalTo: saleAuctionImageView.trailingAnchor, constant: 7),
            saleAuctionLabel.centerYAnchor.constraint(equalTo: saleAuctionImageView.centerYAnchor),
            
        ])
        
        collapseButton.addTarget(self, action: #selector(makeCollepse), for: .touchUpInside)
        
        let item = auctionData2[section] //viewModel.profileMyAuctionsModel?.item?[section]
        
        TitleLabel.text = "Hawy launched new stock auction".localized //item.name
        firstTimerLabel.text = "\(item.day ?? "")"
        secondTimerLabel.text = "\(item.endDate ?? 0)"
        saleAuctionLabel.text = item.type
        
//      collapseButton)  if ownerName == "Inhouse" {
//            label.text = ""
//        }else {
//            label.text = ownerName
//        }
//
//        imageView.loadImage(URL(string: "\(URLS.baseImageURL)\(carts[section].owner_image ?? "")"))
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        showPinnedHeaders()
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        showPinnedHeaders()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        removePinnedHeaders()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        removePinnedHeaders()
    }

    private func showPinnedHeaders() {
        for section in 0..<auctionData.count { //(viewModel.profileMyAuctionsModel?.item?.count ?? 0)
            auctionViewTableView.headerView(forSection: section)?.isHidden = false
        }
    }

    private func removePinnedHeaders() {
        if let indexPathsForVisibleRows = auctionViewTableView.indexPathsForVisibleRows {
            if indexPathsForVisibleRows.count > 0 {
                for indexPathForVisibleRow in indexPathsForVisibleRows {
                    if let header = auctionViewTableView.headerView(forSection: indexPathForVisibleRow.section) {
                        if let cell = auctionViewTableView.cellForRow(at: indexPathForVisibleRow) {
                            if header.frame.intersects(cell.frame) {
                                let seconds = 0.5
                                let delay = seconds * Double(NSEC_PER_SEC)
                                let dispatchTime = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                                DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                                    if !self.auctionViewTableView.isDragging && header.frame.intersects(cell.frame) {
                                        header.isHidden = true
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
}
