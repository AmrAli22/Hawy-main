//
//  SalesAuctionViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 11/08/2022.
//

import UIKit
import Combine
import Alamofire

class SalesAuctionViewController: BaseViewViewController {
    
    @IBOutlet weak var currentView: UIView!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var currentButtonOutlet: UIButton!
    @IBOutlet weak var commingView: UIView!
    @IBOutlet weak var commingLabel: UILabel!
    @IBOutlet weak var commingButtonOutlet: UIButton!
    @IBOutlet weak var collectionContainer: UIView!
    @IBOutlet weak var salesAuctionTableView: UITableView! {
        didSet {
            salesAuctionTableView.separatorStyle = .none
            //salesAuctionTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
            
            salesAuctionTableView.register(UINib(nibName: "SalesAuctionTableViewCell", bundle: nil), forCellReuseIdentifier: "SalesAuctionTableViewCell")
            salesAuctionTableView.dataSource = self
            salesAuctionTableView.delegate = self
        }
    }
    
    @IBOutlet weak var emptyView: UIView!
    
    let firstColor = DesignSystem.Colors.PrimaryBlue.color
    let secondColor = DesignSystem.Colors.PrimaryOrange.color
    
    var subscriber = Set<AnyCancellable>()
    
    private var viewModel = ProfileViewModel()
    
    var cellRowToTimerMapping: [Int: Timer] = [:]
    var cellRowToPauseFlagMapping: [Int: Bool] = [:]
    
    var now = true
    
    //Int(Date.currentTimeStamp)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentView.setGradient(firstColor: firstColor, secondColor: secondColor)
        DispatchQueue.main.async {
            self.commingView.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
            self.currentLabel.textColor = .white
            self.commingLabel.textColor = .black
        }
        
        Task {
            do {
                let myAuctions = try await viewModel.myAuctions(type: "now")
                print(myAuctions)
            }catch {
                // tell the user something went wrong, I hope
                debugPrint(error)
            }
        }
        
        sinkToLoading()
        sinkToReLoading()
        SinkToUnAuth()
        sinkToProfileMyAuctionsModelPublisher()
        sinkToProfileMyAuctionsDataPublisher()
        
//        if viewModel.profileMyAuctionsModel?.item?.isEmpty == true {
//            self.emptyView.isHidden = false
//        }else {
//            self.emptyView.isHidden = true
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProfileData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionContainer.roundCorners([.topLeft, .topRight], radius: 20)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func currentButtonAction(_ sender: Any) {
        
        //self.emptyView.isHidden = true
        currentView.setGradient(firstColor: firstColor, secondColor: secondColor)
        DispatchQueue.main.async {
            self.commingView.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
            self.currentLabel.textColor = .white
            self.commingLabel.textColor = .black
        }
        
        Task {
            do {
                let myAuctions = try await viewModel.myAuctions(type: "now")
                print(myAuctions)
            }catch {
                // tell the user something went wrong, I hope
                debugPrint(error)
            }
        }
        
        sinkToLoading()
        sinkToReLoading()
        SinkToUnAuth()
        sinkToProfileMyAuctionsModelPublisher()
        sinkToProfileMyAuctionsDataPublisher()
        
        now = true
        
//        if viewModel.profileMyAuctionsModel?.item?.isEmpty == true {
//            self.emptyView.isHidden = false
//        }else {
//            self.emptyView.isHidden = true
//        }
        
    }
    
    @IBAction func commingButtonAction(_ sender: Any) {
        
        //self.emptyView.isHidden = true
        commingView.setGradient(firstColor: firstColor, secondColor: secondColor)
        DispatchQueue.main.async {
            self.currentView.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
            self.currentLabel.textColor = .black
            self.commingLabel.textColor = .white
        }
        
        Task {
            do {
                let myAuctions = try await viewModel.myAuctions(type: "coming")
                print(myAuctions)
            }catch {
                // tell the user something went wrong, I hope
                debugPrint(error)
            }
        }
        
        sinkToLoading()
        sinkToReLoading()
        SinkToUnAuth()
        sinkToProfileMyAuctionsModelPublisher()
        sinkToProfileMyAuctionsDataPublisher()
        
        now = false
        
//        if viewModel.profileMyAuctionsModel?.item?.isEmpty == true {
//            self.emptyView.isHidden = false
//        }else {
//            self.emptyView.isHidden = true
//        }
        
    }
    
    func getProfileData() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")"
        ]
        
        showIndecator() //?user_id=20
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
                
                self.hideIndecator()
            } catch {
                self.hideIndecator()
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
                    self.salesAuctionTableView.reloadData()
                }
            }.store(in: &subscriber)
    }
    
    func sinkToProfileMyAuctionsModelPublisher() {
        viewModel.profileMyAuctionsModelPublisher.sink { [weak self] (result) in
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
            }
                
            
        }.store(in: &subscriber)
    }
    
    func SinkToUnAuth() {
        viewModel.isErrorPublisher.sink { msg in
            if msg == "Unauthenticated." {
                
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
            
        }.store(in: &subscriber)
    }
    
    
    func sinkToProfileMyAuctionsDataPublisher() {
        viewModel.profileMyAuctionsDataPublisher.sink { [weak self] (result) in
            guard let self = self else { return }
            if result?.isEmpty == true {
                self.emptyView.isHidden = false
            }else {
                self.emptyView.isHidden = true
            }
        }.store(in: &subscriber)
    }
    
    private func setupTimer(for cell: UITableViewCell, indexPath: IndexPath, numberOfSeconds: Int) {
        let row = indexPath.row
        if cellRowToTimerMapping[row] == nil {
            var numberOfSecondsPassed = numberOfSeconds
            let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { capturedTimer in
                
                if self.cellRowToPauseFlagMapping[row] != nil && self.cellRowToPauseFlagMapping[row] == true {
                    return
                }
                                
                numberOfSecondsPassed -= 1
                
                if let visibleCell = self.salesAuctionTableView.cellForRow(at: indexPath) as? SalesAuctionTableViewCell {
                    
//                    if let visibleCell = visibleCell {
//
//                    }
                    
                    visibleCell.timerLabel.text = self.timeFormatted(numberOfSecondsPassed) // will show timer
                    visibleCell.timerLabel.textColor = DesignSystem.Colors.PrimaryBlack.color
                    
                    if numberOfSecondsPassed == 0 {
                        numberOfSecondsPassed = 0
                        self.cellRowToPauseFlagMapping[row] = true
                        
                        visibleCell.timerLabel.text = "00 : 00 : 00"
                        visibleCell.timerLabel.textColor = DesignSystem.Colors.PrimaryDarkRed.color
                        
//                        if let visibleCell = visibleCell {
//
//                            //self.timer2?.invalidate()
//                            //visibleCell.textLabel?.text = "Loading..."
//                        }
//                        else {
//
//
//
//                            visibleCell.totalTime -= 1
//                        }
                        
                        self.makeNetworkCall {
                            //self.cellRowToPauseFlagMapping[row] = false
                        }
                    }
                    
                }

                
            }
            cellRowToTimerMapping[row] = timer
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    
    //MARK:- SetUp timeFormatted
    func timeFormatted(_ totalSeconds: Int) -> String {
        
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hour: Int = totalSeconds / 3600
        
        return hour > 0 ? String(format: "%02d:%02d:%02d", hour, minutes, seconds) : String(format: "%02d:%02d", minutes, seconds)
        
    }
    

    private func makeNetworkCall(completion: @escaping () -> Void) {
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
}

extension SalesAuctionViewController: UITableViewDelegate, UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.profileMyAuctionsModel?.item?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = salesAuctionTableView.dequeueReusableCell(withIdentifier: "SalesAuctionTableViewCell", for: indexPath) as? SalesAuctionTableViewCell else { return UITableViewCell() }
        
        let item = viewModel.profileMyAuctionsModel?.item?[indexPath.row]
        
        cell.titleLabel.text = item?.name ?? ""
        cell.nameLabel.text = item?.user ?? ""
        
        let endTime = (item?.endDate ?? 0)
        let currentTime = Int(Date.currentTimeStamp)
        
        if now == true {
            let finalTimeStamp = endTime - currentTime
            
            //cell.startOtpTimer(data: item)
            cell.timerLabel.isHidden = false
            setupTimer(for: cell, indexPath: indexPath, numberOfSeconds: finalTimeStamp)
        }else {
            print("comming")
            cell.timerLabel.text = ""
            cell.timerLabel.isHidden = true
        }
        
        //cell.dateLabel.text = "\(item?.startDate ?? 0)"
        let formatter3 = DateFormatter()
        formatter3.dateFormat = " dd-MM-yyyy hh:mm a"
        print(formatter3.string(from: Date(timeIntervalSince1970: TimeInterval(item?.startDate ?? 0))))
        cell.dateLabel.text = formatter3.string(from: Date(timeIntervalSince1970: TimeInterval(item?.startDate ?? 0)))
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if now == true {
            let item = viewModel.profileMyAuctionsModel?.item?[indexPath.row]
            
            let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
            let VC = storyborad.instantiateViewController(withIdentifier: "SalesAuctionsProductsViewController") as? SalesAuctionsProductsViewController
            
            VC?.name = item?.name ?? ""
            VC?.user = item?.owner?.name ?? ""
            VC?.date = "\(item?.startDate ?? 0)"
            VC?.image = item?.owner?.image ?? ""
            VC?.bidsCount = item?.bidCounter ?? 0
            print(indexPath.row)
            VC?.cards = item?.cards ?? []
            VC?.auctionId = item?.id
            VC?.titleType = 0
            
            navigationController?.pushViewController(VC!, animated: false)
        }else {
            ToastManager.shared.showError(message: "Auction doesn't start yet !".localized, view: self.view)
        }
        
        
    }
    
}
