//
//  TypeAddedDetailsCardViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 31/08/2022.
//

import UIKit
import Combine
import Alamofire

class TypeAddedDetailsCardViewController: BottomPopupViewController {
    
    var selected_Index : Int?
    var height: CGFloat?
    //var Delegate : AddNewAddress!
    //var delegateAction: delegate?
    //var delegYourAdderss: delegateAddress?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    @IBOutlet weak var typesTableView: UITableView!
    
    var twoDimensionalArray = [TypeOfCardsItem]()
    
    @Published var showIndexPaths = false
    
    private var viewModel = TypeAddedDetailsCardViewModel()
    var subscriber = Set<AnyCancellable>()
    
    var returnBack: ((String, String) -> Void)?
    var selected, value: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show IndexPath", style: .plain, target: self, action: #selector(handleShowIndexPath))
        
        //navigationItem.title = "Contacts"
        //navigationController?.navigationBar.prefersLargeTitles = true
        
        typesTableView.allowsMultipleSelection = false
        
        typesTableView.register(UINib(nibName: "TypeAddedDetailsCardTableViewCell", bundle: nil), forCellReuseIdentifier: "TypeAddedDetailsCardTableViewCell")
        typesTableView.register(UINib(nibName: "SectionsTypeAddedTableViewCell", bundle: nil), forCellReuseIdentifier: "SectionsTypeAddedTableViewCell")
        
        let typesTableViewFrame = CGRect(x: 0, y: 0, width: typesTableView.frame.size.width, height: 1)
        typesTableView.tableFooterView = UIView(frame: typesTableViewFrame)
        typesTableView.tableHeaderView = UIView(frame: typesTableViewFrame)
        
        typesTableView.delegate = self
        typesTableView.dataSource = self
        
        Task {
            do {
                let getCatAndSub = try await viewModel.getcategoryAndSub()
                print(getCatAndSub)
            }catch {
                // tell the user something went wrong, I hope
                debugPrint(error)
            }
        }
        sinkToLoading()
        sinkToReloading()
        sinkToGetCatAndSub()
        sinkToTypeOfCardsItem()
        getProfileData()
    }
    
    override func getPopupHeight() -> CGFloat {
        return height ?? CGFloat(450)
    }
    
    override func getPopupTopCornerRadius() -> CGFloat {
        return 35
    }
    
    override func getPopupPresentDuration() -> Double {
        return presentDuration ?? 1.0
    }
    
    override func getPopupDismissDuration() -> Double {
        return dismissDuration ?? 1.0
    }
    
    override func shouldPopupDismissInteractivelty() -> Bool {
        return shouldDismissInteractivelty ?? false
    }
    
    func sinkToLoading() {
//        self.viewModel.loadinState
//            .sink { [weak self] state in
//                self?.handleActivityIndicator(state: state)
//            }.store(in: &subscriber)
        self.viewModel.loadState
            .sink { [weak self] state in
                if state {
                    print("show Loading")
                }else {
                    print("dismiss Loading")
                }
            }.store(in: &subscriber)
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
    
    func sinkToReloading() {

        self.viewModel.reloadingState
            .sink { [weak self] (state) in
                if state {
                    self?.typesTableView.reloadData()
                }
            }.store(in: &subscriber)
    }
    
    func sinkToGetCatAndSub() {
        viewModel.typeAddedModelPublisher.sink { [weak self] (result) in
            guard let self = self else { return }
            
            if result?.message == "Unauthenticated." {
                
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
            
            if result?.code == 200 {
               print(result)
                
            }
        }.store(in: &subscriber)
    }
    
    func sinkToTypeOfCardsItem() {
        viewModel.typeOfCardsItemPublisher.sink { [weak self] (result) in
            guard let self = self else { return }
            print(result)
            //self.twoDimensionalArray = result ?? []
            self.twoDimensionalArray.append(contentsOf: result ?? [])
            
        }.store(in: &subscriber)
    }
    
    @IBAction func selectButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: {
            self.returnBack!(self.selected ?? "", self.value ?? "")
        })
        
    }
    
    
}

extension TypeAddedDetailsCardViewController: BottomPopupDelegate {
    func bottomPopupViewLoaded() {
        print("bottomPopupViewLoaded")
        shouldDismissInteractivelty = false
    }
    
    func bottomPopupWillAppear() {
        print("bottomPopupWillAppear")
    }
    
    func bottomPopupDidAppear() {
        print("bottomPopupDidAppear")
    }
    
    func bottomPopupWillDismiss() {
        print("bottomPopupWillDismiss")
    }
    
    func bottomPopupDidDismiss() {
        print("bottomPopupDidDismiss")
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
}

extension TypeAddedDetailsCardViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        return twoDimensionalArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !(twoDimensionalArray[section].isExpanded ?? false) {
            return 1 //0
        }else {
            return ((viewModel.typeOfCardsItem?[section].sub?.count ?? 100) + 1)
        }
        
         //twoDimensionalArray[section].sub?.count ?? 0
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let button = UIButton(type: .system)
//        button.setTitle("Close", for: .normal)
//        button.setTitleColor(.black, for: .normal)
//        button.backgroundColor = .yellow
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
//
//        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
//
//        button.tag = section
//
//        return button
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            guard let cell = typesTableView.dequeueReusableCell(withIdentifier: "SectionsTypeAddedTableViewCell", for: indexPath) as? SectionsTypeAddedTableViewCell else { return UITableViewCell() }
            
            let name = twoDimensionalArray[indexPath.section].name
            
            cell.titleLabel.text = name //name
            
            if twoDimensionalArray[indexPath.section].sub?.isEmpty == true {
                
//                if twoDimensionalArray[indexPath.section].isExpanded == true {
//                    cell.checkImage.image = UIImage(named: "TOGGLE-1")
//                    cell.titleLabel.textColor = DesignSystem.Colors.PrimaryBlue.color
//                }else {
//                    cell.checkImage.image = UIImage(named: "TOGGLE")
//                    cell.titleLabel.textColor = DesignSystem.Colors.PrimaryBlack.color
//                }
                
                if cell.isSelected {
                    cell.checkImage.image = UIImage(named: "TOGGLE-1")
                    cell.titleLabel.textColor = DesignSystem.Colors.PrimaryBlue.color
                }else {
                    cell.checkImage.image = UIImage(named: "TOGGLE")
                    cell.titleLabel.textColor = DesignSystem.Colors.PrimaryBlack.color
                }
                
            }else {
                
                if twoDimensionalArray[indexPath.section].isExpanded == true {
                    cell.checkImage.image = UIImage(named: "arrowUp")
                    cell.titleLabel.textColor = DesignSystem.Colors.PrimaryBlue.color
                }else {
                    cell.checkImage.image = UIImage(named: "arrowDown")
                    cell.titleLabel.textColor = DesignSystem.Colors.PrimaryBlack.color
                }
                
            }
            
            
            
//            if showIndexPaths {
//                cell.titleLabel.text = "\(name)   Section:\(indexPath.section) Row:\(indexPath.row)"
//            }
            
            return cell
            
        }else{
            guard let cell = typesTableView.dequeueReusableCell(withIdentifier: "TypeAddedDetailsCardTableViewCell", for: indexPath) as? TypeAddedDetailsCardTableViewCell else { return UITableViewCell() }
            
            let name = twoDimensionalArray[indexPath.section].sub?[indexPath.row - 1]
            
            cell.titleLabel.text = name?.name
            
//            if showIndexPaths {
//                cell.titleLabel.text = "\(name)   Section:\(indexPath.section) Row:\(indexPath.row)"
//            }
            
//            if twoDimensionalArray[indexPath.section].sub?.isEmpty == true {
//
//                if twoDimensionalArray[indexPath.section].isExpanded == true {
//                    cell.checkImage.image = UIImage(named: "TOGGLE-1")
//                    cell.titleLabel.textColor = DesignSystem.Colors.PrimaryBlue.color
//                }else {
//                    cell.checkImage.image = UIImage(named: "TOGGLE")
//                    cell.titleLabel.textColor = DesignSystem.Colors.PrimaryBlack.color
//                }
//
//            }else {
//
//                if twoDimensionalArray[indexPath.section].isExpanded == true {
//                    cell.checkImage.image = UIImage(named: "arrowUp")
//                    cell.titleLabel.textColor = DesignSystem.Colors.PrimaryBlue.color
//                }else {
//                    cell.checkImage.image = UIImage(named: "arrowDown")
//                    cell.titleLabel.textColor = DesignSystem.Colors.PrimaryBlack.color
//                }
//
//            }
            
            if twoDimensionalArray[indexPath.section].isExpanded == true {
                cell.checkImage.image = UIImage(named: "TOGGLE-1")
                cell.titleLabel.textColor = DesignSystem.Colors.PrimaryBlue.color
            }else {
                cell.checkImage.image = UIImage(named: "TOGGLE")
                cell.titleLabel.textColor = DesignSystem.Colors.PrimaryBlack.color
            }
            
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
//            if let cell = typesTableView.cellForRow(at: indexPath) as? SectionsTypeAddedTableViewCell {
//
//                let isExpand = (twoDimensionalArray[indexPath.section].isExpanded ?? false)
//                twoDimensionalArray[indexPath.section].isExpanded = !isExpand
//                typesTableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
//
//                if twoDimensionalArray[indexPath.section].isExpanded == true {
//                    cell.set()
//                }else {
//                    cell.unSet()
//                }
//
//            }
            let name = twoDimensionalArray[indexPath.section].sub
            if name?.isEmpty == true || name?.count == 0 || name == nil {
                
                //self.selected = ""
                //self.value = ""
                
//                let isExpand = (twoDimensionalArray[indexPath.section].isExpanded ?? false)
//                twoDimensionalArray[indexPath.section].isExpanded = !isExpand
//                typesTableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
//                typesTableView.reloadData()
                
                if let cell = typesTableView.cellForRow(at: indexPath) as? SectionsTypeAddedTableViewCell {
                    
                    if cell.isSelected {
                        cell.checkImage.image = UIImage(named: "TOGGLE-1")
                        cell.titleLabel.textColor = DesignSystem.Colors.PrimaryBlue.color
                        //cell.isSelected = false
                        //typesTableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
                        //typesTableView.reloadData()
                        self.selected = twoDimensionalArray[indexPath.section].name
                        self.value = "\(twoDimensionalArray[indexPath.section].id ?? 0)"
                        
                    }else {
                        cell.checkImage.image = UIImage(named: "TOGGLE")
                        cell.titleLabel.textColor = DesignSystem.Colors.PrimaryBlack.color
                        
                        self.selected = ""
                        self.value = ""
                        
                    }
                    
                }
                
                
            }else {
                
                let isExpand = (twoDimensionalArray[indexPath.section].isExpanded ?? false)
                twoDimensionalArray[indexPath.section].isExpanded = !isExpand
                typesTableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
                self.selected = twoDimensionalArray[indexPath.section].sub?[indexPath.row].name
                self.value = "\(twoDimensionalArray[indexPath.section].sub?[indexPath.row].id ?? 0)"
            }
            
            
        }else{
            
//            let isExpand = (twoDimensionalArray[indexPath.section].isExpanded ?? false)
//            twoDimensionalArray[indexPath.section].isExpanded = !isExpand
//            typesTableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
//            self.selected = twoDimensionalArray[indexPath.section].name
//            self.value = "\(twoDimensionalArray[indexPath.section].id ?? 0)"
            
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
//            if let cell = typesTableView.cellForRow(at: indexPath) as? SectionsTypeAddedTableViewCell {
//
//                let isExpand = (twoDimensionalArray[indexPath.section].isExpanded ?? false)
//                twoDimensionalArray[indexPath.section].isExpanded = !isExpand
//                typesTableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
//
//                if twoDimensionalArray[indexPath.section].isExpanded == true {
//                    cell.set()
//                }else {
//                    cell.unSet()
//                }
//
//            }
            let name = twoDimensionalArray[indexPath.section].sub
            if name?.isEmpty == true || name?.count == 0 || name == nil {
                
                //self.selected = ""
                //self.value = ""
                
//                let isExpand = (twoDimensionalArray[indexPath.section].isExpanded ?? false)
//                twoDimensionalArray[indexPath.section].isExpanded = !isExpand
//                typesTableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
//                typesTableView.reloadData()
//                self.selected = twoDimensionalArray[indexPath.section].name
//                self.value = "\(twoDimensionalArray[indexPath.section].id ?? 0)"
                if let cell = typesTableView.cellForRow(at: indexPath) as? SectionsTypeAddedTableViewCell {
                    
                    if cell.isSelected {
                        cell.checkImage.image = UIImage(named: "TOGGLE-1")
                        cell.titleLabel.textColor = DesignSystem.Colors.PrimaryBlue.color
                        //cell.isSelected = false
                        //typesTableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
                        typesTableView.reloadData()
                    }else {
                        cell.checkImage.image = UIImage(named: "TOGGLE")
                        cell.titleLabel.textColor = DesignSystem.Colors.PrimaryBlack.color
                    }
                    
                }
                
                
            }else {
                
                let isExpand = (twoDimensionalArray[indexPath.section].isExpanded ?? false)
                twoDimensionalArray[indexPath.section].isExpanded = !isExpand
                typesTableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
                self.selected = twoDimensionalArray[indexPath.section].sub?[indexPath.row].name
                self.value = "\(twoDimensionalArray[indexPath.section].sub?[indexPath.row].id ?? 0)"
            }
            
            
        }
        
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 60
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

//    self.dismiss(animated: false) {
//        self.dataBackClouser?(self.selectLanguage ?? [], self.valueBack ?? [])
//    }
    
//    @objc func handleShowIndexPath() {
//
//        print("Attemping reload animation of indexPaths...")
//
//        // build all the indexPaths we want to reload
//        var indexPathsToReload = [IndexPath]()
//
//        for section in twoDimensionalArray.indices {
//            for row in twoDimensionalArray[section].names.indices {
//                print(section, row)
//                let indexPath = IndexPath(row: row, section: section)
//                indexPathsToReload.append(indexPath)
//            }
//        }
//
//        //        for index in twoDimensionalArray[0].indices {
//        //            let indexPath = IndexPath(row: index, section: 0)
//        //            indexPathsToReload.append(indexPath)
//        //        }
//
//        showIndexPaths = !showIndexPaths
//
//        let animationStyle = showIndexPaths ? UITableView.RowAnimation.right : .left
//
//        typesTableView.reloadRows(at: indexPathsToReload, with: animationStyle)
//    }
    
//    @objc func handleExpandClose(button: UIButton) {
//        print("Trying to expand and close section...")
//
//        let section = button.tag
//
//        // we'll try to close the section first by deleting the rows
//        var indexPaths = [IndexPath]()
//        for row in twoDimensionalArray[section].names.indices {
//            print(0, row)
//            let indexPath = IndexPath(row: row, section: section)
//            indexPaths.append(indexPath)
//        }
//
//        let isExpanded = twoDimensionalArray[section].isExpanded
//        twoDimensionalArray[section].isExpanded = !(isExpanded ?? false)
//
//        button.setTitle(isExpanded ?? false ? "Open" : "Close", for: .normal)
//
//        if isExpanded ?? false {
//            typesTableView.deleteRows(at: indexPaths, with: .fade)
//        } else {
//            typesTableView.insertRows(at: indexPaths, with: .fade)
//        }
//    }
