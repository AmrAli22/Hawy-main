////
////  NewLiveViewController.swift
////  Hawy
////
////  Created by ahmed abu elregal on 22/12/2022.
////
//
//import UIKit
//import Alamofire
//import PusherSwift
//import AgoraRtcKit
//import Alamofire
//import AVFoundation
//
//
//class NewLiveViewController: BaseViewViewController, PusherDelegate {
//    
//    
//    @IBOutlet weak var cardsGradientView: GradientView!
//    @IBOutlet weak var containerViewOfCardsTableView: UIView!
//    @IBOutlet weak var cardsTableViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var cardsTableView: UITableView!{
//        didSet{
//            
//            cardsTableView.register(UINib(nibName: "LiveCardsTableViewCell", bundle: nil), forCellReuseIdentifier: "LiveCardsTableViewCell")
//            cardsTableView.register(UINib(nibName: "CardsStatusTableViewCell", bundle: nil), forCellReuseIdentifier: "CardsStatusTableViewCell")
//            
//            cardsTableView.delegate = self
//            cardsTableView.dataSource = self
//            
//            //cardsTableView.rowHeight = 400
//            //cardsTableView.estimatedRowHeight = UITableView.automaticDimension
//            
//            if #available(iOS 15.0, *) {
//                cardsTableView.sectionHeaderTopPadding = 0
//            } else {
//                // Fallback on earlier versions
//            }
//            
//        }
//    }
//    
//    @IBOutlet weak var partecipantView: UIView!
//    @IBOutlet weak var partecipantViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var membersCountLabel: UILabel!
//    @IBOutlet weak var membersInLiveCollection: UICollectionView!{
//        didSet {
//            
//            membersInLiveCollection.dataSource = self
//            membersInLiveCollection.delegate = self
//            
//            membersInLiveCollection.register(UINib(nibName: "LiveMembersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LiveMembersCollectionViewCell")
//            
//        }
//    }
//    
//    //@IBOutlet weak var localVideo: UIView!
// //   @IBOutlet weak var remoteVideo: UIView!
//    @IBOutlet weak var controlButtons: UIView!
//    @IBOutlet weak var remoteVideoMutedIndicator: UIImageView!
//    @IBOutlet weak var localVideoMutedBg: UIView!
//    //@IBOutlet weak var localVideoMutedIndicator: UIImageView!
//    
//    @IBOutlet weak var timerLabel: UILabel!
//    @IBOutlet weak var clockImage: UIImageView!
//    
//    @IBOutlet weak var ownerNameLabel: UILabel!
//    @IBOutlet weak var ownerUserImage: UIImageView!
//    @IBOutlet weak var priceLabel: UILabel!
//    @IBOutlet weak var currencyLabel: UILabel!
//    
//    @IBOutlet weak var plusButtonOutlet: UIButton!
//    @IBOutlet weak var minusButtonOutlet: UIButton!
//    @IBOutlet weak var bidLabel: UILabel!
//    @IBOutlet weak var plusMinusDescLabel: UILabel!
//    @IBOutlet weak var currencyBidLabel: UILabel!
//    
//    @IBOutlet weak var videoMuteButton: UIButton!
//    @IBOutlet weak var micMuteButton: UIButton!
//    @IBOutlet weak var switchCameraButton: UIButton!
//    @IBOutlet weak var hangupButton: UIButton!
//    
//    @IBOutlet weak var acceptRjectRaiseHandViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var acceptRjectRaiseHandView: UIView!
//    @IBOutlet weak var requestedUserImage: UIImageView!
//    @IBOutlet weak var requestedUserNameLable: UILabel!
//    
//    @IBOutlet weak var highPriceView: UIView!
//    
//    @IBOutlet weak var descriptionOfWinAndLoseViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var descriptionOfWinAndLoseView: UIView!
//    
//    @IBOutlet weak var plusMinusViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var plusMinusView: UIView!
//    
//    @IBOutlet weak var addBidViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var addBidView: UIView!
//    @IBOutlet weak var addBidButton: GradientButton!
//    
//    @IBOutlet weak var sendRaiseHandViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var sendRaiseHandView: UIView!
//    @IBOutlet weak var sendRaiseHandButton: UIButton!
//    
//    @IBOutlet weak var cardsTitleViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var cardsTitleView: UIView!
//    
//    @IBOutlet weak var cardDetailsViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var cardDetailsView: UIView!
//    @IBOutlet weak var animalName: UILabel!
//    @IBOutlet weak var fatherName: UILabel!
//    @IBOutlet weak var motherName: UILabel!
//    
//    @IBOutlet weak var noteTV: UITextView!
//    
//    var muteVideo = false
//     {
//        didSet {
//            if muteVideo == false {
//                videoMuteButton.setImage(UIImage(named: "videoMuteButtonSelected"), for: .normal)
//                localVideoMutedBg.isHidden = true
//                remoteVideoMutedIndicator.isHidden = true
//
//                videoStatus(status: "off")
//
//
//            }else {
//                videoMuteButton.setImage(UIImage(named: "videoMuteButton"), for: .normal)
//
//                localVideoMutedBg.isHidden = false
//                remoteVideoMutedIndicator.isHidden = false
//
//                videoStatus(status: "on")
//
//            }
//        }
//    }
//    
//    
//    var muteMic = false {
//        didSet {
//            if muteMic == false {
//                micMuteButton.setImage(UIImage(named: "muteButtonSelected"), for: .normal)
//                
//                microphoneStatus(mic: "on") //"on" //off
//                //agoraKit.muteLocalAudioStream(false)
//                
//            }else {
//                micMuteButton.setImage(UIImage(named: "muteButton"), for: .normal)
//                
//                microphoneStatus(mic: "off") //"on" //off
//                //agoraKit.muteLocalAudioStream(true)
//                
//            }
//        }
//    }
//    
//    let decoder = JSONDecoder()
//    //to get socket
//    var pusherCards: Pusher!
//    
//    var pusher: Pusher!
//    
//    var pusherTime: Pusher!
//    
//    var bidPusher: Pusher!
//    
//    var pusher3: Pusher!
//    
//    var pusher4: Pusher!
//    
//    var pusher6: Pusher!
//    
//    var pusher7: Pusher!
//    
//    var agoraKit: AgoraRtcEngineKit! // Tutorial Step 1
//    let AppID: String = "7b6a157448db44578f1c88fbefecbac0" // Tutorial Step 1
//    
//    var auctionID: Int?
//    var auction_id : Int? = 87
//    var cardID : Int?
//   // var card_id : Int?
//    
//    var time: Int?
//    var currentTime: Int?
//    
//    var userRole: AgoraClientRole = .broadcaster
//
//    var timer2: Timer?
//    var totalTime: Int = 0
//    var finalTotal: Int = 0
//    var lastOfferUserId: Int?
//    var firstTimeCardSelect = false
//    
//    var token: String?
//    var channel:String?
//    var currentUserId: UInt?
//    var bidMaxPrice: String?
//    
//    var acceptRejectId: Int?
//    
//    var collapse = true
//    var cardsCollapse = true
//    var AllRequsts = [ShowCardDetailsJoinedUser]()
//    var cards = [NewLiveAuctionCard]()
//    var cardItem: NewLiveAuctionItem?
//    
//    var index1 = 1
//    var index2 = 2
//    var index3 = 3
//    
//    
//    
//    var agoraEngine: AgoraRtcEngineKit!
//    // By default, set the current user role to broadcaster to both send and receive streams.
//  //  var userRole: AgoraClientRole = .broadcaster
//
//    // Update with the channel name you used to generate the token in Agora Console.
//    var channelName = ""
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //    initializeAgoraEngine()
//        currencyLabel.text = HelperConstant.getCurrency()
//        
//        videoMuteButton.setImage(UIImage(named: "videoMuteButtonSelected"), for: .normal)
//        micMuteButton.setImage(UIImage(named: "muteButton"), for: .normal)
//        switchCameraButton.setImage(UIImage(named: "switchCameraButtonSelected"), for: .normal)
//        
//        membersInLiveCollection.collectionViewLayout = createCompositionalLayout()
//        
//        partecipantViewHeight.constant = 100
//        membersInLiveCollection.isHidden = true
//        
//        cardsTableViewHeight.constant = 0
//        cardsTableView.isHidden = true
//        containerViewOfCardsTableView.isHidden = true
//        
//        //getCardData(id: auction_id, userId: HelperConstant.getUserId())
//        
//        getLiveAuctionData(id: self.auction_id)
//        
//       
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: true)
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        cardsGradientView.roundCornersWithMask([.topLeading, .topTrailing, .bottomLeading, .bottomTrailing], radius: 20)
//        
//        highPriceView.roundCornersWithMask([.topLeading, .topTrailing, .bottomLeading, .bottomTrailing], radius: 10)
//        
//        let gradient = UIImage.gradientImage(bounds: ownerUserImage.bounds, colors: [DesignSystem.Colors.PrimaryBlue.color, DesignSystem.Colors.PrimaryOrange.color])
//        let gradientColor = UIColor(patternImage: gradient)
//        ownerUserImage.layer.borderColor = gradientColor.cgColor
//        ownerUserImage.layer.borderWidth = 3
//        
//        if AppLocalization.currentAppleLanguage() == "en" {
//            plusButtonOutlet.roundCornersWithMask([.bottomLeading, .bottomLeading], radius: 10)
//            minusButtonOutlet.roundCornersWithMask([.topTrailing, .bottomTrailing], radius: 10)
//        }else {
//            plusButtonOutlet.roundCornersWithMask([.topTrailing, .bottomTrailing], radius: 10)
//            minusButtonOutlet.roundCornersWithMask([.topLeading, .bottomLeading], radius: 10)
//        }
//        
//    }
//    
//    override func viewWillLayoutSubviews() {
//        super.updateViewConstraints()
//        
//        DispatchQueue.main.async { [weak self] in
//            //your code here
//            guard let self = self else { return }
//            
//            self.view.layoutIfNeeded()
//            self.cardsTableViewHeight.constant = self.cardsTableView.contentSize.height
//            self.view.layoutIfNeeded()
//            
//        }
//        
//    }
//    
//    func initializeAgoraEngine() {
//        let config = AgoraRtcEngineConfig()
//        // Pass in your App ID here.
//        config.appId = AppID
//        // Use AgoraRtcEngineDelegate for the following delegate parameter.
//        agoraKit = AgoraRtcEngineKit.sharedEngine(with: config, delegate: self)
//        
//        
//             agoraKit.setChannelProfile(.communication)
//               let clientRoleOptions = AgoraClientRoleOptions()
//               clientRoleOptions.audienceLatencyLevel = .lowLatency
//        
//                agoraKit.setClientRole(.broadcaster, options: clientRoleOptions)
//                agoraKit.setDefaultAudioRouteToSpeakerphone(true)
//                agoraKit.enableAudioVolumeIndication(500, smooth: 1, reportVad: true)
//        
//        agoraKit.setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(size: AgoraVideoDimension640x480, frameRate: .fps15, bitrate: AgoraVideoBitrateStandard, orientationMode: .fixedPortrait, mirrorMode: .disabled)) //disabled
//        
//    }
//    
//    func setupLocalVideo(id: UInt) {
//        // Enable the video module
//        //        agoraKit.enableVideo()
//        //        agoraKit.enableAudio()
//        let videoCanvas = AgoraRtcVideoCanvas()
//        videoCanvas.uid = 0
//        videoCanvas.renderMode = .fit //.hidden
//        videoCanvas.view = localVideoMutedBg
//        agoraKit.setupLocalVideo(videoCanvas)
//        
//    }
//    
//    func setupRemoteVideo(id: UInt) {
//        // Enable the video module
//        //        agoraKit.enableVideo()
//        //        agoraKit.enableAudio()
//        let videoCanvas = AgoraRtcVideoCanvas()
//        videoCanvas.uid = id
//        videoCanvas.renderMode = .fit //.hidden
//        videoCanvas.view = localVideoMutedBg
//        agoraKit.setupRemoteVideo(videoCanvas)
//    }
//    
////    private func onLocalAudioMuteClicked() {
////        if agoraKit != nil {
////
////            let session = AVAudioSession.sharedInstance()
////
////            do {
////
////                try session.setMode(.voiceChat)
////                try session.setActive(true)
////
////                session.requestRecordPermission { (isAllowed) in
////
////                    OperationQueue.main.addOperation { [self] in
////
////                        if isAllowed {
////
////                            //mute? true or false
////                            agoraKit.muteLocalAudioStream(false)
////                        } else {
////
////                            print("recording_not_allowed")
////
////                        }
////                    }
////                }
////            } catch {
////                print("session_init_failed")
////            }
////        }
////    }
//    
////    func checkForPermissions() -> Bool {
////        var hasPermissions = false
////
////        switch AVCaptureDevice.authorizationStatus(for: .video) {
////        case .authorized: hasPermissions = true
////        default: hasPermissions = requestCameraAccess()
////        }
////        // Break out, because camera permissions have been denied or restricted.
////        if !hasPermissions { return false }
////        switch AVCaptureDevice.authorizationStatus(for: .audio) {
////        case .authorized: hasPermissions = true
////        default: hasPermissions = requestAudioAccess()
////        }
////        return hasPermissions
////    }
//    
////    func requestCameraAccess() -> Bool {
////        var hasCameraPermission = false
////        let semaphore = DispatchSemaphore(value: 0)
////        AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
////            hasCameraPermission = granted
////            semaphore.signal()
////        })
////        semaphore.wait()
////        return hasCameraPermission
////    }
////
////    func requestAudioAccess() -> Bool {
////        var hasAudioPermission = false
////        let semaphore = DispatchSemaphore(value: 0)
////        AVCaptureDevice.requestAccess(for: .audio, completionHandler: { granted in
////            hasAudioPermission = granted
////            semaphore.signal()
////        })
////        semaphore.wait()
////        return hasAudioPermission
////    }
//    
//    func showMessage(title: String, text: String, delay: Int = 2) -> Void {
//        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
//        self.present(alert, animated: true)
//        let deadlineTime = DispatchTime.now() + .seconds(delay)
//        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
//            alert.dismiss(animated: true, completion: nil)
//        })
//    }
//    
//    func joinChannel(id : UInt, channel: String?, token: String?) {
//        //        if !self.checkForPermissions() {
//        //            showMessage(title: "Error", text: "Permissions were not granted")
//        //            return
//        //        }
//        
//        // For a video call scenario, set the channel profile as communication.
//        //option.channelProfile = .communication
//        
//        // Join the channel with a temp token. Pass in your token and channel name here
//        guard let call_id = channel , let token = token else { return }
//        
//        
//        agoraKit.joinChannel(byToken:token, channelId: call_id, info: nil, uid: 0) { [weak self] (channel, uid, elapsed) -> Void in
//            
//            self?.agoraKit.setEnableSpeakerphone(true)
//            UIApplication.shared.isIdleTimerDisabled = true
//            
//        }
//        
//    }
//    
//    // Tutorial Step 6
//    @IBAction func didClickHangUpButton(_ sender: UIButton) {
//        //leaveChannel()
//        deleteUserAuctionVideo()
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    //    // Tutorial Step 6
//    //    func resetHideButtonsTimer() {
//    //        VideoCallViewController.cancelPreviousPerformRequests(withTarget: self)
//    //        perform(#selector(hideControlButtons), with:nil, afterDelay:3)
//    //    }
//    
//    
//    
//    // Tutorial Step 7
//    @IBAction func didClickMuteButton(_ sender: UIButton) {
//        
//        //    onLocalAudioMuteClicked()
//        
//        sender.isSelected = !sender.isSelected
// //       agoraKit.muteLocalAudioStream(sender.isSelected)
//        
//        //    resetHideButtonsTimer()
//        
//        //    sender.isSelected.toggle()
//        
//        print(muteMic)
//        muteMic.toggle()
//        print(muteMic)
//        
//        self.agoraKit.muteLocalAudioStream(!muteMic)
//        
//        //        if muteMic == true {
//        //
//        //            microphoneStatus(mic: "on") //"on" //off
//        //            agoraKit.muteLocalAudioStream(false)
//        //
//        //        }else {
//        //
//        //            microphoneStatus(mic: "off")
//        //            agoraKit.muteLocalAudioStream(true)
//        //
//        //        }
//        //
//        //        if sender.isSelected == true {
//        //            //agoraKit.muteLocalAudioStream(sender.isSelected)
//        //            microphoneStatus(mic: "on") //"on" //off
//        //            agoraKit.muteLocalAudioStream(false)
//        //        }else {
//        //            microphoneStatus(mic: "off")
//        //            agoraKit.muteLocalAudioStream(true)
//        //            //agoraKit.muteLocalAudioStream(sender.isSelected)
//        //        }
//        //
//        //        if sender.isSelected == true {
//        //            micMuteButton.setImage(UIImage(named: "muteButtonSelected"), for: .selected)
//        //        }else {
//        //            micMuteButton.setImage(UIImage(named: "muteButton"), for: .normal)
//        //        }
//        
//        
//    }
//    
//    // Tutorial Step 8
//    @IBAction func didClickVideoMuteButton(_ sender: UIButton) {
//        
//        
//        muteVideo = !muteVideo
//        agoraKit.muteLocalVideoStream(false)
//        if muteVideo{
//            videoMuteButton.setImage(UIImage(named: "videoMuteButtonSelected"), for: .selected)
//            videoStatus(status: "off")
//                                localVideoMutedBg.isHidden = true
//                                remoteVideoMutedIndicator.isHidden = false
//        }else{
//            videoMuteButton.setImage(UIImage(named: "videoMuteButton"), for: .normal)
//            videoStatus(status: "on")
//                                localVideoMutedBg.isHidden = false
//                               remoteVideoMutedIndicator.isHidden = true
//        }
//        
//        
//        
//        
//        
//        
////                sender.isSelected = !sender.isSelected
////        //        agoraKit.muteLocalVideoStream(sender.isSelected)
////        //        localVideo.isHidden = sender.isSelected
////        //        localVideoMutedBg.isHidden = !sender.isSelected
////        //        localVideoMutedIndicator.isHidden = !sender.isSelected
////
////        muteVideo.toggle()
////        self.agoraKit.muteLocalVideoStream(muteVideo)
//        
//        
//        
////        sender.isSelected.toggle()
////
////                if muteVideo == false {
////                    muteVideo = true
////                    videoMuteButton.setImage(UIImage(named: "videoMuteButton"), for: .normal)
////                    agoraKit.muteLocalVideoStream(false)
////                 //   localVideo.isHidden = true
////                    localVideoMutedBg.isHidden = false
////                    remoteVideoMutedIndicator.isHidden = false
////
////                    videoStatus(status: "on")
////
////                }else {
////                    muteVideo = false
////                    videoMuteButton.setImage(UIImage(named: "videoMuteButtonSelected"), for: .selected)
////                    agoraKit.muteLocalVideoStream(true)
////                 //   localVideo.isHidden = false
////
////                    localVideoMutedBg.isHidden = true
////                    remoteVideoMutedIndicator.isHidden = true
////
////                    videoStatus(status: "off")
////
////                }
////
//        
//        //resetHideButtonsTimer()
//        
//        //sender.isSelected.toggle()
//        //agoraKit.setDefaultAudioRouteToSpeakerphone(true)
//        
//    }
//    
//    // Tutorial Step 9
//    @IBAction func didClickSwitchCameraButton(_ sender: UIButton) {
//        //        sender.isSelected = !sender.isSelected
//        //        agoraKit.switchCamera()
//        //        resetHideButtonsTimer()
//        
//        sender.isSelected.toggle()
//        agoraKit.switchCamera()
//        
//    }
//    
//    @IBAction func backButtonTapped(_ sender: Any) {
//        navigationController?.popViewController(animated: true)
//    }
//    
//    @IBAction func partecipantButtonCollapseTapped(_ sender: Any) {
//        
//        if collapse == false {
//            
//            collapse = true
//            partecipantViewHeight.constant = 100
//            membersInLiveCollection.isHidden = true
//            
//        }else {
//            
//            collapse = false
//            partecipantViewHeight.constant = 350
//            membersInLiveCollection.isHidden = false
//            
//        }
//        
//    }
//    
//    @IBAction func cardsButtonCollapseTapped(_ sender: Any) {
//        
//        if cardsCollapse == false {
//            
//            cardsCollapse = true
//            cardsTableViewHeight.constant = 0
//            //cardsViewTableViewHeight.constant = 0
//            cardsTableView.isHidden = true
//            containerViewOfCardsTableView.isHidden = true
//            cardsGradientView.roundCornersWithMask([.topLeading, .topTrailing, .bottomLeading, .bottomTrailing], radius: 20)
//            
//        }else {
//            
//            cardsCollapse = false
//            cardsTableViewHeight.constant = self.cardsTableView.contentSize.height
//            //cardsViewTableViewHeight.constant = self.cardsTableView.contentSize.height + 10
//            cardsTableView.isHidden = false
//            containerViewOfCardsTableView.isHidden = false
//            cardsGradientView.roundCornersWithMask([.topLeading, .topTrailing], radius: 20)
//            
//        }
//        
//    }
//    
//    @IBAction func backButtonAction(_ sender: Any) {
//        navigationController?.popViewController(animated: true)
//    }
//    
//    @IBAction func addBidButtonAction(_ sender: Any) {
//        performAddBidRequest()
//    }
//    
//    @IBAction func VaccinationsTapped(_ sender: Any) {
//        
//        let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
//        let VC = storyborad.instantiateViewController(withIdentifier: "CardVaccinationsViewController") as? CardVaccinationsViewController
//        VC?.cardId = cardID
//        navigationController?.pushViewController(VC!, animated: false)
//        
//    }
//    @IBAction func ownersTapped(_ sender: Any) {
//        
//        let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
//        let VC = storyborad.instantiateViewController(withIdentifier: "CardOwnersViewController") as? CardOwnersViewController
//        VC?.cardId = cardID
//        navigationController?.pushViewController(VC!, animated: false)
//        
//    }
//    
//    @IBAction func infoTapped(_ sender: Any) {
//        
//        let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
//        let VC = storyborad.instantiateViewController(withIdentifier: "CardInfoViewController") as? CardInfoViewController
//        VC?.cardId = cardID
//        navigationController?.pushViewController(VC!, animated: false)
//        
//    }
//    
//    @IBAction func rejectRequestButtonTapped(_ sender: Any) {
//        raiseHandStatus(status: "reject")
//    }
//    
//    @IBAction func acceptRequestButtonTapped(_ sender: Any) {
//        raiseHandStatus(status: "accept")
//    }
//    
//    @IBAction func raiseHandRequestButtonTapped(_ sender: Any) {
//        raiseHand()
//    }
//    
//    @IBAction func plusButtonAction(_ sender: Any) {
//        
//        
//        if Double(self.bidMaxPrice ?? "0.0") ?? 0.0 >= 1000.0 {
//            plusMinusDescLabel.text = "The minimum increase is 50 dinars".localized
//            let plus = (Int(bidLabel.text ?? "") ?? 0) + 50
//            bidLabel.text = "\(plus)"
//        }else {
//            plusMinusDescLabel.text = "The minimum increase is 10 dinars".localized
//            let plus = (Int(bidLabel.text ?? "") ?? 0) + 10
//            bidLabel.text = "\(plus)"
//        }
//        
//    }
//    @IBAction func minusButtonAction(_ sender: Any) {
//        
//        
//        
//        let plus = (Int(bidLabel.text ?? "") ?? 0) - 10
//        
//        if (Int(bidLabel.text ?? "") ?? 0) <= 10 { //plus <= 0
//            
//        }else {
//            
//            if Double(self.bidMaxPrice ?? "0.0") ?? 0.0 >= 1000.0 {
//                plusMinusDescLabel.text = "The minimum increase is 50 dinars".localized
//                let plus = (Int(bidLabel.text ?? "") ?? 0) - 50
//                bidLabel.text = "\(plus)"
//            }else {
//                plusMinusDescLabel.text = "The minimum increase is 10 dinars".localized
//                let plus = (Int(bidLabel.text ?? "") ?? 0) - 10
//                bidLabel.text = "\(plus)"
//            }
//            
//            //bidLabel.text = "\(plus)"
//            
//        }
//        
//    }
//    
//    @IBAction func acceptButtonAction(_ sender: Any) {
//        
//        performUpdateStatusAgree(status: "agree")
//        
//    }
//    
//    @IBAction func rejectButtonOutlet(_ sender: Any) {
//        
//        performUpdateStatusDisagree(status: "disagree")
//        
//    }
//    
//    @IBAction func payDoneButtonOutlet(_ sender: Any) {
//        
//        performUpdateStatusPayDone(status: "confirm_payment_and_delivery")
//        
//    }
//    
//    
//}
//
//extension NewLiveViewController: AgoraRtcEngineDelegate {
//    
//    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
//        
//        setupRemoteVideo(id: uid)
//        
//        
//        
//    }
//    
//    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid:UInt, reason:AgoraUserOfflineReason) {
//        
//    }
//    
//    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted:Bool, byUid:UInt) {
//        
//    }
//    
//    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
//        print(warningCode)
//    }
//    
//    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
//        print(errorCode)
//    }
//    
//}
//
//extension NewLiveViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    func handleExpandClose(button: Int) {
//        
//        
//        if totalTime <= 0 {
//            
//            print("Trying to expand and close section...")
//            
//            let section = button
//            
//            let isExpanded = cards[section].isExpanded
//            cards[section].isExpanded = !isExpanded
//            
//            let selectedCard = cards[section].selectorStatus
//            cards[section].selectorStatus = !(selectedCard ?? false)
//            
//            //        if isExpanded {
//            //            cardsTableView.deleteItems(at: indexPaths)
//            //        } else {
//            //            cardsTableView.insertItems(at: indexPaths)
//            //        }
//            
//            //liveCardStatus()
//            
//            self.cardsTableView.reloadData()
//            //self.cardsTableView.reloadSections(IndexSet(integer: section), with: .none)
//            self.view.layoutIfNeeded()
//            self.cardsTableViewHeight.constant = self.cardsTableView.contentSize.height
//            self.view.layoutIfNeeded()
//            
//        }else {
//            
//            print("cant make collapse")
//            
//            liveCardStatus()
//            
//        }
//        
//    }
//    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        self.viewWillLayoutSubviews()
//        self.view.layoutIfNeeded()
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return cards.count
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        //        if cards[section].status == "pending" && finalTotal == 0 {
//        //            return 0
//        //        }else {
//        //            return 1
//        //
//        //        }
//        
//        if totalTime <= 0 && cards[section].isExpanded {
//            
//            return 1
//            
//        }else {
//            
//            return 0
//            
//        }
//        
//        //        if !cards[section].isExpanded {
//        //            return 0
//        //        }
//        
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        guard let cell = cardsTableView.dequeueReusableCell(withIdentifier: "CardsStatusTableViewCell", for: indexPath) as? CardsStatusTableViewCell else { return UITableViewCell() }
//        
//        let item = cards[indexPath.section]
//        
//        if item.liveAuctionStatus == "agree" {
//            print(indexPath.section)
//            
//            cell.bigContainerViewHeight.constant = 280
//            cell.containerViewInsideBigViewHeight.constant = 260
//            
//            cell.afterAcceptedRejectedView.isHidden = false
//            cell.afterAcceptedRejectedViewHeight.constant = 40
//            
//            cell.iconAcceptReject.image = UIImage(named: "Search results for Add - Flaticon-4")
//            cell.labelAcceptReject.text = "Offer accepted".localized
//            
//            cell.descriptionView.isHidden = false
//            cell.descriptionViewHeight.constant = 120
//            
//            cell.paymentDoneView.isHidden = false
//            cell.paymentDoneViewHeight.constant = 100
//            
//            cell.acceptAndRejectButtonsView.isHidden = true
//            cell.acceptAndRejectButtonsViewHeight.constant = 0
//            
//        }else if item.liveAuctionStatus == "disagree" {
//            print(indexPath.section)
//            
//            cell.bigContainerViewHeight.constant = 60
//            cell.containerViewInsideBigViewHeight.constant = 40
//            
//            cell.afterAcceptedRejectedView.isHidden = false
//            cell.afterAcceptedRejectedViewHeight.constant = 40
//            
//            cell.iconAcceptReject.image = UIImage(named: "Search results for Add - Flaticon-6")
//            cell.labelAcceptReject.text = "Offer rejected".localized
//            
//            cell.descriptionView.isHidden = true
//            cell.descriptionViewHeight.constant = 0
//            
//            cell.paymentDoneView.isHidden = true
//            cell.paymentDoneViewHeight.constant = 0
//            
//            cell.acceptAndRejectButtonsView.isHidden = true
//            cell.acceptAndRejectButtonsViewHeight.constant = 0
//            
//        }else if item.liveAuctionStatus == "confirm_payment_and_delivery" {
//            print(indexPath.section)
//            
//            cell.bigContainerViewHeight.constant = 60
//            cell.containerViewInsideBigViewHeight.constant = 40
//            
//            cell.afterAcceptedRejectedView.isHidden = false
//            cell.afterAcceptedRejectedViewHeight.constant = 40
//            
//            cell.iconAcceptReject.image = UIImage(named: "Search results for Add - Flaticon-4")
//            cell.labelAcceptReject.text = "Offer accepted".localized
//            
//            cell.descriptionView.isHidden = true
//            cell.descriptionViewHeight.constant = 0
//            
//            cell.paymentDoneView.isHidden = true
//            cell.paymentDoneViewHeight.constant = 0
//            
//            cell.acceptAndRejectButtonsView.isHidden = true
//            cell.acceptAndRejectButtonsViewHeight.constant = 0
//            
//        }else if item.liveAuctionStatus == "pending" {
//            print(indexPath.section)
//            cell.bigContainerViewHeight.constant = 130
//            cell.containerViewInsideBigViewHeight.constant = 110
//            
//            cell.afterAcceptedRejectedView.isHidden = true
//            cell.afterAcceptedRejectedViewHeight.constant = 0
//            
//            cell.descriptionView.isHidden = true
//            cell.descriptionViewHeight.constant = 0
//            
//            cell.paymentDoneView.isHidden = true
//            cell.paymentDoneViewHeight.constant = 0
//            
//            cell.acceptAndRejectButtonsView.isHidden = false
//            cell.acceptAndRejectButtonsViewHeight.constant = 110
//            
//        }
//        //        else {
//        //
//        //            cell.bigContainerViewHeight.constant = 0
//        //            cell.containerViewInsideBigViewHeight.constant = 0
//        //
//        //            cell.afterAcceptedRejectedView.isHidden = true
//        //            cell.afterAcceptedRejectedViewHeight.constant = 0
//        //
//        //            cell.descriptionView.isHidden = true
//        //            cell.descriptionViewHeight.constant = 0
//        //
//        //            cell.paymentDoneView.isHidden = true
//        //            cell.paymentDoneViewHeight.constant = 0
//        //
//        //            cell.acceptAndRejectButtonsView.isHidden = true
//        //            cell.acceptAndRejectButtonsViewHeight.constant = 0
//        //
//        //        }
//        
//        cell.PaymentDoneAction = {
//            
//            self.performUpdateStatusPayDone(status: "confirm_payment_and_delivery")
//            
//        }
//        
//        cell.AcceptAction = {
//            
//            self.performUpdateStatusAgree(status: "agree")
//            
//        }
//        
//        cell.RejectAction = {
//            
//            self.performUpdateStatusDisagree(status: "disagree")
//            
//        }
//        
//        return cell
//        
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        // first create the custom view
//        let myCustomView = UIView()
//        let headerView = UITableViewHeaderFooterView()
//        let contentView = headerView.contentView
//        let headerCell = cardsTableView.dequeueReusableCell(withIdentifier: "LiveCardsTableViewCell") as! LiveCardsTableViewCell
//        
//        contentView.addSubview(myCustomView)
//        myCustomView.addSubview(headerCell)
//        
//        let item = cards[section]
//        
//        if totalTime <= 0 {
//            
//            //            if item.selectorStatus == true {
//            //
//            //                headerCell.set()
//            //
//            //            }else {
//            //
//            //                headerCell.unSet()
//            //
//            //            }
//            
//            //            if cards[section].isExpanded && cards[section].selectorStatus ?? false {
//            //
//            //                headerCell.set()
//            //
//            //            }else {
//            //
//            //                headerCell.unSet()
//            //
//            //            }
//            
//            //            if item.selectorStatus == true {
//            //
//            //                headerCell.set()
//            //
//            //            }else {
//            //
//            //                if cards[section].isExpanded {
//            //
//            //                    headerCell.set()
//            //
//            //                }else {
//            //
//            //                    headerCell.unSet()
//            //
//            //                }
//            //
//            //            }
//            
//            if cards[section].isExpanded {
//                
//                headerCell.set()
//                
//            }else {
//                
//                headerCell.unSet()
//                
//            }
//            
//        }else {
//            
//            if item.selectorStatus == true {
//                
//                headerCell.set()
//                
//            }else {
//                
//                headerCell.unSet()
//                
//            }
//            
//        }
//        
//        //        if item.selectorStatus == true || cards[section].isExpanded {
//        //
//        //            headerCell.set()
//        //
//        //        }else {
//        //
//        //            headerCell.unSet()
//        //
//        //        }
//        
//        headerCell.expeadableButton.tag = section
//        
//        headerCell.productImage.loadImage(URLS.baseImageURL+(item.mainImage ?? ""))
//        headerCell.titleLabel.text = item.name
//        headerCell.priceLabel.text = item.bidMaxPrice
//        headerCell.currencyLabel.text = HelperConstant.getCurrency()
//        
//        myCustomView.translatesAutoresizingMaskIntoConstraints = false
//        headerCell.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            
//            myCustomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
//            myCustomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
//            myCustomView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            myCustomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            
//            headerCell.leadingAnchor.constraint(equalTo: myCustomView.leadingAnchor, constant: 0),
//            headerCell.trailingAnchor.constraint(equalTo: myCustomView.trailingAnchor, constant: 0),
//            headerCell.topAnchor.constraint(equalTo: myCustomView.topAnchor),
//            headerCell.bottomAnchor.constraint(equalTo: myCustomView.bottomAnchor)
//            
//        ])
//        
//        if cards[section].conductedBy == "me" && cards[section].conductor == nil {
//            
//            if cards[section].owner?.id == HelperConstant.getUserId() {
//                
//                headerCell.ExpandableAction = { tag in
//                    
//                    self.handleExpandClose(button: tag)
//                    
//                }
//                
//            }else {
//                
//                print("you cant make any action in this case")
//                
//            }
//            
//        }else if cards[section].conductedBy == "admin" && cards[section].conductor != nil {
//            
//            if cards[section].conductor?.id == HelperConstant.getUserId() {
//                
//                headerCell.ExpandableAction = { tag in
//                    
//                    self.handleExpandClose(button: tag)
//                    
//                }
//                
//            }else {
//                
//                print("you cant make any action in this case")
//                
//            }
//            
//        }
//        //        else {
//        //
//        //            print("conductor is empty")
//        //
//        //        }
//        
//        //        headerCell.ExpandableAction = { tag in
//        //
//        //            self.handleExpandClose(button: tag)
//        //
//        //        }
//        
//        return headerView
//    }
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 90
//    }
//    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return .leastNormalMagnitude
//    }
//    
//}
//
//extension NewLiveViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return AllRequsts.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        guard let cell = membersInLiveCollection.dequeueReusableCell(withReuseIdentifier: "LiveMembersCollectionViewCell", for: indexPath) as? LiveMembersCollectionViewCell else { return UICollectionViewCell()}
//        
//        let item = AllRequsts[indexPath.row]
//        
//        cell.memberImage.loadImage(URLS.baseImageURL+(item.image ?? ""))
//        
//        cell.muteUmMuteImage.image = UIImage(named: "Group 52705")
//        
//        if item.isSpeaker == true {
//            cell.muteUmMuteImage.image = UIImage(named: "Group 52704")
//        }else {
//            cell.muteUmMuteImage.image = UIImage(named: "Group 52705")
//        }
//        
//        return cell
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        let item = AllRequsts[indexPath.row]
//        
//        let storyborad = UIStoryboard(name: "HawyTabbar", bundle: nil)
//        let VC = storyborad.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
//        VC?.myProfile = false
//        VC?.ownerId = item.id
//        VC?.newName = item.name ?? ""
//        VC?.newPhone = item.mobile ?? ""
//        VC?.newImage = item.image ?? ""
//        VC?.newCode = item.code ?? ""
//        print(item.id)
//        present(VC!, animated: true, completion: nil)
//        
//        
//    }
//    
//}
//
//extension NewLiveViewController {
//    
//    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
//        let layout = UICollectionViewCompositionalLayout { [weak self] (index, environment) -> NSCollectionLayoutSection? in
//            
//            return self?.createSectionFor(index: index, environment: environment)
//            
//        }
//        return layout
//    }
//    
//    func createSectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
//        switch index {
//        case 0:
//            return createFourthSection()
//        default:
//            return createFourthSection()
//        }
//    }
//    
//    
//    func createFourthSection() -> NSCollectionLayoutSection {
//        
//        let inset: CGFloat = 5
//        
//        // item
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
//        
//        // group
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
//        
//        // section
//        let section = NSCollectionLayoutSection(group: group)
//        //section.orthogonalScrollingBehavior = .continuous
//        
//        // supplementary
//        let hearderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
//        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: hearderSize, elementKind: "header", alignment: .top)
//        //section.boundarySupplementaryItems = [header]
//        
//        return section
//        
//    }
//    
//}
//
//extension NewLiveViewController {
//    
//    private func listenToChangesFromPusherTime(auction_id: Int?, card_id: Int?) {
//        
//        print("auction_id: \(auction_id), card_id: \(card_id)")
//        // Instantiate Pusher
//        pusherTime = Pusher(
//            key: "65b581feebecaee4af62",
//            options: PusherClientOptions(host: .cluster("eu"))
//        )
//        
//        // Subscribe to a pusher channel
//        let channel = pusherTime.subscribe("auction.\(auction_id ?? 0).\(cardID ?? 0)")
//        
//        pusherTime.delegate = self
//        
//        pusherTime.connect()
//        
//        // Bind to an event called "order-event" on the event channel and fire
//        // the callback when the event is triggerred
//        
//        let eventNamee = #"App\Events\ApiDataListener"#
//        print("App\\Events\\ApiDataListener")
//        
//        print(eventNamee)
//        
//        let _ = channel.bind(eventName: "App\\Events\\UpdateTime" , eventCallback: { [weak self] (event: PusherEvent) -> Void in
//            
//            guard let self = self else { return }
//            
//            print(event)
//            
//            // convert the data string to type data for decoding
//            guard let json = event.data,
//                  let jsonData = json.data(using: .utf8)
//            else {
//                print("Could not convert JSON string to data")
//                return
//            }
//            
//            print(json)
//            print(jsonData)
//            
//            // decode the event data as json into a RealTimeModel
//            let decoded = try? self.decoder.decode(UpdateTime.self, from: jsonData)
//            guard let data = decoded else {
//                print("Could not decode message")
//                return
//            }
//            
//            self.finalTotal = data.end_date ?? 0
//            //self.startOtpTimer()
//            
//        })
//        
//    }
//    
//    private func listenToJoinVideoCall(auction_id: Int?, card_id: Int?) {
//        
//        print("auction_id: \(auction_id), card_id: \(card_id)")
//        // Instantiate Pusher
//        pusher = Pusher(
//            key: "65b581feebecaee4af62",
//            options: PusherClientOptions(host: .cluster("eu"))
//        )
//        
//        // Subscribe to a pusher channel
//        let channel = pusher.subscribe("auction.\(auction_id ?? 0).\(cardID ?? 0)") //.\(card_id ?? 0)
//        
//        pusher.delegate = self
//        
//        pusher.connect()
//        
//        // Bind to an event called "order-event" on the event channel and fire
//        // the callback when the event is triggerred
//        
//        
//        let _ = channel.bind(eventName: "join_auction_video_call" , eventCallback: { [weak self] (event: PusherEvent) -> Void in
//            
//            guard let self = self else { return }
//            
//            print(event)
//            
//            // convert the data string to type data for decoding
//            guard let json = event.data,
//                  let jsonData = json.data(using: .utf8)
//            else {
//                print("Could not convert JSON string to data")
//                return
//            }
//            
//            print(json)
//            print(jsonData)
//            
//            // decode the event data as json into a RealTimeModel
//            let decoded = try? self.decoder.decode(RealTimeLiveModel.self, from: jsonData)
//            guard let data = decoded else {
//                print("Could not decode message")
//                return
//            }
//            
//            //self.getJoindData(id: self.card_id, userId: HelperConstant.getUserId())
//            self.getParticipants(id: auction_id)
//            
//        })
//        
//    }
//    
//    private func listenToOutVideoCall(auction_id: Int?, card_id: Int?) {
//        
//        print("auction_id: \(auction_id), card_id: \(card_id)")
//        // Instantiate Pusher
//        pusher = Pusher(
//            key: "65b581feebecaee4af62",
//            options: PusherClientOptions(host: .cluster("eu"))
//        )
//        
//        // Subscribe to a pusher channel
//        let channel = pusher.subscribe("auction.\(auction_id ?? 0).\(cardID ?? 0)") //.\(card_id ?? 0)
//        
//        pusher.delegate = self
//        
//        pusher.connect()
//        
//        // Bind to an event called "order-event" on the event channel and fire
//        // the callback when the event is triggerred
//        
//        
//        let _ = channel.bind(eventName: "out_auction_video_call" , eventCallback: { [weak self] (event: PusherEvent) -> Void in
//            
//            guard let self = self else { return }
//            
//            print(event)
//            
//            // convert the data string to type data for decoding
//            guard let json = event.data,
//                  let jsonData = json.data(using: .utf8)
//            else {
//                print("Could not convert JSON string to data")
//                return
//            }
//            
//            print(json)
//            print(jsonData)
//            
//            // decode the event data as json into a RealTimeModel
//            let decoded = try? self.decoder.decode(RealTimeLiveModel.self, from: jsonData)
//            guard let data = decoded else {
//                print("Could not decode message")
//                return
//            }
//            //self.getJoindData(id: self.card_id, userId: HelperConstant.getUserId())
//            self.getParticipants(id: auction_id)
//            
//        })
//        
//    }
//    
//    private func listenToMicCall(auction_id: Int?, card_id: Int?) {
//        
//        print("auction_id: \(auction_id), card_id: \(card_id)")
//        // Instantiate Pusher
//        pusher4 = Pusher(
//            key: "65b581feebecaee4af62",
//            options: PusherClientOptions(host: .cluster("eu"))
//        )
//        
//        // Subscribe to a pusher channel
//        let channel = pusher4.subscribe("auction.\(auction_id ?? 0).\(cardID ?? 0)") //
//        
//        pusher4.delegate = self
//        
//        pusher4.connect()
//        
//        // Bind to an event called "order-event" on the event channel and fire
//        // the callback when the event is triggerred
//        
//        
//        let _ = channel.bind(eventName: "microphone" , eventCallback: { [weak self] (event: PusherEvent) -> Void in
//            
//            guard let self = self else { return }
//            
//            print(event)
//            
//            // convert the data string to type data for decoding
//            guard let json = event.data,
//                  let jsonData = json.data(using: .utf8)
//            else {
//                print("Could not convert JSON string to data")
//                return
//            }
//            
//            print(json)
//            print(jsonData)
//            
//            // decode the event data as json into a RealTimeModel
//            let decoded = try? self.decoder.decode(RealTimeLiveModel.self, from: jsonData)
//            guard let data = decoded else {
//                print("Could not decode message")
//                return
//            }
//            
//            //if data.id == HelperConstant.getUserId() {
//            
//            //                if data.isSpeaker == true {
//            //                    self.agoraKit.muteLocalAudioStream(false)
//            //                    self.micMuteButton.setImage(UIImage(named: "muteButtonSelected"), for: .normal)
//            //                }else {
//            //                    self.agoraKit.muteLocalAudioStream(true)
//            //                    self.micMuteButton.setImage(UIImage(named: "muteButton"), for: .normal)
//            //                }
//            
//            //}
//            
//            //self.getJoindData(id: self.card_id, userId: HelperConstant.getUserId())
//            self.getParticipants(id: auction_id)
//            
//        })
//        
//    }
//    
//    private func listenToAdminRaiseHandCall(auction_id: Int?, card_id: Int?) {
//        
//        print("auction_id: \(auction_id ?? 0), card_id: \(card_id)")
//        // Instantiate Pusher
//        pusher6 = Pusher(
//            key: "65b581feebecaee4af62",
//            options: PusherClientOptions(host: .cluster("eu"))
//        )
//        
//        // Subscribe to a pusher channel
//        let channel = pusher6.subscribe("auction.\(auction_id ?? 0).\(cardID ?? 0)") //.\(card_id ?? 0)
//        
//        pusher6.delegate = self
//        
//        pusher6.connect()
//        
//        // Bind to an event called "order-event" on the event channel and fire
//        // the callback when the event is triggerred
//        
//        
//        let _ = channel.bind(eventName: "admin_raise_hand_response" , eventCallback: { [weak self] (event: PusherEvent) -> Void in
//            
//            guard let self = self else { return }
//            
//            print(event)
//            
//            // convert the data string to type data for decoding
//            guard let json = event.data,
//                  let jsonData = json.data(using: .utf8)
//            else {
//                print("Could not convert JSON string to data")
//                return
//            }
//            
//            print(json)
//            print(jsonData)
//            
//            // decode the event data as json into a RealTimeModel
//            let decoded = try? self.decoder.decode(RealTimeLiveModel.self, from: jsonData)
//            guard let data = decoded else {
//                print("Could not decode message")
//                return
//            }
//            
//            //self.isused = true
//            //
//            //if data.id == HelperConstant.getUserId() {
//            //
//            //    if data.raiseHand == true {
//            //
//            //        //self.agoraKit.muteLocalAudioStream(false)
//            //        self.micMuteButton.isHidden = false
//            //
//            //    }else {
//            //
//            //        //self.agoraKit.muteLocalAudioStream(true)
//            //        self.micMuteButton.isHidden = true
//            //
//            //    }
//            //
//            //}
//            //
//            
//            self.getParticipants(id: auction_id)
//            
//        })
//        
//    }
//    
//    private func listenToAdminVideoStatusCall(auction_id: Int?, card_id: Int?) {
//        
//        print("auction_id: \(auction_id), card_id: \(card_id)")
//        // Instantiate Pusher
//        pusher7 = Pusher(
//            key: "65b581feebecaee4af62",
//            options: PusherClientOptions(host: .cluster("eu"))
//        )
//        
//        // Subscribe to a pusher channel
//        let channel = pusher7.subscribe("auction.\(auction_id ?? 0).\(cardID ?? 0)") //.\(card_id ?? 0)
//        
//        pusher7.delegate = self
//        
//        pusher7.connect()
//        
//        // Bind to an event called "order-event" on the event channel and fire
//        // the callback when the event is triggerred
//        
//        
//        let _ = channel.bind(eventName: "videoStatus" , eventCallback: { [weak self] (event: PusherEvent) -> Void in
//            
//            guard let self = self else { return }
//            
//            print(event)
//            
//            // convert the data string to type data for decoding
//            guard let json = event.data,
//                  let jsonData = json.data(using: .utf8)
//            else {
//                print("Could not convert JSON string to data")
//                return
//            }
//            
//            print(json)
//            print(jsonData)
//            
//            // decode the event data as json into a RealTimeModel
//            let decoded = try? self.decoder.decode(RealTimeLiveModel.self, from: jsonData)
//            guard let data = decoded else {
//                print("Could not decode message")
//                return
//            }
//            
//            //self.isused = true
//            //
////            if data.video_status == true {
////                self.videoMuteButton.setImage(UIImage(named: "videoMuteButton"), for: .normal)
////                self.agoraKit.muteLocalVideoStream(false)
////                //localVideo.isHidden = true
////                self.localVideoMutedBg.isHidden = false
////                self.remoteVideoMutedIndicator.isHidden = false
////            }else {
////                self.videoMuteButton.setImage(UIImage(named: "videoMuteButtonSelected"), for: .selected)
////                self.agoraKit.muteLocalVideoStream(true)
////                //localVideo.isHidden = false
////
////                self.localVideoMutedBg.isHidden = true
////                self.remoteVideoMutedIndicator.isHidden = true
////            }
//            
//            
//        })
//        
//    }
//    
//    private func listenToRaiseHandCall(auction_id: Int?, card_id: Int?) {
//        
//        print("auction_id: \(auction_id), card_id: \(card_id)")
//        // Instantiate Pusher
//        pusher3 = Pusher(
//            key: "65b581feebecaee4af62",
//            options: PusherClientOptions(host: .cluster("eu"))
//        )
//        
//        // Subscribe to a pusher channel
//        let channel = pusher3.subscribe("auction.\(auction_id ?? 0).\(cardID ?? 0)") //.\(card_id ?? 0)
//        
//        pusher3.delegate = self
//        
//        pusher3.connect()
//        
//        // Bind to an event called "order-event" on the event channel and fire
//        // the callback when the event is triggerred
//        
//        
//        let _ = channel.bind(eventName: "raise_Hand" , eventCallback: { [weak self] (event: PusherEvent) -> Void in
//            
//            guard let self = self else { return }
//            
//            print(event)
//            
//            // convert the data string to type data for decoding
//            guard let json = event.data,
//                  let jsonData = json.data(using: .utf8)
//            else {
//                print("Could not convert JSON string to data")
//                return
//            }
//            
//            print(json)
//            print(jsonData)
//            
//            // decode the event data as json into a RealTimeModel
//            let decoded = try? self.decoder.decode(RealTimeLiveModel.self, from: jsonData)
//            guard let data = decoded else {
//                print("Could not decode message")
//                return
//            }
//            
//            //self.isused = true
//            //
//            
//            //self.acceptRejectRaiseHandView.isHidden = false
//            //self.acceptRaiseHandViewHeight.constant = 100
//            //
//            self.requestedUserImage.loadImage(URLS.baseImageURL+(data.image ?? ""))
//            self.requestedUserNameLable.text = data.name ?? ""
//            
//            //self.getJoindData(id: self.card_id, userId: HelperConstant.getUserId())
//            
//            self.acceptRejectId = data.id
//            self.acceptRjectRaiseHandViewHeight.constant = 100
//            self.acceptRjectRaiseHandView.isHidden = false
//            
//            self.getParticipants(id: auction_id)
//            
//        })
//        
//    }
//    
//    private func listenToChangesFromPusherUSD(auction_id: Int?, card_id: Int?) {
//        
//        print("auction_id: \(auction_id), card_id: \(card_id)")
//        // Instantiate Pusher
//        bidPusher = Pusher(
//            key: "65b581feebecaee4af62",
//            options: PusherClientOptions(host: .cluster("eu"))
//        )
//        
//        // Subscribe to a pusher channel
//        let channel = bidPusher.subscribe("auction.\(auction_id ?? 0).\(cardID ?? 0)")
//        
//        bidPusher.delegate = self
//        
//        bidPusher.connect()
//        
//        // Bind to an event called "order-event" on the event channel and fire
//        // the callback when the event is triggerred
//        
//        let eventNamee = #"App\Events\ApiDataListener"#
//        print("App\\Events\\ApiDataListener")
//        
//        print(eventNamee)
//        
//        let _ = channel.bind(eventName: "usd_bid" , eventCallback: { [weak self] (event: PusherEvent) -> Void in
//            
//            guard let self = self else { return }
//            
//            print(event)
//            
//            // convert the data string to type data for decoding
//            guard let json = event.data,
//                  let jsonData = json.data(using: .utf8)
//            else {
//                print("Could not convert JSON string to data")
//                return
//            }
//            
//            print(json)
//            print(jsonData)
//            
//            // decode the event data as json into a RealTimeModel
//            let decoded = try? self.decoder.decode(RealTimeModel.self, from: jsonData)
//            guard let data = decoded else {
//                print("Could not decode message")
//                return
//            }
//            
//            self.getCardUpdate(id: self.auction_id)
//            self.view.layoutIfNeeded()
//            self.cardsTableViewHeight.constant = self.cardsTableView.contentSize.height
//            self.view.layoutIfNeeded()
//            
//            print("\(data.data) says \(data.data)")
//            
//        })
//        
//    }
//    private func listenToChangesFromPusher(auction_id: Int?, card_id: Int?) {
//        
//        print("auction_id: \(auction_id), card_id: \(card_id)")
//        // Instantiate Pusher
//        bidPusher = Pusher(
//            key: "65b581feebecaee4af62",
//            options: PusherClientOptions(host: .cluster("eu"))
//        )
//        
//        // Subscribe to a pusher channel
//        let channel = bidPusher.subscribe("auction.\(auction_id ?? 0).\(cardID ?? 0)")
//        
//        bidPusher.delegate = self
//        
//        bidPusher.connect()
//        
//        // Bind to an event called "order-event" on the event channel and fire
//        // the callback when the event is triggerred
//        
//        let eventNamee = #"App\Events\ApiDataListener"#
//        print("App\\Events\\ApiDataListener")
//        
//        print(eventNamee)
//        
//        let _ = channel.bind(eventName: "kwd_bid" , eventCallback: { [weak self] (event: PusherEvent) -> Void in
//            
//            guard let self = self else { return }
//            
//            print(event)
//            
//            // convert the data string to type data for decoding
//            guard let json = event.data,
//                  let jsonData = json.data(using: .utf8)
//            else {
//                print("Could not convert JSON string to data")
//                return
//            }
//            
//            print(json)
//            print(jsonData)
//            
//            // decode the event data as json into a RealTimeModel
//            let decoded = try? self.decoder.decode(RealTimeModel.self, from: jsonData)
//            guard let data = decoded else {
//                print("Could not decode message")
//                return
//            }
//            
//            self.getCardUpdate(id: self.auction_id)
//            self.view.layoutIfNeeded()
//            self.cardsTableViewHeight.constant = self.cardsTableView.contentSize.height
//            self.view.layoutIfNeeded()
//            
//            print("\(data.data) says \(data.data)")
//            
//        })
//        
//    }
//    
//    private func listenToCardStatusFromPusher(auction_id: Int?) {
//        
//        print("auction_id: \(auction_id)")
//        // Instantiate Pusher
//        pusherCards = Pusher(
//            key: "65b581feebecaee4af62",
//            options: PusherClientOptions(host: .cluster("eu"))
//        )
//        
//        // Subscribe to a pusher channel
//        let channel = pusherCards.subscribe("auction.\(auction_id ?? 0)")
//        
//        pusherCards.delegate = self
//        
//        pusherCards.connect()
//        
//        // Bind to an event called "order-event" on the event channel and fire
//        // the callback when the event is triggerred
//        
//        let _ = channel.bind(eventName: "live_cards_status" , eventCallback: { [weak self] (event: PusherEvent) -> Void in
//            
//            guard let self = self else { return }
//            
//            print(event)
//            
//            // convert the data string to type data for decoding
//            guard let json = event.data,
//                  let jsonData = json.data(using: .utf8)
//            else {
//                print("Could not convert JSON string to data")
//                return
//            }
//            
//            print(json)
//            print(jsonData)
//            
//            // decode the event data as json into a RealTimeModel
//            let decoded = try? self.decoder.decode(AddSaleAuctionDataModel.self, from: jsonData)
//            guard let data = decoded else {
//                print("Could not decode message")
//                return
//            }
//            
//            for card in data.data?.cards ?? [] {
//                
//                if card.selectorStatus == true {
//                    self.cardID = card.id
//                    self.firstTimeCardSelect = true
//                    print(self.cardID, self.cardID)
//                    
//                    self.noteTV.text = card.notes ?? ""
//                    self.animalName.text =  card.name ?? ""
//                    self.fatherName.text =  card.fatherName ?? ""
//                    self.motherName.text =  card.motherName ?? ""
//                    
//                    self.bidMaxPrice = card.bidMaxPrice
//                    
//                }
//                
//            }
//            
//            if data.data?.bidCounter == 0 {
//                
//                for card in data.data?.cards ?? [] {
//                    
//                    if card.selectorStatus == true {
//                        
//                        self.priceLabel.text = "\(card.offer?.price ?? "0.0")"
//                        print(card.offer?.price ?? "0.0")
//                        
//                        self.ownerUserImage.isHidden = true
//                        self.ownerNameLabel.text = "Initial price".localized
//                        
//                        self.bidMaxPrice = card.bidMaxPrice
//                        
//                    }
//                    
//                }
//                
//            }else {
//                
//                for card in data.data?.cards ?? [] {
//                    
//                    if card.selectorStatus == true {
//                        
//                        self.priceLabel.text = "\(card.offer?.price ?? "0.0")"
//                        print(card.offer?.price ?? "0.0")
//                        
//                        self.ownerUserImage.isHidden = false
//                        self.ownerUserImage.loadImage(URLS.baseImageURL+(card.offer?.user?.image ?? ""))
//                        self.ownerNameLabel.text = card.offer?.user?.name ?? ""
//                        
//                        self.bidMaxPrice = card.bidMaxPrice
//                        
//                    }
//                    
//                }
//                
//            }
//            
//            self.listenToCardStatusFromPusher(auction_id: self.auction_id)
//            
//            self.raiseHandRequests(auction_id: self.auction_id, card_id: self.cardID)
//            
//            self.listenToChangesFromPusherTime(auction_id: self.auction_id, card_id: self.cardID)
//            
//            if HelperConstant.getCurrency() == "USD" {
//                print(self.cardID)
//                self.listenToChangesFromPusherUSD(auction_id: self.auction_id, card_id: self.cardID)
//            }else {
//                print(self.cardID)
//                self.listenToChangesFromPusher(auction_id: self.auction_id, card_id: self.cardID)
//            }
//            
//            self.listenToOutVideoCall(auction_id: self.auction_id, card_id: self.cardID)
//            
//            self.listenToMicCall(auction_id: self.auction_id, card_id: self.cardID)
//            
//            //            self.cards = data.item?.cards ?? []
//            //            self.cardsTableView.reloadData()
//            self.getCardUpdate(id: self.auction_id)
//            self.view.layoutIfNeeded()
//            self.cardsTableViewHeight.constant = self.cardsTableView.contentSize.height
//            self.view.layoutIfNeeded()
//            
//            self.getParticipants(id: auction_id)
//            
//            
//        })
//        
//    }
//    
//}
//
//extension NewLiveViewController {
//    
//    //MARK:- SetUp startOtpTimer
//    public func startOtpTimer() {
//        
//        self.totalTime = finalTotal
//        
//        self.timer2 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
//    }
//    //MARK:- SetUp updateTimer
//    @objc func updateTimer() {
//        
//        //        print(self.totalTime)
//        //        print(self.timeFormatted(self.totalTime))
//        
//        if self.totalTime <= 0 {
//            self.timerLabel.text = "00 : 00 : 00"
//            self.timerLabel.textColor = DesignSystem.Colors.PrimaryDarkRed.color
//            self.clockImage.image = UIImage(named: "asset-2")
//            self.timer2?.invalidate()
//            self.plusButtonOutlet.isEnabled = false
//            self.minusButtonOutlet.isEnabled = false
//            self.addBidButton.isEnabled = false
//            self.sendRaiseHandButton.isEnabled = false
//            
//            self.controlButtons.isHidden = true
//            self.localVideoMutedBg.isHidden = false
//            self.remoteVideoMutedIndicator.isHidden = false
//            
//        }else if self.totalTime <= 2700 {
//            
//            self.timerLabel.labelFlash()
//            
//            self.timerLabel.text = self.timeFormatted(self.totalTime)
//            self.timerLabel.textColor = DesignSystem.Colors.PrimaryDarkRed.color
//            self.clockImage.image = UIImage(named: "asset-2")
//            totalTime -= 1
//            
//        }else {
//            
//            self.timerLabel.text = self.timeFormatted(self.totalTime) // will show timer
//            self.timerLabel.textColor = DesignSystem.Colors.PrimaryBlack.color
//            self.clockImage.image = UIImage(systemName: "clock.fill")
//            
//            totalTime -= 1
//        }
//        
//    }
//    //MARK:- SetUp timeFormatted
//    func timeFormatted(_ totalSeconds: Int) -> String {
//        
//        let seconds: Int = totalSeconds % 60
//        let minutes: Int = (totalSeconds / 60) % 60
//        let hour: Int = totalSeconds / 3600
//        
//        return hour > 0 ? String(format: "%02d:%02d:%02d", hour, minutes, seconds) : String(format: "%02d:%02d", minutes, seconds)
//        
//    }
//    
//}
//
//extension NewLiveViewController {
//    
//    func getLiveAuctionData(id: Int?) { //url: String, parameters: [String:Any]
//        
//        let url = "https://hawy-kw.com/api/auctions/sales/show?auction_id=\(id ?? 0)&user_id=\(HelperConstant.getUserId() ?? 0)"
//        
//        let headers: HTTPHeaders = [
//            "Content-Type":"application/json",
//            "Accept":"application/json",
//            "Accept-Language":AppLocalization.currentAppleLanguage(),
//            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
//            "offset": "\(HelperConstant.getOffst() ?? 0)"
//        ]
//        
//        showIndecator()
//        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers) // //URLEncoding.httpBody
//            .validate(statusCode: 200...500)
//        
//            .responseJSON { response in
//                
//                print(headers)
//                print(response)
//                print(response.result)
//                
//                switch response.result {
//                    
//                case .success(let JSON):
//                    
//                    print("Validation Successful with response JSON \(JSON)")
//                    
//                    guard let data = response.data else { return }
//                    
//                    do {
//                        
//                        let decoder = JSONDecoder()
//                        let liveAuctionRequest = try decoder.decode(NewLiveAuctionModel.self, from: data)
//                        print(liveAuctionRequest)
//                        
//                        if liveAuctionRequest.message == "Unauthenticated." {
//                            
//                            let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
//                            let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
//                                
//                                
//                                let story = UIStoryboard(name: "Authentication", bundle:nil)
//                                let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                                UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
//                                UIApplication.shared.windows.first?.makeKeyAndVisible()
//                                
//                            }
//                            
//                            alert.addAction(okAction)
//                            
//                            self.present(alert, animated: true, completion: nil)
//                            
//                        }
//                        
//                        if liveAuctionRequest.code == 200 {
//                            
//                            self.auctionID = liveAuctionRequest.item?.id
//                            
//                            self.time = (liveAuctionRequest.item?.endDate ?? 0)// * 1000
//                            self.currentTime = Int(Date.currentTimeStamp)
//                            
//                            let finalTimeStamp = (self.time ?? 0) - (self.currentTime ?? 0)
//                            self.finalTotal = finalTimeStamp
//                            
//                            for card in liveAuctionRequest.item?.cards ?? [] {
//                                
//                                if card.selectorStatus == true {
//                                    self.cardID = card.id
//                                    self.firstTimeCardSelect = true
//                                    print(self.cardID)
//                                    
//                                    self.noteTV.text = card.notes ?? ""
//                                    self.animalName.text =  card.name ?? ""
//                                    self.fatherName.text =  card.fatherName ?? ""
//                                    self.motherName.text =  card.motherName ?? ""
//                                    
//                                    self.bidMaxPrice = card.bidMaxPrice
//                                    
//                                    if card.owner?.id == HelperConstant.getUserId() || card.conductor?.id == HelperConstant.getUserId() { // || liveAuctionRequest.item?.conductor?.id == HelperConstant.getUserId()
//                                        
//                                        self.listenToRaiseHandCall(auction_id: self.auction_id, card_id: self.cardID)
//                                        
//                                        self.videoMuteButton.isHidden = false
//                                        self.switchCameraButton.isHidden = false
//                                        
//                                        self.acceptRjectRaiseHandViewHeight.constant = 0
//                                        self.acceptRjectRaiseHandView.isHidden = true
//                                        
//                                        self.descriptionOfWinAndLoseViewHeight.constant = 0
//                                        self.descriptionOfWinAndLoseView.isHidden = true
//                                        
//                                        self.plusMinusViewHeight.constant = 0
//                                        self.plusMinusView.isHidden = true
//                                        
//                                        self.addBidViewHeight.constant = 0
//                                        self.addBidView.isHidden = true
//                                        
//                                        self.sendRaiseHandViewHeight.constant = 0
//                                        self.sendRaiseHandView.isHidden = true
//                                        
//                                        self.cardsTitleView.isHidden = false
//                                        self.containerViewOfCardsTableView.isHidden = true
//                                        self.cardsTableView.isHidden = true
//                                        
//                                        self.cardDetailsViewHeight.constant = 0
//                                        self.cardDetailsView.isHidden = true
//                                        
//                                    }else{
//                                        
//                                        self.listenToAdminRaiseHandCall(auction_id: self.auction_id, card_id: self.cardID)
//                                        self.listenToAdminVideoStatusCall(auction_id: self.auction_id, card_id: self.cardID)
//                                        
//                                        self.videoMuteButton.isHidden = true
//                                        self.switchCameraButton.isHidden = true
//                                        
//                                        self.acceptRjectRaiseHandViewHeight.constant = 0
//                                        self.acceptRjectRaiseHandView.isHidden = true
//                                        
//                                        self.descriptionOfWinAndLoseViewHeight.constant = 80
//                                        self.descriptionOfWinAndLoseView.isHidden = false
//                                        
//                                        self.plusMinusViewHeight.constant = 160
//                                        self.plusMinusView.isHidden = false
//                                        
//                                        self.addBidViewHeight.constant = 70
//                                        self.addBidView.isHidden = false
//                                        
//                                        self.sendRaiseHandViewHeight.constant = 90
//                                        self.sendRaiseHandView.isHidden = false
//                                        
//                                        self.cardsTitleView.isHidden = true
//                                        self.containerViewOfCardsTableView.isHidden = true
//                                        self.cardsTableView.isHidden = true
//                                        
//                                        self.cardDetailsViewHeight.constant = 160
//                                        self.cardDetailsView.isHidden = false
//                                        
//                                    }
//                                    
//                                }
//                                
//                            }
//                            
//                            self.cardItem = liveAuctionRequest.item
//                            self.cards = liveAuctionRequest.item?.cards ?? []
//                            self.cardsTableView.reloadData()
//                            
//                            self.JoinUserAuctionVideo()
//                            self.getParticipants(id: id)
//                            
//                            self.listenToCardStatusFromPusher(auction_id: self.auction_id)
//                            
//                            self.raiseHandRequests(auction_id: self.auction_id, card_id: self.cardID)
//                            
//                            self.listenToChangesFromPusherTime(auction_id: self.auction_id, card_id: self.cardID)
//                            
//                            if HelperConstant.getCurrency() == "USD" {
//                                self.listenToChangesFromPusherUSD(auction_id: self.auction_id, card_id: self.cardID)
//                            }else {
//                                self.listenToChangesFromPusher(auction_id: self.auction_id, card_id: self.cardID)
//                            }
//                            
//                            self.listenToOutVideoCall(auction_id: self.auction_id, card_id: self.cardID)
//                            
//                            self.listenToMicCall(auction_id: self.auction_id, card_id: self.cardID)
//                            
//                            if self.time ?? 0 <= self.currentTime ?? 0 {
//                                
//                                self.localVideoMutedBg.isHidden = false
//                                self.remoteVideoMutedIndicator.isHidden = false
//                                self.controlButtons.isHidden = true
//                                
//                                for card in liveAuctionRequest.item?.cards ?? [] {
//                                    
//                                    if card.selectorStatus == true {
//                                        
//                                        
//                                        
//                                    }
//                                    
//                                }
//                                
//                            }else {
//                                
//                                
//                                
//                            }
//                            
//                            self.startOtpTimer()
//                            self.timerLabel.textColor = DesignSystem.Colors.PrimaryBlack.color
//                            self.clockImage.image = UIImage(systemName: "clock.fill")
//                            
//                            //self.bidLabel.text = "\(liveAuctionRequest.item?.minimumBiding ?? 0)"
//                            
//                            if liveAuctionRequest.item?.bidCounter == 0 {
//                                
//                                for card in liveAuctionRequest.item?.cards ?? [] {
//                                    
//                                    if card.selectorStatus == true {
//                                        
//                                        self.priceLabel.text = "\(card.offer?.price ?? "0.0")"
//                                        print(card.offer?.price ?? "0.0")
//                                        
//                                        self.ownerUserImage.isHidden = true
//                                        self.ownerNameLabel.text = "initial price"
//                                        
//                                        self.bidMaxPrice = card.bidMaxPrice
//                                        
//                                    }
//                                    
//                                }
//                                
//                            }else {
//                                
//                                for card in liveAuctionRequest.item?.cards ?? [] {
//                                    
//                                    if card.selectorStatus == true {
//                                        
//                                        self.priceLabel.text = "\(card.offer?.price ?? "0.0")"
//                                        print(card.offer?.price ?? "0.0")
//                                        
//                                        self.ownerUserImage.isHidden = false
//                                        self.ownerUserImage.loadImage(URLS.baseImageURL+(card.offer?.user?.image ?? ""))
//                                        self.ownerNameLabel.text = card.offer?.user?.name ?? ""
//                                        
//                                        self.bidMaxPrice = card.bidMaxPrice
//                                        
//                                    }
//                                    
//                                }
//                                
//                            }
//                            
//                            //                            if liveAuctionRequest.item?.owner?.id == HelperConstant.getUserId() { // || liveAuctionRequest.item?.conductor?.id == HelperConstant.getUserId()
//                            //
//                            //                                self.listenToRaiseHandCall(auction_id: self.auction_id, card_id: self.cardID)
//                            //
//                            //                                self.videoMuteButton.isHidden = false
//                            //                                self.switchCameraButton.isHidden = false
//                            //
//                            //                                self.acceptRjectRaiseHandViewHeight.constant = 0
//                            //                                self.acceptRjectRaiseHandView.isHidden = true
//                            //
//                            //                                self.descriptionOfWinAndLoseViewHeight.constant = 0
//                            //                                self.descriptionOfWinAndLoseView.isHidden = true
//                            //
//                            //                                self.plusMinusViewHeight.constant = 0
//                            //                                self.plusMinusView.isHidden = true
//                            //
//                            //                                self.addBidViewHeight.constant = 0
//                            //                                self.addBidView.isHidden = true
//                            //
//                            //                                self.sendRaiseHandViewHeight.constant = 0
//                            //                                self.sendRaiseHandView.isHidden = true
//                            //
//                            //                                self.cardsTitleView.isHidden = false
//                            //                                self.containerViewOfCardsTableView.isHidden = true
//                            //                                self.cardsTableView.isHidden = true
//                            //
//                            //                                self.cardDetailsViewHeight.constant = 0
//                            //                                self.cardDetailsView.isHidden = true
//                            //
//                            //                            }else{
//                            //
//                            //                                self.listenToAdminRaiseHandCall(auction_id: self.auction_id, card_id: self.cardID)
//                            //                                self.listenToAdminVideoStatusCall(auction_id: self.auction_id, card_id: self.cardID)
//                            //
//                            //                                self.videoMuteButton.isHidden = true
//                            //                                self.switchCameraButton.isHidden = true
//                            //
//                            //                                self.acceptRjectRaiseHandViewHeight.constant = 0
//                            //                                self.acceptRjectRaiseHandView.isHidden = true
//                            //
//                            //                                self.descriptionOfWinAndLoseViewHeight.constant = 80
//                            //                                self.descriptionOfWinAndLoseView.isHidden = false
//                            //
//                            //                                self.plusMinusViewHeight.constant = 160
//                            //                                self.plusMinusView.isHidden = false
//                            //
//                            //                                self.addBidViewHeight.constant = 70
//                            //                                self.addBidView.isHidden = false
//                            //
//                            //                                self.sendRaiseHandViewHeight.constant = 90
//                            //                                self.sendRaiseHandView.isHidden = false
//                            //
//                            //                                self.cardsTitleView.isHidden = true
//                            //                                self.containerViewOfCardsTableView.isHidden = true
//                            //                                self.cardsTableView.isHidden = true
//                            //
//                            //                                self.cardDetailsViewHeight.constant = 160
//                            //                                self.cardDetailsView.isHidden = false
//                            //
//                            //                            }
//                            
//                        }
//                        
//                        self.hideIndecator()
//                    } catch let error {
//                        self.hideIndecator()
//                        print(error)
//                        
//                    }
//                    
//                case .failure(let error):
//                    
//                    print("Request failed with error \(error)")
//                    
//                }
//                
//            }
//        
//    }
//    
//    func getParticipants(id: Int?) {
//        
//        let url = "https://hawy-kw.com/api/auctions/sales/show?id=\(id ?? 0)&user_id=\(HelperConstant.getUserId() ?? 0)"
//        
//        let headers: HTTPHeaders = [
//            "Content-Type":"application/json",
//            "Accept":"application/json",
//            "Accept-Language":AppLocalization.currentAppleLanguage(),
//            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
//            "offset": "\(HelperConstant.getOffst() ?? 0)"
//        ]
//        
//        //showIndecator()
//        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers) // //URLEncoding.httpBody
//            .validate(statusCode: 200...500)
//        
//            .responseJSON { response in
//                
//                print(headers)
//                print(response)
//                print(response.result)
//                
//                switch response.result {
//                    
//                case .success(let JSON):
//                    
//                    print("Validation Successful with response JSON \(JSON)")
//                    
//                    guard let data = response.data else { return }
//                    
//                    do {
//                        
//                        let decoder = JSONDecoder()
//                        let liveAuctionRequest = try decoder.decode(NewLiveAuctionModel.self, from: data)
//                        print(liveAuctionRequest)
//                        
//                        if liveAuctionRequest.message == "Unauthenticated." {
//                            
//                            let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
//                            let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
//                                
//                                
//                                let story = UIStoryboard(name: "Authentication", bundle:nil)
//                                let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                                UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
//                                UIApplication.shared.windows.first?.makeKeyAndVisible()
//                                
//                            }
//                            
//                            alert.addAction(okAction)
//                            
//                            self.present(alert, animated: true, completion: nil)
//                            
//                        }
//                        
//                        if liveAuctionRequest.code == 200 {
//                            
//                            for card in liveAuctionRequest.item?.cards ?? [] {
//                                
//                                if card.selectorStatus == true {
//                                    self.AllRequsts = card.joinedUsers ?? []
//                                    self.membersCountLabel.text = "\(self.AllRequsts.count)"
//                                    self.membersInLiveCollection.reloadData()
//                                }
//                                
//                            }
//                            
//                        }
//                        
//                        //self.hideIndecator()
//                    } catch let error {
//                        //self.hideIndecator()
//                        print(error)
//                        
//                    }
//                    
//                case .failure(let error):
//                    
//                    print("Request failed with error \(error)")
//                    
//                }
//                
//            }
//        
//    }
//    
//    func getCardUpdate(id: Int?) {
//        
//        let url = "https://hawy-kw.com/api/auctions/sales/show?id=\(id ?? 0)&user_id=\(HelperConstant.getUserId() ?? 0)"
//        
//        let headers: HTTPHeaders = [
//            "Content-Type":"application/json",
//            "Accept":"application/json",
//            "Accept-Language":AppLocalization.currentAppleLanguage(),
//            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
//            "offset": "\(HelperConstant.getOffst() ?? 0)"
//        ]
//        
//        //showIndecator()
//        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers) // //URLEncoding.httpBody
//            .validate(statusCode: 200...500)
//        
//            .responseJSON { response in
//                
//                print(headers)
//                print(response)
//                print(response.result)
//                
//                switch response.result {
//                    
//                case .success(let JSON):
//                    
//                    print("Validation Successful with response JSON \(JSON)")
//                    
//                    guard let data = response.data else { return }
//                    
//                    do {
//                        
//                        let decoder = JSONDecoder()
//                        let liveAuctionRequest = try decoder.decode(NewLiveAuctionModel.self, from: data)
//                        print(liveAuctionRequest)
//                        
//                        if liveAuctionRequest.message == "Unauthenticated." {
//                            
//                            let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
//                            let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
//                                
//                                
//                                let story = UIStoryboard(name: "Authentication", bundle:nil)
//                                let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                                UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
//                                UIApplication.shared.windows.first?.makeKeyAndVisible()
//                                
//                            }
//                            
//                            alert.addAction(okAction)
//                            
//                            self.present(alert, animated: true, completion: nil)
//                            
//                        }
//                        
//                        if liveAuctionRequest.code == 200 {
//                            
//                            //                            for cardSelected in liveAuctionRequest.item?.cards ?? [] {
//                            //
//                            //                                self.cardID = cardSelected.id
//                            //                                print(self.cardID)
//                            //
//                            //                            }
//                            
//                            self.cards = liveAuctionRequest.item?.cards ?? []
//                            self.cardsTableView.reloadData()
//                            
//                        }
//                        
//                        //self.hideIndecator()
//                    } catch let error {
//                        //self.hideIndecator()
//                        print(error)
//                        
//                    }
//                    
//                case .failure(let error):
//                    
//                    print("Request failed with error \(error)")
//                    
//                }
//                
//            }
//        
//    }
//    
//    func liveCardStatus() { //url: String, parameters: [String:Any]
//        
//        let url = "https://hawy-kw.com/api/auctions/live/videoCall/cards/status"
//        
//        let param: [String: Any] = [
//            
//            "card_id" : cardID ?? 0,
//            "auction_id": auction_id ?? 0,
//            "user_id": HelperConstant.getUserId() ?? 0
//            
//        ]
//        
//        print(param)
//        
//        let headers: HTTPHeaders = [
//            "Content-Type":"application/json",
//            "Accept":"application/json",
//            "Accept-Language":AppLocalization.currentAppleLanguage(),
//            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
//            "offset": "\(HelperConstant.getOffst() ?? 0)"
//        ]
//        
//        //showIndecator()
//        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers) // //URLEncoding.httpBody
//            .validate(statusCode: 200...500)
//        
//            .responseJSON { response in
//                
//                print(param)
//                print(headers)
//                print(response)
//                print(response.result)
//                
//                switch response.result {
//                    
//                case .success(let JSON):
//                    
//                    print("Validation Successful with response JSON \(JSON)")
//                    
//                    guard let data = response.data else { return }
//                    
//                    do {
//                        
//                        let decoder = JSONDecoder()
//                        let liveAuctionRequest = try decoder.decode(NewLiveAuctionModel.self, from: data)
//                        print(liveAuctionRequest)
//                        
//                        if liveAuctionRequest.code == 200 {
//                            
//                            print("success")
//                            
//                            if liveAuctionRequest.code == 200 {
//                                
//                                for card in liveAuctionRequest.item?.cards ?? [] {
//                                    
//                                    if card.selectorStatus == true {
//                                        self.cardID = card.id
//                                        self.firstTimeCardSelect = true
//                                    }
//                                    
//                                }
//                                
//                            }
//                            
//                            self.getCardUpdate(id: self.auction_id)
//                            self.getParticipants(id: self.auction_id)
//                            
//                        }
//                        
//                        if liveAuctionRequest.message == "Unauthenticated." {
//                            
//                            let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
//                            let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
//                                
//                                
//                                let story = UIStoryboard(name: "Authentication", bundle:nil)
//                                let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                                UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
//                                UIApplication.shared.windows.first?.makeKeyAndVisible()
//                                
//                            }
//                            //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
//                            alert.addAction(okAction)
//                            //alert.addAction(cancelAction)
//                            self.present(alert, animated: true, completion: nil)
//                            
//                        }
//                        
//                        //self.hideIndecator()
//                    } catch let error {
//                        //self.hideIndecator()
//                        print(error)
//                        
//                    }
//                    
//                case .failure(let error):
//                    
//                    print("Request failed with error \(error)")
//                    
//                }
//                
//            }
//        
//    }
//    
//    func performUpdateStatusAgree(status: String?) { //url: String, parameters: [String:Any]
//        
//        let url = "https://hawy-kw.com/api/auctions/sales/status"
//        
//        let param: [String: Any] = [
//            
//            "card_id" : cardID ?? 0,
//            "auction_id": auction_id ?? 0,
//            "status": status ?? "" //bidLabel.text ?? ""
//            
//        ]
//        
//        print(param)
//        
//        let headers: HTTPHeaders = [
//            "Content-Type":"application/json",
//            "Accept":"application/json",
//            "Accept-Language":AppLocalization.currentAppleLanguage(),
//            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
//            "offset": "\(HelperConstant.getOffst() ?? 0)"
//        ]
//        
//        showIndecator()
//        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers) // //URLEncoding.httpBody
//            .validate(statusCode: 200...500)
//        
//            .responseJSON { response in
//                
//                print(param)
//                print(headers)
//                print(response)
//                print(response.result)
//                
//                switch response.result {
//                    
//                case .success(let JSON):
//                    
//                    print("Validation Successful with response JSON \(JSON)")
//                    
//                    guard let data = response.data else { return }
//                    
//                    do {
//                        
//                        let decoder = JSONDecoder()
//                        let forgetPasswordRequest = try decoder.decode(AuctionAcceptRejectModelModel.self, from: data)
//                        print(forgetPasswordRequest)
//                        
//                        if forgetPasswordRequest.code == 200 {
//                            
//                            print("success")
//                            
//                            //self.acceptOfferLabel.text = "Offer accepted".localized
//                            //self.payDoneStack.isHidden = false
//                            //self.acceptRejectButtonsStack.isHidden = true
//                            //self.desc24HLabel.isHidden = false
//                            
//                            self.getCardUpdate(id: self.auction_id)
//                            
//                            self.getParticipants(id: self.auction_id)
//                            
//                            
//                        }
//                        if forgetPasswordRequest.message == "Unauthenticated." {
//                            
//                            let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
//                            let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
//                                
//                                
//                                let story = UIStoryboard(name: "Authentication", bundle:nil)
//                                let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                                UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
//                                UIApplication.shared.windows.first?.makeKeyAndVisible()
//                                
//                            }
//                            //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
//                            alert.addAction(okAction)
//                            //alert.addAction(cancelAction)
//                            self.present(alert, animated: true, completion: nil)
//                            
//                        }
//                        self.hideIndecator()
//                    } catch let error {
//                        self.hideIndecator()
//                        print(error)
//                        
//                    }
//                    
//                case .failure(let error):
//                    
//                    print("Request failed with error \(error)")
//                    
//                }
//                
//            }
//        
//    }
//    
//    func performUpdateStatusDisagree(status: String?) { //url: String, parameters: [String:Any]
//        
//        let url = "https://hawy-kw.com/api/auctions/sales/status"
//        
//        let param: [String: Any] = [
//            
//            "card_id" : cardID ?? 0,
//            "auction_id": auction_id ?? 0,
//            "status": status ?? "" //bidLabel.text ?? ""
//            
//        ]
//        
//        print(param)
//        
//        let headers: HTTPHeaders = [
//            "Content-Type":"application/json",
//            "Accept":"application/json",
//            "Accept-Language":AppLocalization.currentAppleLanguage(),
//            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
//            "offset": "\(HelperConstant.getOffst() ?? 0)"
//        ]
//        
//        showIndecator()
//        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers) // //URLEncoding.httpBody
//            .validate(statusCode: 200...500)
//        
//            .responseJSON { response in
//                
//                print(param)
//                print(headers)
//                print(response)
//                print(response.result)
//                
//                switch response.result {
//                    
//                case .success(let JSON):
//                    
//                    print("Validation Successful with response JSON \(JSON)")
//                    
//                    guard let data = response.data else { return }
//                    
//                    do {
//                        
//                        let decoder = JSONDecoder()
//                        let forgetPasswordRequest = try decoder.decode(AuctionAcceptRejectModelModel.self, from: data)
//                        print(forgetPasswordRequest)
//                        
//                        if forgetPasswordRequest.code == 200 {
//                            
//                            print("success")
//                            
//                            //self.acceptOfferLabel.text = "Offer rejected".localized
//                            //self.desc24HLabel.isHidden = true
//                            //self.payDoneStack.isHidden = true
//                            //self.acceptRejectButtonsStack.isHidden = true
//                            //self.acceptedRejectedViewHeight.constant = 40
//                            
//                            self.getCardUpdate(id: self.auction_id)
//                            
//                            self.getParticipants(id: self.auction_id)
//                            
//                        }
//                        
//                        if forgetPasswordRequest.message == "Unauthenticated." {
//                            
//                            let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
//                            let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
//                                
//                                
//                                let story = UIStoryboard(name: "Authentication", bundle:nil)
//                                let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                                UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
//                                UIApplication.shared.windows.first?.makeKeyAndVisible()
//                                
//                            }
//                            //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
//                            alert.addAction(okAction)
//                            //alert.addAction(cancelAction)
//                            self.present(alert, animated: true, completion: nil)
//                            
//                        }
//                        
//                        self.hideIndecator()
//                    } catch let error {
//                        self.hideIndecator()
//                        print(error)
//                        
//                    }
//                    
//                case .failure(let error):
//                    
//                    print("Request failed with error \(error)")
//                    
//                }
//                
//            }
//        
//    }
//    
//    func performUpdateStatusPayDone(status: String?) { //url: String, parameters: [String:Any]
//        
//        let url = "https://hawy-kw.com/api/auctions/sales/status"
//        
//        let param: [String: Any] = [
//            
//            "card_id" : cardID ?? 0,
//            "auction_id": auction_id ?? 0,
//            "status": status ?? "" //bidLabel.text ?? ""
//            
//        ]
//        
//        print(param)
//        
//        let headers: HTTPHeaders = [
//            "Content-Type":"application/json",
//            "Accept":"application/json",
//            "Accept-Language":AppLocalization.currentAppleLanguage(),
//            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
//            "offset": "\(HelperConstant.getOffst() ?? 0)"
//        ]
//        
//        showIndecator()
//        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers) // //URLEncoding.httpBody
//            .validate(statusCode: 200...500)
//        
//            .responseJSON { response in
//                
//                print(param)
//                print(headers)
//                print(response)
//                print(response.result)
//                
//                switch response.result {
//                    
//                case .success(let JSON):
//                    
//                    print("Validation Successful with response JSON \(JSON)")
//                    
//                    guard let data = response.data else { return }
//                    
//                    do {
//                        
//                        let decoder = JSONDecoder()
//                        let forgetPasswordRequest = try decoder.decode(AuctionAcceptRejectModelModel.self, from: data)
//                        print(forgetPasswordRequest)
//                        
//                        if forgetPasswordRequest.code == 200 {
//                            
//                            print("success")
//                            
//                            //self.acceptOfferLabel.text = "Pay Done".localized
//                            //self.desc24HLabel.isHidden = true
//                            //self.payDoneStack.isHidden = true
//                            //self.acceptRejectButtonsStack.isHidden = true
//                            
//                            self.getCardUpdate(id: self.auction_id)
//                            
//                            self.getParticipants(id: self.auction_id)
//                            
//                        }
//                        
//                        if forgetPasswordRequest.message == "Unauthenticated." {
//                            
//                            let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
//                            let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
//                                
//                                
//                                let story = UIStoryboard(name: "Authentication", bundle:nil)
//                                let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                                UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
//                                UIApplication.shared.windows.first?.makeKeyAndVisible()
//                                
//                            }
//                            //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
//                            alert.addAction(okAction)
//                            //alert.addAction(cancelAction)
//                            self.present(alert, animated: true, completion: nil)
//                            
//                        }
//                        
//                        self.hideIndecator()
//                    } catch let error {
//                        self.hideIndecator()
//                        print(error)
//                        
//                    }
//                    
//                case .failure(let error):
//                    
//                    print("Request failed with error \(error)")
//                    
//                }
//                
//            }
//        
//    }
//    
//    func performAddBidRequest() { //url: String, parameters: [String:Any]
//        
//        let url = "https://hawy-kw.com/api/bid"
//        
//        let param: [String: Any] = [
//            
//            "card_id" : cardID ?? 0,
//            "auction_id": auction_id ?? 0,
//            "price": bidLabel.text ?? "",
//            "bid_time": Int(Date.currentTimeStamp)
//            
//        ]
//        
//        print(param)
//        
//        let headers: HTTPHeaders = [
//            "Content-Type":"application/json",
//            "Accept":"application/json",
//            "Accept-Language":AppLocalization.currentAppleLanguage(),
//            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
//            "offset": "\(HelperConstant.getOffst() ?? 0)"
//        ]
//        
//        showIndecator()
//        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers) // //URLEncoding.httpBody
//            .validate(statusCode: 200...500)
//        
//            .responseJSON { response in
//                
//                print(param)
//                print(headers)
//                print(response)
//                print(response.result)
//                
//                switch response.result {
//                    
//                case .success(let JSON):
//                    
//                    print("Validation Successful with response JSON \(JSON)")
//                    
//                    guard let data = response.data else { return }
//                    
//                    do {
//                        
//                        let decoder = JSONDecoder()
//                        let forgetPasswordRequest = try decoder.decode(BidModel.self, from: data)
//                        print(forgetPasswordRequest)
//                        
//                        if forgetPasswordRequest.code == 200 {
//                            
//                            print("success")
//                            
//                            //self.bidLabel.text = "\(forgetPasswordRequest.item?.minimumBiding ?? 0)"
//                            //
//                            //self.priceLabel.text = "\(forgetPasswordRequest.item?.offer?.price ?? "0.0")"
//                            //self.priceLabel.text = "\(forgetPasswordRequest.item?.offer?.price ?? "0.0")"
//                            ////self.bidLabel.text = data.data?.price
//                            //self.ownerUserImage.loadImage(URLS.baseImageURL+(forgetPasswordRequest.item?//.offer?.user?.image ?? ""))
//                            //self.ownerNameLabel.text = forgetPasswordRequest.item?.offer?.user?.name ?? ""
//                            
//                        }
//                        
//                        if forgetPasswordRequest.message == "Unauthenticated." {
//                            
//                            let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
//                            let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
//                                
//                                
//                                let story = UIStoryboard(name: "Authentication", bundle:nil)
//                                let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                                UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
//                                UIApplication.shared.windows.first?.makeKeyAndVisible()
//                                
//                            }
//                            //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
//                            alert.addAction(okAction)
//                            //alert.addAction(cancelAction)
//                            self.present(alert, animated: true, completion: nil)
//                            
//                        }
//                        
//                        self.hideIndecator()
//                    } catch let error {
//                        self.hideIndecator()
//                        print(error)
//                        
//                    }
//                    
//                case .failure(let error):
//                    
//                    print("Request failed with error \(error)")
//                    
//                }
//                
//            }
//        
//    }
//    
//    func videoCallToken(auction_id: Int?, card_id: Int?) {
//        
//        let headers: HTTPHeaders = [
//            "Content-Type":"application/json",
//            "Accept":"application/json",
//            "Accept-Language":AppLocalization.currentAppleLanguage(),
//            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
//            "offset": "\(HelperConstant.getOffst() ?? 0)"
//        ]
//        
//        showIndecator() //
//        AF.request("https://hawy-kw.com/api/auctions/live/videoCall/token?auction_id=\(auction_id ?? 0)&card_id=\(cardID ?? 0)", method: .get, parameters: nil, headers: headers)
//            .validate(statusCode: 200...500)
//            .responseJSON { (response) in
//                print(response)
//                
//                do {
//                    let productResponse = try JSONDecoder().decode(VideoTokenModel.self, from: response.data!)
//                    
//                    if productResponse.message == "Unauthenticated." {
//                        
//                        let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
//                        let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
//                            
//                            
//                            let story = UIStoryboard(name: "Authentication", bundle:nil)
//                            let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
//                            UIApplication.shared.windows.first?.makeKeyAndVisible()
//                            
//                        }
//                        //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
//                        alert.addAction(okAction)
//                        //alert.addAction(cancelAction)
//                        self.present(alert, animated: true, completion: nil)
//                        
//                    }
//                    
//                    if productResponse.code == 200 {
//                        print("success")
//                        
//                        print(productResponse.item)
//                        
//                        self.initializeAgoraEngine()
//                   
//                        
//                        
//                        let option = AgoraRtcChannelMediaOptions()
//
//                        // Set the client role option as broadcaster or audience.
//                        if self.userRole == .broadcaster {
//                            option.clientRoleType = .broadcaster
//                            self.setupLocalVideo(id: 0)
//                        } else {
//                            option.clientRoleType = .audience
//                        }
//                        
//                        option.channelProfile = .communication
//
//                        // Join the channel with a temp token. Pass in your token and channel name here
//                        let result = self.agoraKit.joinChannel(
//                            byToken:  productResponse.item?.token, channelId: productResponse.item?.channelName ?? "", uid: 0, mediaOptions: option,
//                            joinSuccess: { (channel, uid, elapsed) in }
//                        )
//                            // Check if joining the channel was successful and set joined Bool accordingly
//                  
////                        if productResponse.item?.owner?.id ?? 0 == productResponse.item?.currentUser?.id ?? 0 {
////                            self.agoraKit.setClientRole(.broadcaster)
////                        }else {
////                            self.agoraKit.setClientRole(.audience)
////                        }
////
////                        self.agoraKit.enableVideo()
////
////                        if productResponse.item?.owner?.id ?? 0 == productResponse.item?.currentUser?.id ?? 0 {
////                            self.agoraKit.enableLocalVideo(true)
////                            self.agoraKit.switchCamera()
////                        }else{
////                            self.agoraKit.enableLocalVideo(false)
////                        }
////                        //self.muteVideo = !(productResponse.item?.currentUser?.video_status ?? false)
////                        //self.muteMic = !(productResponse.item?.currentUser?.isSpeaker ?? false)
////
////                        self.agoraKit.muteLocalAudioStream(!(productResponse.item?.currentUser?.isSpeaker ?? false))
////                        self.agoraKit.muteLocalVideoStream(!(productResponse.item?.currentUser?.video_status ?? false))
////
////                        if productResponse.item?.owner?.id ?? 0 == productResponse.item?.currentUser?.id ?? 0 {
////                            self.setupLocalVideo(id: UInt(productResponse.item?.owner?.id ?? 0))
////                        }else {
////                            self.setupRemoteVideo(id: UInt(productResponse.item?.owner?.id ?? 0))
////                        }
////
//                        
////                        self.joinChannel(id: UInt(productResponse.item?.currentUser?.id ?? 0), channel: productResponse.item?.channelName, token: productResponse.item?.token)
//                        
////                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
////                            self.agoraKit.switchCamera()
////                        })
//                        
//                        if productResponse.item?.owner?.id ?? 0 == productResponse.item?.currentUser?.id ?? 0 {
//                            self.micMuteButton.isHidden = false
//                        }else {
//                            
//                            if productResponse.item?.currentUser?.raiseHand == true {
//                                self.micMuteButton.isHidden = false
//                            }
//                            
//                        }
//                        
//                    }
//                    self.hideIndecator()
//                } catch {
//                    self.hideIndecator()
//                }
//            }
//    }
//    
//    func JoinUserAuctionVideo() {
//        
//        let headers: HTTPHeaders = [
//            "Content-Type":"application/json",
//            "Accept":"application/json",
//            "Accept-Language":AppLocalization.currentAppleLanguage(),
//            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
//            "offset": "\(HelperConstant.getOffst() ?? 0)"
//        ]
//        
//        let param : [String: Any] = [
//            
//            "auction_id" : auction_id ?? 0,
//            "card_id" : cardID ?? 0
//            
//        ]
//        
//        showIndecator() //?user_id=20
//        AF.request("https://hawy-kw.com/api/auctions/live/videoCall/user/join", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
//            .validate(statusCode: 200...500)
//            .responseJSON { (response) in
//                print(response)
//                
//                do {
//                    let productResponse = try JSONDecoder().decode(AddUserToAuctionVideoModel.self, from: response.data!)
//                    
//                    if productResponse.message == "Unauthenticated." {
//                        
//                        let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
//                        let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
//                            
//                            
//                            let story = UIStoryboard(name: "Authentication", bundle:nil)
//                            let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
//                            UIApplication.shared.windows.first?.makeKeyAndVisible()
//                            
//                        }
//                        //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
//                        alert.addAction(okAction)
//                        // alert.addAction(cancelAction)
//                        self.present(alert, animated: true, completion: nil)
//                        
//                    }
//                    
//                    if productResponse.code == 200 {
//                        print("success")
//                        
//                        self.videoCallToken(auction_id: self.auction_id, card_id: self.cardID)
//                        
//                        self.listenToJoinVideoCall(auction_id: self.auction_id, card_id: self.cardID)
//                        
//                        //self.getJoindData(id: self.card_id, userId: HelperConstant.getUserId())
//                        self.getParticipants(id: self.auctionID)
//                        
//                    }else{
//                        ToastManager.shared.showError(message: productResponse.message ?? "", view: self.view)
//                    }
//                    
//                    
//                    self.hideIndecator()
//                } catch {
//                    self.hideIndecator()
//                    // self.NoInternetConnectionMessage()
//                }
//            }
//    }
//    
//    func deleteUserAuctionVideo() {
//        
//        let headers: HTTPHeaders = [
//            "Content-Type":"application/json",
//            "Accept":"application/json",
//            "Accept-Language":AppLocalization.currentAppleLanguage(),
//            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
//            "offset": "\(HelperConstant.getOffst() ?? 0)"
//        ]
//        
//        let param : [String: Any] = [
//            
//            "auction_id" : auction_id ?? 0,
//            "card_id" : cardID ?? 0
//            
//        ]
//        
//        showIndecator() //?user_id=20
//        AF.request("https://hawy-kw.com/api/auctions/live/videoCall/user/out", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
//            .validate(statusCode: 200...500)
//            .responseJSON { (response) in
//                print(response)
//                
//                do {
//                    let productResponse = try JSONDecoder().decode(AddUserToAuctionVideoModel.self, from: response.data!)
//                    
//                    if productResponse.message == "Unauthenticated." {
//                        
//                        let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
//                        let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
//                            
//                            
//                            let story = UIStoryboard(name: "Authentication", bundle:nil)
//                            let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
//                            UIApplication.shared.windows.first?.makeKeyAndVisible()
//                            
//                        }
//                        //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
//                        alert.addAction(okAction)
//                        //alert.addAction(cancelAction)
//                        self.present(alert, animated: true, completion: nil)
//                        
//                    }
//                    
//                    if productResponse.code == 200 {
//                        print("success")
//                        
//                        //self.getJoindData(id: self.card_id, userId: HelperConstant.getUserId())
//                        self.getParticipants(id: self.auction_id)
//                        
//                    }else{
//                        ToastManager.shared.showError(message: productResponse.message ?? "", view: self.view)
//                    }
//                    
//                    
//                    self.hideIndecator()
//                } catch {
//                    self.hideIndecator()
//                    // self.NoInternetConnectionMessage()
//                }
//            }
//    }
//    
//    func raiseHand() {
//        
//        let headers: HTTPHeaders = [
//            "Content-Type":"application/json",
//            "Accept":"application/json",
//            "Accept-Language":AppLocalization.currentAppleLanguage(),
//            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
//            "offset": "\(HelperConstant.getOffst() ?? 0)"
//        ]
//        
//        let param : [String: Any] = [
//            
//            "auction_id" : auction_id ?? 0,
//            "card_id" : cardID ?? 0
//            
//        ]
//        
//        showIndecator() //?user_id=20
//        AF.request("https://hawy-kw.com/api/auctions/live/videoCall/user/raiseHand", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
//            .validate(statusCode: 200...500)
//            .responseJSON { (response) in
//                print(response)
//                
//                do {
//                    let productResponse = try JSONDecoder().decode(AddUserToAuctionVideoModel.self, from: response.data!)
//                    
//                    
//                    if productResponse.message == "Unauthenticated." {
//                        
//                        let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
//                        let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
//                            
//                            
//                            let story = UIStoryboard(name: "Authentication", bundle:nil)
//                            let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
//                            UIApplication.shared.windows.first?.makeKeyAndVisible()
//                            
//                        }
//                        //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
//                        alert.addAction(okAction)
//                        //alert.addAction(cancelAction)
//                        self.present(alert, animated: true, completion: nil)
//                        
//                    }
//                    
//                    if productResponse.code == 200 {
//                        print("success")
//                        
//                        self.acceptRejectId = productResponse.item?.id //data.data?.id
//                        print(self.acceptRejectId)
//                        
//                    }else{
//                        ToastManager.shared.showError(message: productResponse.message ?? "", view: self.view)
//                    }
//                    
//                    self.hideIndecator()
//                } catch {
//                    self.hideIndecator()
//                    // self.NoInternetConnectionMessage()
//                }
//            }
//    }
//    
//    //
//    func raiseHandRequests(auction_id: Int?, card_id: Int?) {
//        
//        let headers: HTTPHeaders = [
//            "Content-Type":"application/json",
//            "Accept":"application/json",
//            "Accept-Language":AppLocalization.currentAppleLanguage(),
//            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
//            "offset": "\(HelperConstant.getOffst() ?? 0)"
//        ]
//        
//        showIndecator() //
//        AF.request("https://hawy-kw.com/api/auctions/live/videoCall/user/raiseHandRequests?auction_id=\(auction_id ?? 0)&card_id=\(cardID ?? 0)", method: .get, parameters: nil, headers: headers)
//            .validate(statusCode: 200...500)
//            .responseJSON { (response) in
//                print(response)
//                
//                do {
//                    let productResponse = try JSONDecoder().decode(AllRaiseRequestsVideoModel.self, from: response.data!)
//                    
//                    if productResponse.message == "Unauthenticated." {
//                        
//                        let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
//                        let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
//                            
//                            
//                            let story = UIStoryboard(name: "Authentication", bundle:nil)
//                            let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
//                            UIApplication.shared.windows.first?.makeKeyAndVisible()
//                            
//                        }
//                        //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
//                        alert.addAction(okAction)
//                        //alert.addAction(cancelAction)
//                        self.present(alert, animated: true, completion: nil)
//                        
//                    }
//                    
//                    if productResponse.code == 200 {
//                        print("success")
//                        
//                        //self.AllRequsts = productResponse.item ?? []
//                        //self.membersCountLabel.text = "\(self.AllRequsts.count)"
//                        //self.membersInLiveCollection.reloadData()
//                        
//                    }
//                    self.hideIndecator()
//                } catch {
//                    self.hideIndecator()
//                    // self.NoInternetConnectionMessage()
//                }
//            }
//    }
//    
//    //
//    func raiseHandStatus(status: String?) {
//        
//        let headers: HTTPHeaders = [
//            "Content-Type":"application/json",
//            "Accept":"application/json",
//            "Accept-Language":AppLocalization.currentAppleLanguage(),
//            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
//            "offset": "\(HelperConstant.getOffst() ?? 0)"
//        ]
//        
//        let param : [String: Any] = [
//            
//            "auction_id" : auction_id ?? 0,
//            "card_id" : cardID ?? 0,
//            "status" : status ?? "", //"accept", //reject
//            "user_id" : acceptRejectId ?? 0
//        ]
//        
//        showIndecator() //?user_id=20
//        AF.request("https://hawy-kw.com/api/auctions/live/videoCall/user/raiseHand/status", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
//            .validate(statusCode: 200...500)
//            .responseJSON { (response) in
//                print(response)
//                
//                do {
//                    let productResponse = try JSONDecoder().decode(AddUserToAuctionVideoModel.self, from: response.data!)
//                    
//                    if productResponse.message == "Unauthenticated." {
//                        
//                        let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
//                        let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
//                            
//                            
//                            let story = UIStoryboard(name: "Authentication", bundle:nil)
//                            let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
//                            UIApplication.shared.windows.first?.makeKeyAndVisible()
//                            
//                        }
//                        //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
//                        alert.addAction(okAction)
//                        //alert.addAction(cancelAction)
//                        self.present(alert, animated: true, completion: nil)
//                        
//                    }
//                    
//                    if productResponse.code == 200 {
//                        print("success")
//                        
//                        //self.getJoindData(id: self.card_id, userId: HelperConstant.getUserId())
//                        self.getParticipants(id: self.auctionID)
//                        //self.raiseHandRequests(auction_id: self.auction_id, card_id: self.card_id)
//                        
//                        self.acceptRjectRaiseHandViewHeight.constant = 0
//                        self.acceptRjectRaiseHandView.isHidden = true
//                        
//                        
//                    }else{
//                        ToastManager.shared.showError(message: productResponse.message ?? "", view: self.view)
//                    }
//                    
//                    
//                    self.hideIndecator()
//                } catch {
//                    self.hideIndecator()
//                    // self.NoInternetConnectionMessage()
//                }
//            }
//    }
//    
//    //
//    func microphoneStatus(mic: String) {
//        
//        let headers: HTTPHeaders = [
//            "Content-Type":"application/json",
//            "Accept":"application/json",
//            "Accept-Language":AppLocalization.currentAppleLanguage(),
//            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
//            "offset": "\(HelperConstant.getOffst() ?? 0)"
//        ]
//        
//        let param : [String: Any] = [
//            
//            "auction_id" : auction_id ?? 0,
//            "card_id" : cardID ?? 0,
//            "mic" : mic //"on" //off
//        ]
//        
//        showIndecator() //?user_id=20
//        AF.request("https://hawy-kw.com/api/auctions/live/videoCall/user/microphone", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
//            .validate(statusCode: 200...500)
//            .responseJSON { (response) in
//                print(response)
//                
//                do {
//                    let productResponse = try JSONDecoder().decode(AddUserToAuctionVideoModel.self, from: response.data!)
//                    
//                    if productResponse.message == "Unauthenticated." {
//                        
//                        let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
//                        let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
//                            
//                            
//                            let story = UIStoryboard(name: "Authentication", bundle:nil)
//                            let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
//                            UIApplication.shared.windows.first?.makeKeyAndVisible()
//                            
//                        }
//                        //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
//                        alert.addAction(okAction)
//                        //alert.addAction(cancelAction)
//                        self.present(alert, animated: true, completion: nil)
//                        
//                    }
//                    
//                    if productResponse.code == 200 {
//                        print("success")
//                        
//                        
//                        
//                        //self.getJoindData(id: self.card_id, userId: HelperConstant.getUserId())
//                        self.getParticipants(id: self.auctionID)
//                        
//                    }else{
//                        ToastManager.shared.showError(message: productResponse.message ?? "", view: self.view)
//                    }
//                    
//                    
//                    self.hideIndecator()
//                } catch {
//                    self.hideIndecator()
//                    // self.NoInternetConnectionMessage()
//                }
//            }
//    }
//    
//    
//    func videoStatus(status: String) {
//        
//        let headers: HTTPHeaders = [
//            "Content-Type":"application/json",
//            "Accept":"application/json",
//            "Accept-Language":AppLocalization.currentAppleLanguage(),
//            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
//            "offset": "\(HelperConstant.getOffst() ?? 0)"
//        ]
//        
//        let param : [String: Any] = [
//            
//            "auction_id" : auction_id ?? 0,
//            "card_id" : cardID ?? 0,
//            "video_status" : status //"on" //off
//        ]
//        
//        showIndecator() //?user_id=20
//        AF.request("https://hawy-kw.com/api/auctions/live/videoCall/user/videoStatus", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
//            .validate(statusCode: 200...500)
//            .responseJSON { (response) in
//                print(response)
//                
//                do {
//                    let productResponse = try JSONDecoder().decode(AddUserToAuctionVideoModel.self, from: response.data!)
//                    
//                    if productResponse.message == "Unauthenticated." {
//                        
//                        let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
//                        let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
//                            
//                            
//                            let story = UIStoryboard(name: "Authentication", bundle:nil)
//                            let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
//                            UIApplication.shared.windows.first?.makeKeyAndVisible()
//                            
//                        }
//                        //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
//                        alert.addAction(okAction)
//                        //alert.addAction(cancelAction)
//                        self.present(alert, animated: true, completion: nil)
//                        
//                    }
//                    
//                    if productResponse.code == 200 {
//                        print("success")
//                        
//                        //self.getJoindData(id: self.card_id, userId: HelperConstant.getUserId())
//                        self.getParticipants(id: self.auctionID)
//                        
//                    }else{
//                        ToastManager.shared.showError(message: productResponse.message ?? "", view: self.view)
//                    }
//                    
//                    
//                    self.hideIndecator()
//                } catch {
//                    self.hideIndecator()
//                    // self.NoInternetConnectionMessage()
//                }
//            }
//    }
//    
//}
