//
//  AuctionLiveVideo.swift
//  Hawy
//
//  Created by Amr Ali on 16/01/2023.
//

import UIKit
import Alamofire
import PusherSwift
import AgoraRtcKit
import Alamofire
import AVFoundation

class AuctionLiveVideo: BaseViewViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var acceptRjectRaiseHandViewHeight: NSLayoutConstraint!
    @IBOutlet weak var acceptRjectRaiseHandView: UIView!
    @IBOutlet weak var cardsGradientView: GradientView!
    @IBOutlet weak var containerViewOfCardsTableView: UIView!
    @IBOutlet weak var cardsTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cardsTableView: UITableView!{
        didSet{
            cardsTableView.register(UINib(nibName: "LiveCardsTableViewCell", bundle: nil), forCellReuseIdentifier: "LiveCardsTableViewCell")
            cardsTableView.register(UINib(nibName: "CardsStatusTableViewCell", bundle: nil), forCellReuseIdentifier: "CardsStatusTableViewCell")
            cardsTableView.delegate = self
            cardsTableView.dataSource = self
            if #available(iOS 15.0, *) { cardsTableView.sectionHeaderTopPadding = 0 } else {}
        }
    }
    
    @IBOutlet weak var partecipantView: UIView!
    @IBOutlet weak var partecipantViewHeight: NSLayoutConstraint!
    @IBOutlet weak var membersCountLabel: UILabel!
    @IBOutlet weak var membersInLiveCollection: UICollectionView!{
        didSet {
            membersInLiveCollection.dataSource = self
            membersInLiveCollection.delegate = self
            membersInLiveCollection.register(UINib(nibName: "LiveMembersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LiveMembersCollectionViewCell")
        }
    }
    @IBOutlet weak var controlButtons: UIView!
    @IBOutlet weak var remoteVideoMutedIndicator: UIImageView!
    @IBOutlet weak var localVideoMutedBg: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var clockImage: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var ownerUserImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var plusButtonOutlet: UIButton!
    @IBOutlet weak var minusButtonOutlet: UIButton!
    @IBOutlet weak var bidLabel: UILabel!
    @IBOutlet weak var plusMinusDescLabel: UILabel!
    @IBOutlet weak var currencyBidLabel: UILabel!
    @IBOutlet weak var videoMuteButton: UIButton!
    @IBOutlet weak var micMuteButton: UIButton!
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var hangupButton: UIButton!
    @IBOutlet weak var requestedUserImage: UIImageView!
    @IBOutlet weak var requestedUserNameLable: UILabel!
    @IBOutlet weak var highPriceView: UIView!
    @IBOutlet weak var descriptionOfWinAndLoseViewHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionOfWinAndLoseView: UIView!
    @IBOutlet weak var plusMinusViewHeight: NSLayoutConstraint!
    @IBOutlet weak var plusMinusView: UIView!
    @IBOutlet weak var addBidViewHeight: NSLayoutConstraint!
    @IBOutlet weak var addBidView: UIView!
    @IBOutlet weak var addBidButton: GradientButton!
    @IBOutlet weak var sendRaiseHandViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sendRaiseHandView: UIView!
    @IBOutlet weak var sendRaiseHandButton: UIButton!
    @IBOutlet weak var cardsTitleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cardsTitleView: UIView!
    @IBOutlet weak var cardDetailsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cardDetailsView: UIView!
    @IBOutlet weak var animalName: UILabel!
    @IBOutlet weak var fatherName: UILabel!
    @IBOutlet weak var motherName: UILabel!
    @IBOutlet weak var noteTV: UITextView!
    
    @IBOutlet weak var BidingStatues: UILabel!
    @IBOutlet weak var emojUiImage: UIImageView!
    
    
   //MARK: - ENDOutlets
    var muteMic = false {
        didSet {
            if muteMic == false {
                micMuteButton.setImage(UIImage(named: "muteButtonSelected"), for: .normal)
                microphoneStatus(mic: "on")
                agoraEngine.muteLocalAudioStream(false)
            }else {
                micMuteButton.setImage(UIImage(named: "muteButton"), for: .normal)
                microphoneStatus(mic: "off") //"on" //off
                agoraEngine.muteLocalAudioStream(true)
            }
        }
    }

    var VideoStatues = true {
        didSet {
            if VideoStatues {
               // videoStatus(status: "on")
                videoMuteButton.setImage(UIImage(named: "videoMuteButton"), for: .normal)
                remoteView.isHidden = false
                remoteVideoMutedIndicator.isHidden = true
                agoraEngine.muteLocalVideoStream(false)
            }else {
               // videoStatus(status: "off")
                videoMuteButton.setImage(UIImage(named: "videoMuteButtonSelected"), for: .normal)
                remoteView.isHidden = true
                remoteVideoMutedIndicator.isHidden = false
                agoraEngine.muteLocalVideoStream(true)
            }
        }
    }
    


    @IBOutlet weak var remoteView: UIView!
    // var remoteView: UIView!
    // Click to join or leave a call
    var joinButton: UIButton!
    // Track if the local user is in a call
    var joined: Bool = false
    
    // The main entry point for Video SDK
    var agoraEngine: AgoraRtcEngineKit!
    // By default, set the current user role to broadcaster to both send and receive streams.
    var userRole: AgoraClientRole = .broadcaster
    
    // Update with the App ID of your project generated on Agora Console.
    let AppID: String = "7b6a157448db44578f1c88fbefecbac0"
    // Update with the temporary token generated in Agora Console.
    var token: String? = "0067b6a157448db44578f1c88fbefecbac0IAA0ZGL/a/kQJ6usIYFvTYHgpiEsFSI5EuaMKNerouqRQysW3Bu379yDEAAydAAAEn/IYwEAAQCiO8dj"
    
    // Update with the channel name you used to generate the token in Agora Console.
    var channelName = "auction_139123"
    
    let decoder = JSONDecoder()
    var pusherCards: Pusher!
    var pusher: Pusher!
    var pusherTime: Pusher!
    var bidPusher: Pusher!
    var pusher3: Pusher!
    var pusher4: Pusher!
    var pusher6: Pusher!
    var pusher7: Pusher!
    
    // Tutorial Step 1
    var auctionID: Int?
    var cardID : Int? {
        didSet{
            
            if iamConductor {
                self.listenToRaiseHandCall(auction_id: self.auctionID, card_id: self.cardID)
            }
            self.listenToChangesFromPusherTime(auction_id: self.auctionID, card_id: self.cardID)
            if HelperConstant.getCurrency() == "USD" {
                self.listenToChangesFromPusherUSD(auction_id: self.auctionID, card_id: self.cardID)
            }else {
                self.listenToChangesFromKWDPusher(auction_id: self.auctionID, card_id: self.cardID)
            }
            self.listenToOutVideoCall(auction_id: self.auctionID, card_id: self.cardID)
            self.listenToMicCall(auction_id: self.auctionID, card_id: self.cardID)
            
        }
    }
    
    var time: Int?
    var currentTime: Int?
    
    var timer2: Timer?
    var totalTime: Int = 0
    var finalTotal: Int = 0
    var lastOfferUserId: Int?
    var firstTimeCardSelect = false
    
    
    var channel:String?
    var currentUserId: UInt?
    var bidMaxPrice: String?
    
    var acceptRejectId: Int?
    
    var collapse = true
    var cardsCollapse = true
    var AllRequsts = [JoinedUser]()
    var cards = [Card]()
    var cardItem: NewLiveAuctionItem?
    
    var index1 = 1
    var index2 = 2
    var index3 = 3
    
    @IBOutlet weak var bidingAmountView: UIView!
    @IBOutlet weak var bidingActionView: UIView!
    
    var iamConductor = false
    override func viewDidLoad() {
        super.viewDidLoad()
      //  initViews()
        currencyLabel.text = HelperConstant.getCurrency()
        videoMuteButton.setImage(UIImage(named: "videoMuteButton"), for: .normal)
        micMuteButton.setImage(UIImage(named: "muteButton"), for: .normal)
        switchCameraButton.setImage(UIImage(named: "switchCameraButtonSelected"), for: .normal)
        membersInLiveCollection.collectionViewLayout = createCompositionalLayout()
        
        partecipantViewHeight.constant = 100
        membersInLiveCollection.isHidden = true
        
        cardsTableViewHeight.constant = 0
        cardsTableView.isHidden = true
        containerViewOfCardsTableView.isHidden = true

        getLiveAuctionData(id: self.auctionID)
        initializeAgoraEngine()
    }
 
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        leaveChannel()
        DispatchQueue.global(qos: .userInitiated).async {AgoraRtcEngineKit.destroy()}
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cardsGradientView.roundCornersWithMask([.topLeading, .topTrailing, .bottomLeading, .bottomTrailing], radius: 20)
        
        highPriceView.roundCornersWithMask([.topLeading, .topTrailing, .bottomLeading, .bottomTrailing], radius: 10)
        
        let gradient = UIImage.gradientImage(bounds: ownerUserImage.bounds, colors: [DesignSystem.Colors.PrimaryBlue.color, DesignSystem.Colors.PrimaryOrange.color])
        let gradientColor = UIColor(patternImage: gradient)
        ownerUserImage.layer.borderColor = gradientColor.cgColor
        ownerUserImage.layer.borderWidth = 3
        
        if AppLocalization.currentAppleLanguage() == "en" {
            plusButtonOutlet.roundCornersWithMask([.bottomLeading, .bottomLeading], radius: 10)
            minusButtonOutlet.roundCornersWithMask([.topTrailing, .bottomTrailing], radius: 10)
        }else {
            plusButtonOutlet.roundCornersWithMask([.topTrailing, .bottomTrailing], radius: 10)
            minusButtonOutlet.roundCornersWithMask([.topLeading, .bottomLeading], radius: 10)
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        
        DispatchQueue.main.async { [weak self] in
            //your code here
            guard let self = self else { return }
            
            self.view.layoutIfNeeded()
            self.cardsTableViewHeight.constant = self.cardsTableView.contentSize.height
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        deleteUserAuctionVideo()
        self.videoStatus(status: "off")
        navigationController?.popViewController(animated: true)
    }

    
}

extension AuctionLiveVideo {
    @IBAction func addBidButtonAction(_ sender: Any) {
        performAddBidRequest()
    }
    @IBAction func VaccinationsTapped(_ sender: Any) {
        let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "CardVaccinationsViewController") as? CardVaccinationsViewController
        VC?.cardId = cardID
        navigationController?.pushViewController(VC!, animated: false)
    }
    
    @IBAction func ownersTapped(_ sender: Any) {
        let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "CardOwnersViewController") as? CardOwnersViewController
        VC?.cardId = cardID
        navigationController?.pushViewController(VC!, animated: false)
    }
    
    @IBAction func infoTapped(_ sender: Any) {
        let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "CardInfoViewController") as? CardInfoViewController
        VC?.cardId = cardID
        navigationController?.pushViewController(VC!, animated: false)
    }
    
    @IBAction func rejectRequestButtonTapped(_ sender: Any) {
        raiseHandStatus(status: "reject")
    }
    
    @IBAction func acceptRequestButtonTapped(_ sender: Any) {
        raiseHandStatus(status: "accept")
    }
    
    @IBAction func raiseHandRequestButtonTapped(_ sender: Any) {
        raiseHand()
    }
    
    @IBAction func plusButtonAction(_ sender: Any) {
        if Double(self.bidMaxPrice ?? "0.0") ?? 0.0 >= 1000.0 {
            plusMinusDescLabel.text = "The minimum increase is 50 dinars".localized
            let plus = (Int(bidLabel.text ?? "") ?? 0) + 50
            bidLabel.text = "\(plus)"
        }else {
            plusMinusDescLabel.text = "The minimum increase is 10 dinars".localized
            let plus = (Int(bidLabel.text ?? "") ?? 0) + 10
            bidLabel.text = "\(plus)"
        }
    }
    @IBAction func minusButtonAction(_ sender: Any) {
        let plus = (Int(bidLabel.text ?? "") ?? 0) - 10
        if (Int(bidLabel.text ?? "") ?? 0) <= 10 { //plus <= 0
        }else {
            if Double(self.bidMaxPrice ?? "0.0") ?? 0.0 >= 1000.0 {
                plusMinusDescLabel.text = "The minimum increase is 50 dinars".localized
                let plus = (Int(bidLabel.text ?? "") ?? 0) - 50
                bidLabel.text = "\(plus)"
            }else {
                plusMinusDescLabel.text = "The minimum increase is 10 dinars".localized
                let plus = (Int(bidLabel.text ?? "") ?? 0) - 10
                bidLabel.text = "\(plus)"
            }
        }
    }
    
    @IBAction func acceptButtonAction(_ sender: Any) {
        //performUpdateStatusAgree(status: "agree", CurrentCardID: <#Int#>)
    }
    
    @IBAction func rejectButtonOutlet(_ sender: Any) {
        //performUpdateStatusDisagree(status: "disagree", CurrentCardID: <#Int#>)
    }
    
    @IBAction func payDoneButtonOutlet(_ sender: Any) {
        //performUpdateStatusPayDone(status: "confirm_payment_and_delivery", CurrentCardID: <#Int#>)
    }
}

