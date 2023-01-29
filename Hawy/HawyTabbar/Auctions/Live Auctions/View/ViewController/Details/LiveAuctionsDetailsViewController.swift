//
//  LiveAuctionsDetailsViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 14/08/2022.
//

import UIKit
//import AgoraRtcKit
//import AgoraARKit
import PusherSwift
import AgoraRtcKit
import Alamofire
import AVFoundation


enum UserRole {
    case broadcaster
    case audience
}

class LiveAuctionsDetailsViewController: BaseViewViewController, PusherDelegate {

    @IBOutlet weak var bannerContainerView: UIView!
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var winHeighPriceHeight: NSLayoutConstraint!
    @IBOutlet weak var noteTV: UITextView!
    @IBOutlet weak var winView: UIView!
    @IBOutlet weak var highPriceView: UIView!
    
    @IBOutlet weak var plusButtonOutlet: UIButton!
    @IBOutlet weak var minusButtonOutlet: UIButton!
    
    @IBOutlet weak var ownerUserImage: UIImageView!
    
    @IBOutlet weak var requestedUserImage: UIImageView!
    @IBOutlet weak var requestedUserNameLable: UILabel!
    
    @IBOutlet weak var membersInLiveCollection: UICollectionView!{
        didSet {
            
            membersInLiveCollection.dataSource = self
            membersInLiveCollection.delegate = self
            
            membersInLiveCollection.register(UINib(nibName: "LiveMembersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LiveMembersCollectionViewCell")
            
        }
    }
    
    @IBOutlet weak var acceptRejectRaiseHandView: UIView!
    @IBOutlet weak var acceptRaiseHandViewHeight: NSLayoutConstraint!
    @IBOutlet weak var addBidViewOutlet: UIView!
    @IBOutlet weak var addBidViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sendRaiseHandViewOutlet: UIView!
    @IBOutlet weak var membersCountLabel: UILabel!
    @IBOutlet weak var plusMinusDescLabel: UILabel!
    @IBOutlet weak var bidLabel: UILabel!
    
    @IBOutlet weak var localVideo: UIView!
    @IBOutlet weak var remoteVideo: UIView!
    @IBOutlet weak var controlButtons: UIView!
    @IBOutlet weak var remoteVideoMutedIndicator: UIImageView!
    @IBOutlet weak var localVideoMutedBg: UIImageView!
    @IBOutlet weak var localVideoMutedIndicator: UIImageView!
    @IBOutlet weak var addBidButton: GradientButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var clockImage: UIImageView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var acceptRejectView: UIView!
    @IBOutlet weak var acceptedRejectedViewHeight: NSLayoutConstraint!
    @IBOutlet weak var stackContainerOfAcceptReject: UIStackView!
    @IBOutlet weak var acceptOfferLabel: UILabel!
    @IBOutlet weak var desc24HLabel: UILabel!
    
    @IBOutlet weak var acceptRejectButtonsStack: UIStackView!
    @IBOutlet weak var acceptButtonOutlet: GradientButton!
    @IBOutlet weak var rejectButtonOutlet: GradientButton!
    
    @IBOutlet weak var payDoneStack: UIStackView!
    @IBOutlet weak var payDoneButtonOutlet: GradientButton!
    
    @IBOutlet weak var videoMuteButton: UIButton!
    @IBOutlet weak var micMuteButton: UIButton!
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var hangupButton: UIButton!
    
    @IBOutlet weak var partecipantView: UIView!
    @IBOutlet weak var partecipantViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var contactsViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var seemsToBeWinViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var animalName: UILabel!
    @IBOutlet weak var fatherName: UILabel!
    @IBOutlet weak var motherName: UILabel!
    
    
    let decoder = JSONDecoder()
    //to get socket
    var pusher: Pusher!
    
    var pusherTime: Pusher!
    
    var bidPusher: Pusher!
    
    var pusher3: Pusher!
    
    var pusher4: Pusher!
    
    var pusher6: Pusher!
    
    var pusher7: Pusher!
    
    var agoraKit: AgoraRtcEngineKit! // Tutorial Step 1
    let AppID: String = "7b6a157448db44578f1c88fbefecbac0" // Tutorial Step 1
    
    var auction_id : Int?
    var card_id : Int?
    
    var time: Int?
    var currentTime: Int?
    
    var timer2: Timer?
    var totalTime: Int = 0
    var finalTotal: Int = 0
    var lastOfferUserId: Int?
    
    var token: String?
    var channel:String?
    var currentUserId: UInt?
    var bidMaxPrice: String?
    
    var isOwnerOrnot = 0
    
    var OwnerId: Int?
    var conductorId: Int?
    var conductedBy: String?
    
    var AllRequsts = [ShowCardDetailsJoinedUser]()
    
    var userRole2: UserRole?
    //var userRole: AgoraClientRole = .broadcaster
    
    var joined: Bool = false
    
    var acceptRejectId: Int?
    
    var collapse = true
    
    var muteVideo = false {
        didSet {
            if muteVideo {
                videoMuteButton.setImage(UIImage(named: "videoMuteButtonSelected"), for: .normal)
                
                localVideoMutedBg.isHidden = true
                remoteVideoMutedIndicator.isHidden = true
                
                videoStatus(status: "off")
                
            }else {
                videoMuteButton.setImage(UIImage(named: "videoMuteButton"), for: .normal)
                
                localVideoMutedBg.isHidden = false
                remoteVideoMutedIndicator.isHidden = false
                
                videoStatus(status: "on")
                
            }
        }
    }
    
    var muteMic = false {
        didSet {
            if muteMic == false {
                micMuteButton.setImage(UIImage(named: "muteButtonSelected"), for: .normal)
                
                microphoneStatus(mic: "on") //"on" //off
                agoraKit.muteLocalAudioStream(false)
                
            }else {
                micMuteButton.setImage(UIImage(named: "muteButton"), for: .normal)
                
                microphoneStatus(mic: "off") //"on" //off
                agoraKit.muteLocalAudioStream(true)
                
            }
        }
    }
    
    var isused = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        winHeighPriceHeight.constant = 0
        contactsViewHeight.constant = 0
        acceptRaiseHandViewHeight.constant = 0
        seemsToBeWinViewHeight.constant = 0
        
        partecipantViewHeight.constant = 100
        membersInLiveCollection.isHidden = true
        
        micMuteButton.isHidden = true
        
        localVideo.isHidden = true
        localVideoMutedBg.isHidden = true
        localVideoMutedIndicator.isHidden = true
        remoteVideoMutedIndicator.isHidden = true
        
        videoMuteButton.setImage(UIImage(named: "videoMuteButtonSelected"), for: .normal)
        micMuteButton.setImage(UIImage(named: "muteButton"), for: .normal)
        switchCameraButton.setImage(UIImage(named: "switchCameraButtonSelected"), for: .normal)
        
        membersInLiveCollection.collectionViewLayout = createCompositionalLayout()
        
        acceptedRejectedViewHeight.constant = 0
        acceptRejectView.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getCardData(id: card_id, userId: HelperConstant.getUserId())
        
        
        JoinUserAuctionVideo()
        
        getLastOffer()
        
        raiseHandRequests(auction_id: auction_id, card_id: card_id)
        
        //microphoneStatus(mic: "on")
        
        listenToChangesFromPusherTime(auction_id: auction_id, card_id: card_id)
        
        if HelperConstant.getCurrency() == "USD" {
            listenToChangesFromPusherUSD(auction_id: auction_id, card_id: card_id)
        }else {
            listenToChangesFromPusher(auction_id: auction_id, card_id: card_id)
        }
        
        listenToOutVideoCall(auction_id: auction_id, card_id: card_id)
        
        listenToMicCall(auction_id: auction_id, card_id: card_id)
        
        getJoindData(id: card_id, userId: HelperConstant.getUserId())
        
        //agoraKit.muteLocalAudioStream(true)
        
        
        //self.raiseHandRequests(auction_id: self.auction_id, card_id: self.card_id)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        leaveChannel()
        
        DispatchQueue.global(qos: .userInitiated).async {AgoraRtcEngineKit.destroy()}
        
        self.timer2?.invalidate()
             
        
        if isused == true {
            
            //pusher7.disconnect()
            //pusher6.disconnect()
        }
        //pusher3.disconnect()
        //pusher.disconnect()
        //pusherTime.disconnect()
        //bidPusher.disconnect()
        //pusherTime.disconnect()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bannerContainerView.roundCorners([.bottomLeft, .bottomRight], radius: 20)
        winView.roundCorners([.topLeft, .topRight], radius: 20)
        highPriceView.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 10)
        plusButtonOutlet.roundCorners([.topLeft, .bottomLeft], radius: 10)
        minusButtonOutlet.roundCorners([.topRight, .bottomRight], radius: 10)
        
        let gradient = UIImage.gradientImage(bounds: ownerUserImage.bounds, colors: [DesignSystem.Colors.PrimaryBlue.color, DesignSystem.Colors.PrimaryOrange.color])
        let gradientColor = UIColor(patternImage: gradient)
        ownerUserImage.layer.borderColor = gradientColor.cgColor
        ownerUserImage.layer.borderWidth = 3
    }
    
    private func listenToChangesFromPusherTime(auction_id: Int?, card_id: Int?) {
        
        print("auction_id: \(auction_id), card_id: \(card_id)")
        // Instantiate Pusher
        pusherTime = Pusher(
            key: "65b581feebecaee4af62",
            options: PusherClientOptions(host: .cluster("eu"))
        )
        
        // Subscribe to a pusher channel
        let channel = pusherTime.subscribe("auction.\(auction_id ?? 0).\(card_id ?? 0)")
        
        pusherTime.delegate = self
        
        pusherTime.connect()
        
        // Bind to an event called "order-event" on the event channel and fire
        // the callback when the event is triggerred
        
        let eventNamee = #"App\Events\ApiDataListener"#
        print("App\\Events\\ApiDataListener")
        
        print(eventNamee)
        
        let _ = channel.bind(eventName: "App\\Events\\UpdateTime" , eventCallback: { [weak self] (event: PusherEvent) -> Void in
            
            guard let self = self else { return }
            
            print(event)
            
            // convert the data string to type data for decoding
            guard let json = event.data,
                  let jsonData = json.data(using: .utf8)
            else {
                print("Could not convert JSON string to data")
                return
            }
            
            print(json)
            print(jsonData)
            
            // decode the event data as json into a RealTimeModel
            let decoded = try? self.decoder.decode(UpdateTime.self, from: jsonData)
            guard let data = decoded else {
                print("Could not decode message")
                return
            }
            
            self.finalTotal = data.end_date ?? 0
            self.startOtpTimer()
            
        })
        
    }
    
    private func listenToJoinVideoCall(auction_id: Int?, card_id: Int?) {
        
        print("auction_id: \(auction_id), card_id: \(card_id)")
        // Instantiate Pusher
        pusher = Pusher(
            key: "65b581feebecaee4af62",
            options: PusherClientOptions(host: .cluster("eu"))
        )
        
        // Subscribe to a pusher channel
        let channel = pusher.subscribe("auction.\(auction_id ?? 0).\(card_id ?? 0)") //.\(card_id ?? 0)
        
        pusher.delegate = self
        
        pusher.connect()
        
        // Bind to an event called "order-event" on the event channel and fire
        // the callback when the event is triggerred
        
        
        let _ = channel.bind(eventName: "join_auction_video_call" , eventCallback: { [weak self] (event: PusherEvent) -> Void in
            
            guard let self = self else { return }
            
            print(event)
            
            // convert the data string to type data for decoding
            guard let json = event.data,
                  let jsonData = json.data(using: .utf8)
            else {
                print("Could not convert JSON string to data")
                return
            }
            
            print(json)
            print(jsonData)
            
            // decode the event data as json into a RealTimeModel
            let decoded = try? self.decoder.decode(RealTimeLiveModel.self, from: jsonData)
            guard let data = decoded else {
                print("Could not decode message")
                return
            }
            
            
            self.getJoindData(id: self.card_id, userId: HelperConstant.getUserId())
            
        })
        
    }
    
    private func listenToOutVideoCall(auction_id: Int?, card_id: Int?) {
        
        print("auction_id: \(auction_id), card_id: \(card_id)")
        // Instantiate Pusher
        pusher = Pusher(
            key: "65b581feebecaee4af62",
            options: PusherClientOptions(host: .cluster("eu"))
        )
        
        // Subscribe to a pusher channel
        let channel = pusher.subscribe("auction.\(auction_id ?? 0).\(card_id ?? 0)") //.\(card_id ?? 0)
        
        pusher.delegate = self
        
        pusher.connect()
        
        // Bind to an event called "order-event" on the event channel and fire
        // the callback when the event is triggerred
        
        
        let _ = channel.bind(eventName: "out_auction_video_call" , eventCallback: { [weak self] (event: PusherEvent) -> Void in
            
            guard let self = self else { return }
            
            print(event)
            
            // convert the data string to type data for decoding
            guard let json = event.data,
                  let jsonData = json.data(using: .utf8)
            else {
                print("Could not convert JSON string to data")
                return
            }
            
            print(json)
            print(jsonData)
            
            // decode the event data as json into a RealTimeModel
            let decoded = try? self.decoder.decode(RealTimeLiveModel.self, from: jsonData)
            guard let data = decoded else {
                print("Could not decode message")
                return
            }
            self.getJoindData(id: self.card_id, userId: HelperConstant.getUserId())
            
        })
        
    }
    
    private func listenToMicCall(auction_id: Int?, card_id: Int?) {
        
        print("auction_id: \(auction_id), card_id: \(card_id)")
        // Instantiate Pusher
        pusher4 = Pusher(
            key: "65b581feebecaee4af62",
            options: PusherClientOptions(host: .cluster("eu"))
        )
        
        // Subscribe to a pusher channel
        let channel = pusher4.subscribe("auction.\(auction_id ?? 0).\(card_id ?? 0)") //
        
        pusher4.delegate = self
        
        pusher4.connect()
        
        // Bind to an event called "order-event" on the event channel and fire
        // the callback when the event is triggerred
        
        
        let _ = channel.bind(eventName: "microphone" , eventCallback: { [weak self] (event: PusherEvent) -> Void in
            
            guard let self = self else { return }
            
            print(event)
            
            // convert the data string to type data for decoding
            guard let json = event.data,
                  let jsonData = json.data(using: .utf8)
            else {
                print("Could not convert JSON string to data")
                return
            }
            
            print(json)
            print(jsonData)
            
            // decode the event data as json into a RealTimeModel
            let decoded = try? self.decoder.decode(RealTimeLiveModel.self, from: jsonData)
            guard let data = decoded else {
                print("Could not decode message")
                return
            }
            
            //if data.id == HelperConstant.getUserId() {
                
//                if data.isSpeaker == true {
//                    self.agoraKit.muteLocalAudioStream(false)
//                    self.micMuteButton.setImage(UIImage(named: "muteButtonSelected"), for: .normal)
//                }else {
//                    self.agoraKit.muteLocalAudioStream(true)
//                    self.micMuteButton.setImage(UIImage(named: "muteButton"), for: .normal)
//                }
                
            //}
            
            self.getJoindData(id: self.card_id, userId: HelperConstant.getUserId())
            
        })
        
    }
    
    private func listenToAdminRaiseHandCall(auction_id: Int?, card_id: Int?) {
        
        print("auction_id: \(auction_id ?? 0), card_id: \(card_id)")
        // Instantiate Pusher
        pusher6 = Pusher(
            key: "65b581feebecaee4af62",
            options: PusherClientOptions(host: .cluster("eu"))
        )
        
        // Subscribe to a pusher channel
        let channel = pusher6.subscribe("auction.\(auction_id ?? 0).\(card_id ?? 0)") //.\(card_id ?? 0)
        
        pusher6.delegate = self
        
        pusher6.connect()
        
        // Bind to an event called "order-event" on the event channel and fire
        // the callback when the event is triggerred
        
        
        let _ = channel.bind(eventName: "admin_raise_hand_response" , eventCallback: { [weak self] (event: PusherEvent) -> Void in
            
            guard let self = self else { return }
            
            print(event)
            
            // convert the data string to type data for decoding
            guard let json = event.data,
                  let jsonData = json.data(using: .utf8)
            else {
                print("Could not convert JSON string to data")
                return
            }
            
            print(json)
            print(jsonData)
            
            // decode the event data as json into a RealTimeModel
            let decoded = try? self.decoder.decode(RealTimeLiveModel.self, from: jsonData)
            guard let data = decoded else {
                print("Could not decode message")
                return
            }
            
            self.isused = true
            
            if data.id == HelperConstant.getUserId() {
                
                if data.raiseHand == true {
                    
                    //self.agoraKit.muteLocalAudioStream(false)
                    self.micMuteButton.isHidden = false
                    
                }else {
                    
                    //self.agoraKit.muteLocalAudioStream(true)
                    self.micMuteButton.isHidden = true
                    
                }
                
            }
            
            self.getJoindData(id: self.card_id, userId: HelperConstant.getUserId())
            
        })
        
    }
    
    private func listenToAdminVideoStatusCall(auction_id: Int?, card_id: Int?) {
        
        print("auction_id: \(auction_id), card_id: \(card_id)")
        // Instantiate Pusher
        pusher7 = Pusher(
            key: "65b581feebecaee4af62",
            options: PusherClientOptions(host: .cluster("eu"))
        )
        
        // Subscribe to a pusher channel
        let channel = pusher7.subscribe("auction.\(auction_id ?? 0).\(card_id ?? 0)") //.\(card_id ?? 0)
        
        pusher7.delegate = self
        
        pusher7.connect()
        
        // Bind to an event called "order-event" on the event channel and fire
        // the callback when the event is triggerred
        
        
        let _ = channel.bind(eventName: "videoStatus" , eventCallback: { [weak self] (event: PusherEvent) -> Void in
            
            guard let self = self else { return }
            
            print(event)
            
            // convert the data string to type data for decoding
            guard let json = event.data,
                  let jsonData = json.data(using: .utf8)
            else {
                print("Could not convert JSON string to data")
                return
            }
            
            print(json)
            print(jsonData)
            
            // decode the event data as json into a RealTimeModel
            let decoded = try? self.decoder.decode(RealTimeLiveModel.self, from: jsonData)
            guard let data = decoded else {
                print("Could not decode message")
                return
            }
            
            self.isused = true
            
            if data.video_status == true {
                self.videoMuteButton.setImage(UIImage(named: "videoMuteButton"), for: .normal)
                self.agoraKit.muteLocalVideoStream(false)
                //localVideo.isHidden = true
                self.localVideoMutedBg.isHidden = false
                self.remoteVideoMutedIndicator.isHidden = false
            }else {
                self.videoMuteButton.setImage(UIImage(named: "videoMuteButtonSelected"), for: .selected)
                self.agoraKit.muteLocalVideoStream(true)
                //localVideo.isHidden = false
                
                self.localVideoMutedBg.isHidden = true
                self.remoteVideoMutedIndicator.isHidden = true
                    
            }
            
            
        })
        
    }
    
    private func listenToRaiseHandCall(auction_id: Int?, card_id: Int?) {
        
        print("auction_id: \(auction_id), card_id: \(card_id)")
        // Instantiate Pusher
        pusher3 = Pusher(
            key: "65b581feebecaee4af62",
            options: PusherClientOptions(host: .cluster("eu"))
        )
        
        // Subscribe to a pusher channel
        let channel = pusher3.subscribe("auction.\(auction_id ?? 0).\(card_id ?? 0)") //.\(card_id ?? 0)
        
        pusher3.delegate = self
        
        pusher3.connect()
        
        // Bind to an event called "order-event" on the event channel and fire
        // the callback when the event is triggerred
        
        
        let _ = channel.bind(eventName: "raise_Hand" , eventCallback: { [weak self] (event: PusherEvent) -> Void in
            
            guard let self = self else { return }
            
            print(event)
            
            // convert the data string to type data for decoding
            guard let json = event.data,
                  let jsonData = json.data(using: .utf8)
            else {
                print("Could not convert JSON string to data")
                return
            }
            
            print(json)
            print(jsonData)
            
            // decode the event data as json into a RealTimeModel
            let decoded = try? self.decoder.decode(RealTimeLiveModel.self, from: jsonData)
            guard let data = decoded else {
                print("Could not decode message")
                return
            }
            
            self.isused = true
            
            self.acceptRejectId = data.id
            self.acceptRejectRaiseHandView.isHidden = false
            self.acceptRaiseHandViewHeight.constant = 100
            
            self.requestedUserImage.loadImage(URLS.baseImageURL+(data.image ?? ""))
            self.requestedUserNameLable.text = data.name ?? ""
            
            self.getJoindData(id: self.card_id, userId: HelperConstant.getUserId())
            
        })
        
    }
    
    private func listenToChangesFromPusherUSD(auction_id: Int?, card_id: Int?) {
        
        print("auction_id: \(auction_id), card_id: \(card_id)")
        // Instantiate Pusher
        bidPusher = Pusher(
            key: "65b581feebecaee4af62",
            options: PusherClientOptions(host: .cluster("eu"))
        )
        
        // Subscribe to a pusher channel
        let channel = bidPusher.subscribe("auction.\(auction_id ?? 0).\(card_id ?? 0)")
        
        bidPusher.delegate = self
        
        bidPusher.connect()
        
        // Bind to an event called "order-event" on the event channel and fire
        // the callback when the event is triggerred
        
        let eventNamee = #"App\Events\ApiDataListener"#
        print("App\\Events\\ApiDataListener")
        
        print(eventNamee)
        
        let _ = channel.bind(eventName: "usd_bid" , eventCallback: { [weak self] (event: PusherEvent) -> Void in
            
            guard let self = self else { return }
            
            print(event)
            
            // convert the data string to type data for decoding
            guard let json = event.data,
                  let jsonData = json.data(using: .utf8)
            else {
                print("Could not convert JSON string to data")
                return
            }
            
            print(json)
            print(jsonData)
            
            // decode the event data as json into a RealTimeModel
            let decoded = try? self.decoder.decode(RealTimeModel.self, from: jsonData)
            guard let data = decoded else {
                print("Could not decode message")
                return
            }
            
            self.highPriceView.isHidden = false
            self.winHeighPriceHeight.constant = 70
            
            if Double(data.data?.offer?.price ?? "0.0") ?? 0.0 >= 1000.0 {
                self.plusMinusDescLabel.text = "The minimum increase is 50 dinars".localized
            }else {
                self.plusMinusDescLabel.text = "The minimum increase is 10 dinars".localized
            }
            
            self.bidLabel.text = "\(data.data?.offer?.minimumBidding ?? 0.0)"
            
            self.bidMaxPrice = data.data?.offer?.price ?? "0.0" //Double(data.data?.offer?.price ?? "0.0")
            
            self.priceLabel.text = "\(data.data?.offer?.price ?? "0.0")"
            //self.bidLabel.text = data.data?.price
            self.ownerUserImage.loadImage(URLS.baseImageURL+(data.data?.offer?.user?.image ?? ""))
            self.ownerNameLabel.text = data.data?.offer?.user?.name ?? ""
            //self.descTV.text = desc ?? ""
            
            print("\(data.data) says \(data.data)")
            
        })
        
    }
    private func listenToChangesFromPusher(auction_id: Int?, card_id: Int?) {
        
        print("auction_id: \(auction_id), card_id: \(card_id)")
        // Instantiate Pusher
        bidPusher = Pusher(
            key: "65b581feebecaee4af62",
            options: PusherClientOptions(host: .cluster("eu"))
        )
        
        // Subscribe to a pusher channel
        let channel = bidPusher.subscribe("auction.\(auction_id ?? 0).\(card_id ?? 0)")
        
        bidPusher.delegate = self
        
        bidPusher.connect()
        
        // Bind to an event called "order-event" on the event channel and fire
        // the callback when the event is triggerred
        
        let eventNamee = #"App\Events\ApiDataListener"#
        print("App\\Events\\ApiDataListener")
        
        print(eventNamee)
        
        let _ = channel.bind(eventName: "kwd_bid" , eventCallback: { [weak self] (event: PusherEvent) -> Void in
            
            guard let self = self else { return }
            
            print(event)
            
            // convert the data string to type data for decoding
            guard let json = event.data,
                  let jsonData = json.data(using: .utf8)
            else {
                print("Could not convert JSON string to data")
                return
            }
            
            print(json)
            print(jsonData)
            
            // decode the event data as json into a RealTimeModel
            let decoded = try? self.decoder.decode(RealTimeModel.self, from: jsonData)
            guard let data = decoded else {
                print("Could not decode message")
                return
            }
            
            self.highPriceView.isHidden = false
            self.winHeighPriceHeight.constant = 70
            
            if Double(data.data?.offer?.price ?? "0.0") ?? 0.0 >= 1000.0 {
                self.plusMinusDescLabel.text = "The minimum increase is 50 dinars".localized
            }else {
                self.plusMinusDescLabel.text = "The minimum increase is 10 dinars".localized
            }
            
            self.bidLabel.text = "\(data.data?.offer?.minimumBidding ?? 0.0)"
            
            self.bidMaxPrice = data.data?.offer?.price ?? "0.0" //Double(data.data?.offer?.price ?? "0.0")
            
            self.priceLabel.text = "\(data.data?.offer?.price ?? "0.0")"
            //self.bidLabel.text = data.data?.price
            self.ownerUserImage.loadImage(URLS.baseImageURL+(data.data?.offer?.user?.image ?? ""))
            self.ownerNameLabel.text = data.data?.offer?.user?.name ?? ""
            //self.descTV.text = desc ?? ""
            
            print("\(data.data) says \(data.data)")
            
        })
        
    }
    
    func checkForPermissions() -> Bool {
        var hasPermissions = false

        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: hasPermissions = true
            default: hasPermissions = requestCameraAccess()
        }
        // Break out, because camera permissions have been denied or restricted.
        if !hasPermissions { return false }
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
            case .authorized: hasPermissions = true
            default: hasPermissions = requestAudioAccess()
        }
        return hasPermissions
    }
    
    func requestCameraAccess() -> Bool {
        var hasCameraPermission = false
        let semaphore = DispatchSemaphore(value: 0)
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
            hasCameraPermission = granted
            semaphore.signal()
        })
        semaphore.wait()
        return hasCameraPermission
    }

    func requestAudioAccess() -> Bool {
        var hasAudioPermission = false
        let semaphore = DispatchSemaphore(value: 0)
        AVCaptureDevice.requestAccess(for: .audio, completionHandler: { granted in
            hasAudioPermission = granted
            semaphore.signal()
        })
        semaphore.wait()
        return hasAudioPermission
    }
    
    func initializeAgoraEngine() {
        let config = AgoraRtcEngineConfig()
        // Pass in your App ID here.
        config.appId = AppID
        // Use AgoraRtcEngineDelegate for the following delegate parameter.
        agoraKit = AgoraRtcEngineKit.sharedEngine(with: config, delegate: self)
        
    }
    
    func setupLocalVideo(id: UInt) {
        // Enable the video module
        //agoraKit.enableVideo()
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.renderMode = .fit //.hidden
        videoCanvas.view = remoteVideo
        agoraKit.setupLocalVideo(videoCanvas)
        
    }
    
    func setupRemoteVideo(id: UInt) {
        // Enable the video module
        //agoraKit.enableVideo()
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = id
        videoCanvas.renderMode = .fit //.hidden
        videoCanvas.view = remoteVideo
        agoraKit.setupRemoteVideo(videoCanvas)
    }
    
    // Tutorial Step 4
//    func setupLocalVideo() {
//        let videoCanvas = AgoraRtcVideoCanvas()
//        videoCanvas.uid = UInt(HelperConstant.getUserId() ?? 0)
//        videoCanvas.view = localVideo
//        videoCanvas.renderMode = .hidden
//        agoraKit.setupLocalVideo(videoCanvas)
//    }
    
    func showMessage(title: String, text: String, delay: Int = 2) -> Void {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        self.present(alert, animated: true)
        let deadlineTime = DispatchTime.now() + .seconds(delay)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            alert.dismiss(animated: true, completion: nil)
        })
    }
    
    func joinChannel(id : UInt) {
        if !self.checkForPermissions() {
            showMessage(title: "Error", text: "Permissions were not granted")
            return
        }
        
        // Set the client role option as broadcaster or audience.
        
//        if self.isOwnerOrnot == HelperConstant.getUserId() {
//            option.clientRoleType = .broadcaster
//
//           print("User")
//        }else{
//            option.clientRoleType = .audience
//            setupLocalVideo()
//            print("Owner")
//        }
        
        
        
        // For a video call scenario, set the channel profile as communication.
        //option.channelProfile = .communication

        // Join the channel with a temp token. Pass in your token and channel name here
        guard let call_id = channel , let token = token else { return }
        
//        // Set the client role option as broadcaster or audience.
//        let option = AgoraRtcChannelMediaOptions()
//
//        // Set the client role option as broadcaster or audience.
//        if self.userRole == .broadcaster {
//
//            option.clientRoleType = .broadcaster
//
//        } else {
//
//            option.clientRoleType = .audience
//
//        }
        
//        let result = agoraKit.joinChannel(
//
//            byToken: token, channelId: call_id, uid: id, mediaOptions: option,
//            joinSuccess: { (channel, uid, elapsed) in
//
//                //self.agoraKit.setEnableSpeakerphone(true)
//                UIApplication.shared.isIdleTimerDisabled = true
//
//            }
//        )
//            // Check if joining the channel was successful and set joined Bool accordingly
//        if (result == 0) {
//            joined = true
//            print("Successfully joined the channel as \(self.userRole)")
//            //showMessage(title: "Success", text: "Successfully joined the channel as \(self.userRole)")
//
//            //self.agoraKit.setEnableSpeakerphone(true)
//            UIApplication.shared.isIdleTimerDisabled = true
//
//        }
        
        agoraKit.joinChannel(byToken:token, channelId: call_id, info: nil, uid: id) { [weak self] (channel, uid, elapsed) -> Void in
            
            //self?.agoraKit.setEnableSpeakerphone(true)
            UIApplication.shared.isIdleTimerDisabled = true
            
        }
        
    }

    func leaveChannel() {
        //agoraKit.stopPreview()
        let result = agoraKit.leaveChannel(nil)
        // Check if leaving the channel was successful and set joined Bool accordingly
        if (result == 0) { joined = false }
    }
    
    
    // Tutorial Step 6
//    func leaveChannel() {
//        agoraKit.leaveChannel(nil)
//        hideControlButtons()
//        UIApplication.shared.isIdleTimerDisabled = false
//        //remoteVideo.removeFromSuperview()
//        //localVideo.removeFromSuperview()
//        //agoraKit = nil
////        (UIApplication.shared.delegate as? AppDelegate)?.cancelCall(action: {
////            self.navigationController?.popViewController(animated: true)
////        })
//    }
    
    // Tutorial Step 6
    func hideControlButtons() {
        controlButtons.isHidden = true
    }
    
    // Tutorial Step 6
    @IBAction func didClickHangUpButton(_ sender: UIButton) {
        leaveChannel()
        deleteUserAuctionVideo()
        self.navigationController?.popViewController(animated: true)
    }
    
//    // Tutorial Step 6
//    func resetHideButtonsTimer() {
//        VideoCallViewController.cancelPreviousPerformRequests(withTarget: self)
//        perform(#selector(hideControlButtons), with:nil, afterDelay:3)
//    }
    
    
    
    // Tutorial Step 7
    @IBAction func didClickMuteButton(_ sender: UIButton) {
        
        //sender.isSelected = !sender.isSelected
        //agoraKit.muteLocalAudioStream(sender.isSelected)
        
        //resetHideButtonsTimer()
        
        //sender.isSelected.toggle()
        
        print(muteMic)
        muteMic.toggle()
        print(muteMic)
        
        //self.agoraKit.muteLocalAudioStream(!muteMic)
        
//        if muteMic == true {
//
//            microphoneStatus(mic: "on") //"on" //off
//            agoraKit.muteLocalAudioStream(false)
//
//        }else {
//
//            microphoneStatus(mic: "off")
//            agoraKit.muteLocalAudioStream(true)
//
//        }
        
//        if sender.isSelected == true {
//            //agoraKit.muteLocalAudioStream(sender.isSelected)
//            microphoneStatus(mic: "on") //"on" //off
//            agoraKit.muteLocalAudioStream(false)
//        }else {
//            microphoneStatus(mic: "off")
//            agoraKit.muteLocalAudioStream(true)
//            //agoraKit.muteLocalAudioStream(sender.isSelected)
//        }
//
//        if sender.isSelected == true {
//            micMuteButton.setImage(UIImage(named: "muteButtonSelected"), for: .selected)
//        }else {
//            micMuteButton.setImage(UIImage(named: "muteButton"), for: .normal)
//        }
        
        
    }
    
    // Tutorial Step 8
    @IBAction func didClickVideoMuteButton(_ sender: UIButton) {
          
//        sender.isSelected = !sender.isSelected
//        agoraKit.muteLocalVideoStream(sender.isSelected)
//        localVideo.isHidden = sender.isSelected
//        localVideoMutedBg.isHidden = !sender.isSelected
//        localVideoMutedIndicator.isHidden = !sender.isSelected
        
        muteVideo.toggle()
        self.agoraKit.muteLocalVideoStream(muteVideo)
        
        
        
        //sender.isSelected.toggle()
        
//        if muteVideo == true {
//            //muteVideo = false
//            //videoMuteButton.setImage(UIImage(named: "videoMuteButton"), for: .normal)
//            //agoraKit.muteLocalVideoStream(true)
//            //localVideo.isHidden = true
//            localVideoMutedBg.isHidden = false
//            remoteVideoMutedIndicator.isHidden = false
//
//            videoStatus(status: "on")
//
//        }else {
//            //muteVideo = true
//            //videoMuteButton.setImage(UIImage(named: "videoMuteButtonSelected"), for: .selected)
//            //agoraKit.muteLocalVideoStream(false)
//            //localVideo.isHidden = false
//
//            localVideoMutedBg.isHidden = true
//            remoteVideoMutedIndicator.isHidden = true
//
//            videoStatus(status: "off")
//
//        }
        
        
        //resetHideButtonsTimer()
        
        //sender.isSelected.toggle()
        //agoraKit.setDefaultAudioRouteToSpeakerphone(true)
        
    }
    
    // Tutorial Step 9
    @IBAction func didClickSwitchCameraButton(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//        agoraKit.switchCamera()
//        resetHideButtonsTimer()
        
        sender.isSelected.toggle()
        agoraKit.switchCamera()
        
    }
    
    // Tutorial Step 10
    func hideVideoMuted() {
        remoteVideoMutedIndicator.isHidden = true
        localVideoMutedBg.isHidden = true
        localVideoMutedIndicator.isHidden = true
    }
    
//    // Tutorial Step 11
//    func setupButtons() {
//        perform(#selector(hideControlButtons), with:nil, afterDelay:3)
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(VideoCallViewController.viewTapped))
//        view.addGestureRecognizer(tapGestureRecognizer)
//        view.isUserInteractionEnabled = true
//    }
//
//    // Tutorial Step 11
//    func viewTapped() {
//        if (controlButtons.isHidden) {
//            controlButtons.isHidden = false;
//            perform(#selector(hideControlButtons), with:nil, afterDelay:3)
//        }
//    }
    
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
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        //section.orthogonalScrollingBehavior = .continuous
        
        // supplementary
        let hearderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: hearderSize, elementKind: "header", alignment: .top)
        //section.boundarySupplementaryItems = [header]
        
        return section
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addBidButtonAction(_ sender: Any) {
        performRequest()
    }
    
    @IBAction func partecipantButtonCollapseTapped(_ sender: Any) {
        
        if collapse == false {
            
            collapse = true
            partecipantViewHeight.constant = 100
            membersInLiveCollection.isHidden = true
            
        }else {
            
            collapse = false
            partecipantViewHeight.constant = 350
            membersInLiveCollection.isHidden = false
            
        }
        
    }
    
    @IBAction func VaccinationsTapped(_ sender: Any) {
        
        let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "CardVaccinationsViewController") as? CardVaccinationsViewController
        VC?.cardId = card_id
        navigationController?.pushViewController(VC!, animated: false)
        
    }
    @IBAction func ownersTapped(_ sender: Any) {
        
        let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "CardOwnersViewController") as? CardOwnersViewController
        VC?.cardId = card_id
        navigationController?.pushViewController(VC!, animated: false)
        
    }
    
    @IBAction func infoTapped(_ sender: Any) {
        
        let storyborad = UIStoryboard(name: "Auctions", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "CardInfoViewController") as? CardInfoViewController
        VC?.cardId = card_id
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
            plusMinusDescLabel.text = "The minimum increase is 50 dinars"
            let plus = (Int(bidLabel.text ?? "") ?? 0) + 50
            bidLabel.text = "\(plus)"
        }else {
            plusMinusDescLabel.text = "The minimum increase is 10 dinars"
            let plus = (Int(bidLabel.text ?? "") ?? 0) + 10
            bidLabel.text = "\(plus)"
        }
        
    }
    @IBAction func minusButtonAction(_ sender: Any) {
        
        
        
        let plus = (Int(bidLabel.text ?? "") ?? 0) - 10
        
        if (Int(bidLabel.text ?? "") ?? 0) <= 10 { //plus <= 0
            
        }else {
            
            if Double(self.bidMaxPrice ?? "0.0") ?? 0.0 >= 1000.0 {
                plusMinusDescLabel.text = "The minimum increase is 50 dinars"
                let plus = (Int(bidLabel.text ?? "") ?? 0) - 50
                bidLabel.text = "\(plus)"
            }else {
                plusMinusDescLabel.text = "The minimum increase is 10 dinars"
                let plus = (Int(bidLabel.text ?? "") ?? 0) - 10
                bidLabel.text = "\(plus)"
            }
            
            //bidLabel.text = "\(plus)"
            
        }
        
    }
    
    @IBAction func acceptButtonAction(_ sender: Any) {
        
        performUpdateStatusAgree(status: "agree")
        
    }
    
    @IBAction func rejectButtonOutlet(_ sender: Any) {
        
        performUpdateStatusDisagree(status: "disagree")
        
    }
    
    @IBAction func payDoneButtonOutlet(_ sender: Any) {
        
        performUpdateStatusPayDone(status: "confirm_payment_and_delivery")
        
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func timeString(time: TimeInterval) -> String {
        let hour = Int(time) / 3600
        let minute = Int(time) / 60 % 60
        let second = Int(time) % 60
        
        // return formated string
        return String(format: "%02i:%02i:%02i", hour, minute, second)
    }
    
}

extension LiveAuctionsDetailsViewController {
    
    //MARK:- SetUp startOtpTimer
    public func startOtpTimer() {
        
        self.totalTime = finalTotal
        
        self.timer2 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    //MARK:- SetUp updateTimer
    @objc func updateTimer() {
        
        print(self.totalTime)
        print(self.timeFormatted(self.totalTime))
        
        if self.totalTime <= 0 {
            self.timerLabel.text = "00 : 00 : 00"
            self.clockImage.image = UIImage(named: "asset-2")
            self.timer2?.invalidate()
            self.plusButtonOutlet.isEnabled = false
            self.minusButtonOutlet.isEnabled = false
            self.addBidButton.isHidden = true
            self.getLastOffer()
            
            self.acceptRejectView.isHidden = true
            self.controlButtons.isHidden = true
            self.sendRaiseHandViewOutlet.isHidden = true
            
            //self.agoraKit.muteLocalVideoStream(true)
            self.localVideoMutedBg.isHidden = false
            self.remoteVideoMutedIndicator.isHidden = false
            
            if self.conductedBy == "me" {
                
                if self.OwnerId == HelperConstant.getUserId() {
                    self.acceptedRejectedViewHeight.constant = 120
                    self.acceptRejectView.isHidden = false
                    self.acceptOfferLabel.isHidden = false
                    self.acceptButtonOutlet.isHidden = false
                    self.rejectButtonOutlet.isHidden = false
                    
                    self.getAuctionStatus()
                    
                    self.payDoneStack.isHidden = true
                    
                }else {
                    self.acceptedRejectedViewHeight.constant = 0
                    self.acceptRejectView.isHidden = true
                    self.acceptOfferLabel.isHidden = true
                    self.acceptButtonOutlet.isHidden = true
                    self.rejectButtonOutlet.isHidden = true
                }
                
            }else {
                if self.OwnerId == HelperConstant.getUserId() {
                    
                    self.acceptedRejectedViewHeight.constant = 120
                    self.acceptRejectView.isHidden = false
                    self.acceptOfferLabel.isHidden = false
                    self.acceptButtonOutlet.isHidden = false
                    self.rejectButtonOutlet.isHidden = false
                    
                    
                    self.payDoneStack.isHidden = true
                    
                }else {
                    
                    self.acceptedRejectedViewHeight.constant = 0
                    self.acceptRejectView.isHidden = true
                    self.acceptOfferLabel.isHidden = true
                    self.acceptButtonOutlet.isHidden = true
                    self.rejectButtonOutlet.isHidden = true
                    self.payDoneStack.isHidden = true
                    
                }
            }
            
//            if self.time ?? 0 <= self.currentTime ?? 0 {
//
//                if self.OwnerId == HelperConstant.getUserId() {
//                    self.acceptedRejectedViewHeight.constant = 250
//                    self.acceptRejectView.isHidden = false
//
//                    self.payDoneStack.isHidden = true
//
//                }else {
//                    self.acceptedRejectedViewHeight.constant = 0
//                    self.acceptRejectView.isHidden = true
//                }
//
//            }
            
            if self.lastOfferUserId == HelperConstant.getUserId() {
                self.winView.isHidden = false
                self.winHeighPriceHeight.constant = 120
            }else {
                self.winView.isHidden = true
                self.winHeighPriceHeight.constant = 70
            }
            
        }else if self.totalTime <= 2700 {
            
            self.timerLabel.labelFlash()//.labelPulsate()
            
            self.timerLabel.text = self.timeFormatted(self.totalTime)
            self.timerLabel.textColor = DesignSystem.Colors.PrimaryDarkRed.color
            self.clockImage.image = UIImage(named: "asset-2")
            totalTime -= 1
        }else {
            
            self.timerLabel.text = self.timeFormatted(self.totalTime) // will show timer
            self.timerLabel.textColor = DesignSystem.Colors.PrimaryBlack.color
            self.clockImage.image = UIImage(systemName: "clock.fill")
            
            totalTime -= 1
        }
        
    }
    //MARK:- SetUp timeFormatted
    func timeFormatted(_ totalSeconds: Int) -> String {
        
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        let hour: Int = totalSeconds / 3600
        
        return hour > 0 ? String(format: "%02d:%02d:%02d", hour, minutes, seconds) : String(format: "%02d:%02d", minutes, seconds)
        
    }
    
}

extension LiveAuctionsDetailsViewController: AgoraRtcEngineDelegate {
    // Tutorial Step 5
//    func rtcEngine(_ engine: AgoraRtcEngineKit!, firstRemoteVideoDecodedOfUid uid:UInt, size:CGSize, elapsed:Int) {
//        if (remoteVideo.isHidden) {
//            remoteVideo.isHidden = false
//        }
//        let videoCanvas = AgoraRtcVideoCanvas()
//        videoCanvas.uid = uid
//        videoCanvas.view = remoteVideo
//        videoCanvas.renderMode = .fill //.render_Adaptive
//        agoraKit.setupRemoteVideo(videoCanvas)
//    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        
//        if (remoteVideo.isHidden) {
//            remoteVideo.isHidden = false
//        }
//        let videoCanvas = AgoraRtcVideoCanvas()
//        videoCanvas.uid = uid
//        videoCanvas.view = remoteVideo
//        videoCanvas.renderMode = .fill //.render_Adaptive
//        agoraKit.setupRemoteVideo(videoCanvas)
        
        
//        let videoCanvas = AgoraRtcVideoCanvas()
//        videoCanvas.uid = uid
//        videoCanvas.renderMode = .hidden
//        videoCanvas.view = remoteVideo
//        agoraKit.setupRemoteVideo(videoCanvas)
        
    }
    
    // Tutorial Step 5
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid:UInt, reason:AgoraUserOfflineReason) {
        //self.leaveChannel()
        //self.remoteVideo.isHidden = true
    }
    
    // Tutorial Step 5
    func rtcEngine(_ engine: AgoraRtcEngineKit, didVideoMuted muted:Bool, byUid:UInt) {
//        remoteVideo.isHidden = muted
//        localVideoMutedBg.isHidden = !muted
//        remoteVideoMutedIndicator.isHidden = !muted
//        engine.muteLocalVideoStream(!muted)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        print(warningCode)
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        print(errorCode)
    }
    
}

extension LiveAuctionsDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AllRequsts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = membersInLiveCollection.dequeueReusableCell(withReuseIdentifier: "LiveMembersCollectionViewCell", for: indexPath) as? LiveMembersCollectionViewCell else { return UICollectionViewCell()}
        
        let item = AllRequsts[indexPath.row]
        
        cell.memberImage.loadImage(URLS.baseImageURL+(item.image ?? ""))
        
        cell.muteUmMuteImage.image = UIImage(named: "Group 52705")
        
        if item.isSpeaker == true {
            cell.muteUmMuteImage.image = UIImage(named: "Group 52704")
        }else {
            cell.muteUmMuteImage.image = UIImage(named: "Group 52705")
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = AllRequsts[indexPath.row]
        
        let storyborad = UIStoryboard(name: "HawyTabbar", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
        VC?.myProfile = false
        VC?.ownerId = item.id
        VC?.newName = item.name ?? ""
        VC?.newPhone = item.mobile ?? ""
        VC?.newImage = item.image ?? ""
        VC?.newCode = item.code ?? ""
        print(item.id)
        present(VC!, animated: true, completion: nil)
        
        
    }
    
}

extension LiveAuctionsDetailsViewController {
    
    func performUpdateStatusAgree(status: String?) { //url: String, parameters: [String:Any]
        
        let url = "https://hawy-kw.com/api/auctions/sales/status"
        
        let param: [String: Any] = [
            
            "card_id" : card_id ?? 0,
            "auction_id": auction_id ?? 0,
            "status": status ?? "" //bidLabel.text ?? ""
            
        ]
        
        print(param)
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator()
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers) // //URLEncoding.httpBody
            .validate(statusCode: 200...500)
        
            .responseJSON { response in
                
                print(param)
                print(headers)
                print(response)
                print(response.result)
                
                switch response.result {
                    
                case .success(let JSON):
                    
                    print("Validation Successful with response JSON \(JSON)")
                    
                    guard let data = response.data else { return }
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        let forgetPasswordRequest = try decoder.decode(AuctionAcceptRejectModelModel.self, from: data)
                        print(forgetPasswordRequest)
                        
                        if forgetPasswordRequest.code == 200 {
                            
                            print("success")
                            
                                self.acceptOfferLabel.text = "Offer accepted".localized
                                self.payDoneStack.isHidden = false
                                self.acceptRejectButtonsStack.isHidden = true
                                self.desc24HLabel.isHidden = false
                                
                                
                            
                            
                        }
                        if forgetPasswordRequest.message == "Unauthenticated." {
                            
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
                    } catch let error {
                        self.hideIndecator()
                        print(error)
                        
                    }
                    
                case .failure(let error):
                    
                    print("Request failed with error \(error)")
                    
                }
                
            }
        
    }
    
    func performUpdateStatusDisagree(status: String?) { //url: String, parameters: [String:Any]
        
        let url = "https://hawy-kw.com/api/auctions/sales/status"
        
        let param: [String: Any] = [
            
            "card_id" : card_id ?? 0,
            "auction_id": auction_id ?? 0,
            "status": status ?? "" //bidLabel.text ?? ""
            
        ]
        
        print(param)
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator()
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers) // //URLEncoding.httpBody
            .validate(statusCode: 200...500)
        
            .responseJSON { response in
                
                print(param)
                print(headers)
                print(response)
                print(response.result)
                
                switch response.result {
                    
                case .success(let JSON):
                    
                    print("Validation Successful with response JSON \(JSON)")
                    
                    guard let data = response.data else { return }
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        let forgetPasswordRequest = try decoder.decode(AuctionAcceptRejectModelModel.self, from: data)
                        print(forgetPasswordRequest)
                        
                        if forgetPasswordRequest.code == 200 {
                            
                            print("success")
                            
                                self.acceptOfferLabel.text = "Offer rejected".localized
                                self.desc24HLabel.isHidden = true
                                self.payDoneStack.isHidden = true
                                self.acceptRejectButtonsStack.isHidden = true
                            self.acceptedRejectedViewHeight.constant = 40
                            
                            
                        }
                        
                        if forgetPasswordRequest.message == "Unauthenticated." {
                            
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
                    } catch let error {
                        self.hideIndecator()
                        print(error)
                        
                    }
                    
                case .failure(let error):
                    
                    print("Request failed with error \(error)")
                    
                }
                
            }
        
    }
    
    func performUpdateStatusPayDone(status: String?) { //url: String, parameters: [String:Any]
        
        let url = "https://hawy-kw.com/api/auctions/sales/status"
        
        let param: [String: Any] = [
            
            "card_id" : card_id ?? 0,
            "auction_id": auction_id ?? 0,
            "status": status ?? "" //bidLabel.text ?? ""
            
        ]
        
        print(param)
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator()
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers) // //URLEncoding.httpBody
            .validate(statusCode: 200...500)
        
            .responseJSON { response in
                
                print(param)
                print(headers)
                print(response)
                print(response.result)
                
                switch response.result {
                    
                case .success(let JSON):
                    
                    print("Validation Successful with response JSON \(JSON)")
                    
                    guard let data = response.data else { return }
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        let forgetPasswordRequest = try decoder.decode(AuctionAcceptRejectModelModel.self, from: data)
                        print(forgetPasswordRequest)
                        
                        if forgetPasswordRequest.code == 200 {
                            
                            print("success")
                            
                                self.acceptOfferLabel.text = "Pay Done".localized
                                self.desc24HLabel.isHidden = true
                                self.payDoneStack.isHidden = true
                                self.acceptRejectButtonsStack.isHidden = true
                            
                            
                        }
                        
                        if forgetPasswordRequest.message == "Unauthenticated." {
                            
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
                    } catch let error {
                        self.hideIndecator()
                        print(error)
                        
                    }
                    
                case .failure(let error):
                    
                    print("Request failed with error \(error)")
                    
                }
                
            }
        
    }
    
    func getAuctionStatus() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/auctions/sales/getStatus?auction_id=\(auction_id ?? 0)&card_id=\(card_id ?? 0)", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(AuctionStatusModel.self, from: response.data!)
                
                if productResponse.code == 200 {
                    self.acceptRejectView.isHidden = false
                    if productResponse.item?.status == "pending" {
                        self.acceptOfferLabel.text = "You want to accept offer?".localized
                        self.payDoneStack.isHidden = true
                        self.desc24HLabel.isHidden = true
                        self.acceptRejectButtonsStack.isHidden = false
                        self.self.acceptedRejectedViewHeight.constant = 120
                        
                        self.acceptOfferLabel.isHidden = false
                        self.acceptButtonOutlet.isHidden = false
                        self.rejectButtonOutlet.isHidden = false
                        
                    }else if productResponse.item?.status == "agree" {
                        
                        self.acceptOfferLabel.text = "Offer accepted".localized
                        self.desc24HLabel.isHidden = false
                        self.payDoneButtonOutlet.isHidden = false
                        self.payDoneStack.isHidden = false
                        self.acceptRejectButtonsStack.isHidden = true
                        self.acceptedRejectedViewHeight.constant = 120
                        
                    }else if productResponse.item?.status == "disagree" {
                        
                        self.acceptOfferLabel.text = "Offer rejected".localized
                        self.desc24HLabel.isHidden = true
                        self.payDoneStack.isHidden = true
                        self.acceptRejectButtonsStack.isHidden = true
                        self.acceptedRejectedViewHeight.constant = 40
                        
                    }else {
                        self.acceptOfferLabel.isHidden = true
                        self.payDoneStack.isHidden = true
                        self.desc24HLabel.isHidden = true
                        self.acceptRejectButtonsStack.isHidden = true
                    }
                    
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
    
    func getLastOffer() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/auctions/sales/lastoffer?auction_id=\(auction_id ?? 0)&card_id=\(card_id ?? 0)", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(BidModel.self, from: response.data!)
                
                if productResponse.code == 200 {
                    //self.highPriceView.isHidden = false
                    
                    if Double(productResponse.item?.offer?.price ?? "0.0") ?? 0.0 >= 1000.0 {
                        self.plusMinusDescLabel.text = "The minimum increase is 50 dinars".localized
                    }else {
                        self.plusMinusDescLabel.text = "The minimum increase is 10 dinars".localized
                    }
                    
                    self.bidMaxPrice = productResponse.item?.offer?.price ?? "0.0" //Double(productResponse.item?.offer?.price ?? "0.0")
                    
                    //self.priceLabel.text = "\(productResponse.item?.offer?.price ?? "0.0")"
                    
                    if productResponse.item?.offer != nil {
                        
                        self.priceLabel.text = "\(productResponse.item?.offer?.price ?? "0.0")"
                        print(productResponse.item?.offer?.price ?? "0.0")
                        //self.bidLabel.text = data.data?.price
                        self.ownerUserImage.loadImage(URLS.baseImageURL+(productResponse.item?.offer?.user?.image ?? ""))
                        self.ownerNameLabel.text = productResponse.item?.offer?.user?.name ?? ""
                        
                        self.bidLabel.text = "\(productResponse.item?.minimumBiding ?? 0)"
                        
                    }
                    
                    
                    
                    self.lastOfferUserId = productResponse.item?.offer?.user?.id
                    
                    //self.getUserBid()
                    
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
    
    func getUserBid() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator() //?user_id=20 //https://hawy-kw.com/api/users/bids?auction_id=10&card_id=3&user_id=20
        AF.request("https://hawy-kw.com/api/users/bids?auction_id=\(auction_id ?? 0)&card_id=\(card_id ?? 0)&user_id=\(HelperConstant.getUserId() ?? 0)", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(ISUserBidModel.self, from: response.data!)
                
                if productResponse.code == 200 {
                    //self.highPriceView.isHidden = false
                    
//                    if productResponse.item == nil {
//
//                        self.yourLucklabel.isHidden = true
//                        self.yourLuckImage.isHidden = true
//
//                    }else {
//                        if productResponse.item?.user?.id == HelperConstant.getUserId() {
//                            self.yourLucklabel.text = "You seem to be the luckiest person to win the auction so far".localized
//                            self.yourLuckImage.isHidden = false
//
//
//                        }else {
//                            self.yourLucklabel.text = "Looks like you won't win the auction".localized
//                            self.yourLuckImage.isHidden = true
//                        }
//                    }
                    
                    
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
    
    func performRequest() { //url: String, parameters: [String:Any]
        
        let url = "https://hawy-kw.com/api/bid"
        
        let param: [String: Any] = [
            
            "card_id" : card_id ?? 0,
            "auction_id": auction_id ?? 0,
            "price": bidLabel.text ?? "",
            "bid_time": Int(Date.currentTimeStamp)
            
        ]
        
        print(param)
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator()
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers) // //URLEncoding.httpBody
            .validate(statusCode: 200...500)
        
            .responseJSON { response in
                
                print(param)
                print(headers)
                print(response)
                print(response.result)
                
                switch response.result {
                    
                case .success(let JSON):
                    
                    print("Validation Successful with response JSON \(JSON)")
                    
                    guard let data = response.data else { return }
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        let forgetPasswordRequest = try decoder.decode(BidModel.self, from: data)
                        print(forgetPasswordRequest)
                        
                        if forgetPasswordRequest.code == 200 {
                            
                            print("success")
                            
                            self.bidLabel.text = "\(forgetPasswordRequest.item?.minimumBiding ?? 0)"
                            
                            self.priceLabel.text = "\(forgetPasswordRequest.item?.offer?.price ?? "0.0")"
                            self.priceLabel.text = "\(forgetPasswordRequest.item?.offer?.price ?? "0.0")"
                            //self.bidLabel.text = data.data?.price
                            self.ownerUserImage.loadImage(URLS.baseImageURL+(forgetPasswordRequest.item?.offer?.user?.image ?? ""))
                            self.ownerNameLabel.text = forgetPasswordRequest.item?.offer?.user?.name ?? ""
                            
                        }
                        
                        if forgetPasswordRequest.message == "Unauthenticated." {
                            
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
                    } catch let error {
                        self.hideIndecator()
                        print(error)
                        
                    }
                    
                case .failure(let error):
                    
                    print("Request failed with error \(error)")
                    
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
        AF.request("https://hawy-kw.com/api/auth/profile/cards/show?id=\(id ?? 0)&user_id=\(userId ?? 0)&auction_id=\(auction_id ?? 0)", method: .get, parameters: nil, headers: headers)
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
                    
                    self.OwnerId = productResponse.item?.owner?.id
                    self.conductorId = productResponse.item?.conductor?.id
                    self.conductedBy = productResponse.item?.conducted_by
                    
                    self.noteTV.text = productResponse.item?.notes ?? ""
                    self.animalName.text =  productResponse.item?.name ?? ""
                    self.fatherName.text =  productResponse.item?.fatherName ?? ""
                    self.motherName.text =  productResponse.item?.motherName ?? ""
                    
                    if productResponse.item?.conducted_by == "admin" {
                        
                        if productResponse.item?.conductor == nil {
                            
                            self.localVideoMutedBg.isHidden = false
                            self.remoteVideoMutedIndicator.isHidden = false
                            self.controlButtons.isHidden = true
                            
                        }else {
                            
                            self.localVideoMutedBg.isHidden = true
                            self.remoteVideoMutedIndicator.isHidden = true
                            self.controlButtons.isHidden = false
                            
                        }
                        
                    }else {
                        
                        self.localVideoMutedBg.isHidden = true
                        self.remoteVideoMutedIndicator.isHidden = true
                        self.controlButtons.isHidden = false
                        
                    }
                    
                    if productResponse.item?.owner?.id == HelperConstant.getUserId() {
                        
                        self.addBidViewOutlet.isHidden = true
                        self.addBidViewHeight.constant = 0
                        self.sendRaiseHandViewOutlet.isHidden = true //
                        self.listenToRaiseHandCall(auction_id: self.auction_id, card_id: self.card_id)
                        
                    }else {
                        
                        self.addBidViewOutlet.isHidden = false
                        self.addBidViewHeight.constant = 230
                        self.sendRaiseHandViewOutlet.isHidden = false
                        self.listenToAdminRaiseHandCall(auction_id: self.auction_id, card_id: self.card_id)
                        self.listenToAdminVideoStatusCall(auction_id: self.auction_id, card_id: self.card_id)
                        
                    }
                    
                    
                    
                    if productResponse.item?.bidCounter == 0 {
                        
                        self.highPriceView.isHidden = false
                        self.winHeighPriceHeight.constant = 70
                        
                        self.currencyLabel.text = HelperConstant.getCurrency() ?? "KWD"
                        self.priceLabel.text = "\(productResponse.item?.price ?? "0.0")"
                        self.ownerUserImage.loadImage(URLS.baseImageURL+(productResponse.item?.owner?.image ?? ""))
                        self.ownerNameLabel.text = productResponse.item?.owner?.name ?? ""
                        
                    }else {
                        
                        self.highPriceView.isHidden = false
                        self.winHeighPriceHeight.constant = 70
                        
                        self.getLastOffer()
                    }
                    
                    self.bidMaxPrice = productResponse.item?.bid_max_price
                    
                    if Double(self.bidMaxPrice ?? "0.0") ?? 0.0 >= 1000.0 {
                        self.plusMinusDescLabel.text = "The minimum increase is 50 dinars"
                    }else {
                        self.plusMinusDescLabel.text = "The minimum increase is 10 dinars"
                    }
                    
                    self.time = (productResponse.item?.endDate ?? 0)// * 1000
                    self.currentTime = Int(Date.currentTimeStamp)
                    
                    self.timerLabel.text = self.timeString(time: TimeInterval(productResponse.item?.endDate ?? 0 * 1000))
                    let finalTimeStamp = (self.time ?? 0) - (self.currentTime ?? 0)
                    self.finalTotal = finalTimeStamp
                    let (h, m, s) = self.secondsToHoursMinutesSeconds(finalTimeStamp)
                      print ("\(h) Hours, \(m) Minutes, \(s) Seconds")
                    //self.timerLabel.text = "\(h) : \(m) : \(s)"
                    
                    if productResponse.item?.owner?.id == HelperConstant.getUserId() {
                        
                        self.videoMuteButton.isHidden = false
                        self.switchCameraButton.isHidden = false
                        
                    }else {
                        
                        self.videoMuteButton.isHidden = true
                        self.switchCameraButton.isHidden = true
                        
                    }
                    
                    
//                    if productResponse.item?.conductor_available == true {
//
//                        self.addBidViewOutlet.isHidden = false
//                        self.addBidViewHeight.constant = 230
//                        self.sendRaiseHandViewOutlet.isHidden = false
//
//                    }else {
//
//                        self.addBidViewOutlet.isHidden = true
//                        self.addBidViewHeight.constant = 0
//                        self.sendRaiseHandViewOutlet.isHidden = true
//
//                    }
                    
                    
                    if self.time ?? 0 <= self.currentTime ?? 0 {
                        
//                        if productResponse.item?.owner?.id == HelperConstant.getUserId() {
//                            self.acceptedRejectedViewHeight.constant = 250
//                            self.acceptRejectView.isHidden = false
//
//                            self.payDoneStack.isHidden = true
//
//                        }else {
//                            self.acceptedRejectedViewHeight.constant = 0
//                            self.acceptRejectView.isHidden = true
//                        }
                        
                        //self.agoraKit.muteLocalVideoStream(true)
                        //localVideo.isHidden = true
                        self.localVideoMutedBg.isHidden = false
                        self.remoteVideoMutedIndicator.isHidden = false
                        self.controlButtons.isHidden = true
                        
                        
                        
                        if productResponse.item?.conducted_by == "me" {
                            
                            if productResponse.item?.owner?.id == HelperConstant.getUserId() {
                                self.acceptedRejectedViewHeight.constant = 120
                                self.acceptRejectView.isHidden = false
                                self.acceptOfferLabel.isHidden = false
                                self.acceptButtonOutlet.isHidden = false
                                self.rejectButtonOutlet.isHidden = false
                                
                                self.payDoneStack.isHidden = true
                                
                            }else {
                                self.acceptedRejectedViewHeight.constant = 0
                                self.acceptRejectView.isHidden = true
                            }
                            
                        }else {
                            if productResponse.item?.owner?.id == HelperConstant.getUserId() {
                                
                                self.acceptedRejectedViewHeight.constant = 0 // 120
                                self.acceptRejectView.isHidden = true
                                self.acceptOfferLabel.isHidden = true
                                self.acceptButtonOutlet.isHidden = true
                                self.rejectButtonOutlet.isHidden = true
                                
                                self.payDoneStack.isHidden = true
                                
                            }else {
                                
                                self.acceptedRejectedViewHeight.constant = 0
                                self.acceptRejectView.isHidden = true
                                self.payDoneStack.isHidden = true
                                
                            }
                        }
                        
                    }
                    
                    self.startOtpTimer()
                    self.timerLabel.textColor = DesignSystem.Colors.PrimaryBlack.color
                    self.clockImage.image = UIImage(systemName: "clock.fill")
                    
                    self.getJoindData(id: self.card_id, userId: HelperConstant.getUserId())
                    
                }
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    func getJoindData(id: Int?, userId: Int?) {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/auth/profile/cards/show?id=\(id ?? 0)?user_id=\(userId ?? 0)", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(ShowCardDetailsModel.self, from: response.data!)
                
                if productResponse.code == 200 {
                    print("success")
                    
                    self.AllRequsts = productResponse.item?.joinedUsers ?? []
                    self.membersCountLabel.text = "\(self.AllRequsts.count)"
                    self.membersInLiveCollection.reloadData()
                    
//                    if self.conductedBy == "me" {
//
//                        for i in productResponse.item?.joinedUsers ?? [] {
//
//                            if HelperConstant.getUserId() == i.id {
//
//                                self.addBidViewOutlet.isHidden = false
//                                self.addBidViewHeight.constant = 230
//                                self.sendRaiseHandViewOutlet.isHidden = false
//
//                            }else {
//
//                                self.addBidViewOutlet.isHidden = true
//                                self.addBidViewHeight.constant = 0
//                                self.sendRaiseHandViewOutlet.isHidden = true
//
//                            }
//
//                        }
//
//                    }else {
//
//                        for i in productResponse.item?.joinedUsers ?? [] {
//
//                            if self.conductorId == i.id {
//
//                                self.addBidViewOutlet.isHidden = false
//                                self.addBidViewHeight.constant = 230
//                                self.sendRaiseHandViewOutlet.isHidden = false
//
//                            }else {
//
//                                self.addBidViewOutlet.isHidden = true
//                                self.addBidViewHeight.constant = 0
//                                self.sendRaiseHandViewOutlet.isHidden = true
//
//                            }
//
//                        }
//
//                    }
                    if self.conductedBy == "me" {
                        
                        if self.OwnerId != HelperConstant.getUserId() {

                            for i in productResponse.item?.joinedUsers ?? [] {

                                if i.id == self.conductorId {

                                    self.addBidViewOutlet.isHidden = false
                                    self.addBidViewHeight.constant = 230
                                    self.sendRaiseHandViewOutlet.isHidden = true

                                }else {

                                    self.addBidViewOutlet.isHidden = true
                                    self.addBidViewHeight.constant = 0
                                    self.sendRaiseHandViewOutlet.isHidden = false //

                                }

                            }

                        }else {

                            for i in productResponse.item?.joinedUsers ?? [] {

                                if i.id != self.conductorId {

                                    self.addBidViewOutlet.isHidden = true
                                    self.addBidViewHeight.constant = 0
                                    self.sendRaiseHandViewOutlet.isHidden = true //

                                }
    //                            else {
    //
    //                                self.addBidViewOutlet.isHidden = true
    //                                self.addBidViewHeight.constant = 0
    //                                self.sendRaiseHandViewOutlet.isHidden = true
    //
    //                            }

                            }

                            self.addBidViewOutlet.isHidden = true
                            self.addBidViewHeight.constant = 0
                            self.sendRaiseHandViewOutlet.isHidden = true //

                        }
                        
                    }else {
                        
                        for i in productResponse.item?.joinedUsers ?? [] {
                            
                            if self.conductorId == i.id {
                                
                                self.addBidViewOutlet.isHidden = false
                                self.addBidViewHeight.constant = 230
                                self.sendRaiseHandViewOutlet.isHidden = true
                                
                            }else {
                                
                                self.addBidViewOutlet.isHidden = true
                                self.addBidViewHeight.constant = 0
                                self.sendRaiseHandViewOutlet.isHidden = false //
                                
                            }
                            
                        }
                        
                    }
                    
                    
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
                   // alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    //
    func videoCallToken(auction_id: Int?, card_id: Int?) {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator() //
        AF.request("https://hawy-kw.com/api/auctions/live/videoCall/token?auction_id=\(auction_id ?? 0)&card_id=\(card_id ?? 0)", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(VideoTokenModel.self, from: response.data!)
                
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
                    
                    print(productResponse.item)
                    self.token = productResponse.item?.token
                    self.channel = productResponse.item?.channelName
                    self.currentUserId = UInt(productResponse.item?.currentUser?.id ?? 0)
                    self.isOwnerOrnot = productResponse.item?.owner?.id ?? 0
                    
                   // var finalId: UInt = 0
                    print(self.token)
                    print(self.channel)
                    print(self.currentUserId)
                    print(self.isOwnerOrnot)
                    
                    self.initializeAgoraEngine()
                    
                    self.agoraKit.setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(size: AgoraVideoDimension640x480, frameRate: .fps15, bitrate: AgoraVideoBitrateStandard, orientationMode: .fixedPortrait, mirrorMode: .disabled)) //disabled
                    
                    if productResponse.item?.owner?.id ?? 0 == productResponse.item?.currentUser?.id ?? 0 {
                        //self.userRole = .broadcaster
                        self.agoraKit.setClientRole(.broadcaster)
                    }else {
                        //self.userRole = .audience
                        self.agoraKit.setClientRole(.audience)
                    }
                    
                    //self.agoraKit.setChannelProfile(.communication)
                    self.agoraKit.enableVideo()
                    
                    if productResponse.item?.owner?.id ?? 0 == productResponse.item?.currentUser?.id ?? 0 {
                        self.agoraKit.enableLocalVideo(true)
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//                            self.agoraKit.switchCamera()
//                        })
                        
                        //self.agoraKit.muteLocalAudioStream(!(productResponse.item?.currentUser?.isSpeaker ?? false))
                        
                        //self.agoraKit.muteLocalVideoStream(!(productResponse.item?.currentUser?.video_status ?? false))
                        
                    }else {
                        
                        self.agoraKit.enableLocalVideo(false)
                        
                        //self.agoraKit.muteLocalAudioStream(!(productResponse.item?.owner?.isSpeaker ?? false))
                        
                        //self.agoraKit.muteLocalVideoStream(!(productResponse.item?.owner?.video_status ?? false))
                        
                    }
                    
                    self.muteVideo = !(productResponse.item?.currentUser?.video_status ?? false)
                    self.muteMic = !(productResponse.item?.currentUser?.isSpeaker ?? false)
                    
                    self.agoraKit.muteLocalAudioStream(!(productResponse.item?.currentUser?.isSpeaker ?? false))
                    self.agoraKit.muteLocalVideoStream(!(productResponse.item?.currentUser?.video_status ?? false))
                    
                    if productResponse.item?.owner?.id ?? 0 == productResponse.item?.currentUser?.id ?? 0 {
                        self.setupLocalVideo(id: UInt(productResponse.item?.owner?.id ?? 0))
                    }else {
                        self.setupRemoteVideo(id: UInt(productResponse.item?.owner?.id ?? 0))
                    }
                    
                    
                    self.joinChannel(id: UInt(productResponse.item?.currentUser?.id ?? 0))
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.agoraKit.switchCamera()
                    })
                    
                    if productResponse.item?.owner?.id ?? 0 == productResponse.item?.currentUser?.id ?? 0 {
                        self.micMuteButton.isHidden = false
                    }else {
                        
                        if productResponse.item?.currentUser?.raiseHand == true {
                            self.micMuteButton.isHidden = false
                        }
                        
                    }
                    
                    //self.microphoneStatus(mic: "off")
                    
                    //self.agoraKit.muteLocalAudioStream(true)
                    
                    //self.joinChannel(id: finalId) //HelperConstant.getUserId() ?? 0
                    
                    //self.initializeAgoraEngine()     // Tutorial Step 1
                    //self.joinChannel(id: self.currentUserId ?? 0)
                    //self.setupVideo()                // Tutorial Step 2
                    //self.joinChannel(id: self.currentUserId ?? 0)               // Tutorial Step 3
                    //self.setupLocalVideo()           // Tutorial Step 4
                    
                    //self.hideVideoMuted()            // Tutorial Step 10
                    //setupButtons()            // Tutorial Step 11
                    
                }
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    func JoinUserAuctionVideo() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        let param : [String: Any] = [
            
            "auction_id" : auction_id ?? 0,
            "card_id" : card_id ?? 0
            
        ]
        
        showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/auctions/live/videoCall/user/join", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(AddUserToAuctionVideoModel.self, from: response.data!)
                
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
                   // alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                if productResponse.code == 200 {
                    print("success")
                    
                    self.videoCallToken(auction_id: self.auction_id, card_id: self.card_id)
                    
                    self.listenToJoinVideoCall(auction_id: self.auction_id, card_id: self.card_id)
                    
                    self.getJoindData(id: self.card_id, userId: HelperConstant.getUserId())
                    
                }else{
                    ToastManager.shared.showError(message: productResponse.message ?? "", view: self.view)
                }
                
                
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    func deleteUserAuctionVideo() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        let param : [String: Any] = [
            
            "auction_id" : auction_id ?? 0,
            "card_id" : card_id ?? 0
            
        ]
        
        showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/auctions/live/videoCall/user/out", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(AddUserToAuctionVideoModel.self, from: response.data!)
                
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
                    
                    self.getJoindData(id: self.card_id, userId: HelperConstant.getUserId())
                    
                }else{
                    ToastManager.shared.showError(message: productResponse.message ?? "", view: self.view)
                }
                
                
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    func raiseHand() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        let param : [String: Any] = [
            
            "auction_id" : auction_id ?? 0,
            "card_id" : card_id ?? 0
            
        ]
        
        showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/auctions/live/videoCall/user/raiseHand", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(AddUserToAuctionVideoModel.self, from: response.data!)
                
                
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
                    
                    self.acceptRejectId = productResponse.item?.id //data.data?.id
                    print(self.acceptRejectId)
                    
                }else{
                    ToastManager.shared.showError(message: productResponse.message ?? "", view: self.view)
                }
                
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    //
    func raiseHandRequests(auction_id: Int?, card_id: Int?) {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator() //
        AF.request("https://hawy-kw.com/api/auctions/live/videoCall/user/raiseHandRequests?auction_id=\(auction_id ?? 0)&card_id=\(card_id ?? 0)", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(AllRaiseRequestsVideoModel.self, from: response.data!)
                
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
                    
                    //self.AllRequsts = productResponse.item ?? []
                    //self.membersCountLabel.text = "\(self.AllRequsts.count)"
                    //self.membersInLiveCollection.reloadData()
                    
                }
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    //
    func raiseHandStatus(status: String?) {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        let param : [String: Any] = [
            
            "auction_id" : auction_id ?? 0,
            "card_id" : card_id ?? 0,
            "status" : status ?? "", //"accept", //reject
            "user_id" : acceptRejectId ?? 0
        ]
        
        showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/auctions/live/videoCall/user/raiseHand/status", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(AddUserToAuctionVideoModel.self, from: response.data!)
                
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
                    
                    self.getJoindData(id: self.card_id, userId: HelperConstant.getUserId())
                    //self.raiseHandRequests(auction_id: self.auction_id, card_id: self.card_id)
                    
                    self.acceptRejectRaiseHandView.isHidden = true
                    self.acceptRaiseHandViewHeight.constant = 0
                    
                    
                }else{
                    ToastManager.shared.showError(message: productResponse.message ?? "", view: self.view)
                }
                
                
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    //
    func microphoneStatus(mic: String) {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        let param : [String: Any] = [
            
            "auction_id" : auction_id ?? 0,
            "card_id" : card_id ?? 0,
            "mic" : mic //"on" //off
        ]
        
        showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/auctions/live/videoCall/user/microphone", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(AddUserToAuctionVideoModel.self, from: response.data!)
                
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
                    
                    
                    
                    self.getJoindData(id: self.card_id, userId: HelperConstant.getUserId())
                    
                }else{
                    ToastManager.shared.showError(message: productResponse.message ?? "", view: self.view)
                }
                
                
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    
    func videoStatus(status: String) {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        let param : [String: Any] = [
            
            "auction_id" : auction_id ?? 0,
            "card_id" : card_id ?? 0,
            "video_status" : status //"on" //off
        ]
        
        showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/auctions/live/videoCall/user/videoStatus", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(AddUserToAuctionVideoModel.self, from: response.data!)
                
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
                    
                    self.getJoindData(id: self.card_id, userId: HelperConstant.getUserId())
                    
                }else{
                    ToastManager.shared.showError(message: productResponse.message ?? "", view: self.view)
                }
                
                
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
}


