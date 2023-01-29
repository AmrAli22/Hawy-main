//
//  AuctionLiveVideo+PusherEvents.swift
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

extension AuctionLiveVideo : PusherDelegate {
    
     func listenToChangesFromPusherTime(auction_id: Int?, card_id: Int?) {
        
        print("auction_id: \(auction_id), card_id: \(card_id)")
        // Instantiate Pusher
        pusherTime = Pusher(
            key: "65b581feebecaee4af62",
            options: PusherClientOptions(host: .cluster("eu"))
        )
        
        // Subscribe to a pusher channel
        let channel = pusherTime.subscribe("auction.\(auction_id ?? 0).\(cardID ?? 0)")
         print("channelchanne\("auction.\(auction_id ?? 0).\(cardID ?? 0)")")
        
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
            //self.startOtpTimer()
            
        })
        
    }
    
     func listenToJoinVideoCall(auction_id: Int?, card_id: Int?) {
        
        print("auction_id: \(auction_id), card_id: \(card_id)")
        // Instantiate Pusher
        pusher = Pusher(
            key: "65b581feebecaee4af62",
            options: PusherClientOptions(host: .cluster("eu"))
        )
        
        // Subscribe to a pusher channel
        let channel = pusher.subscribe("auction.\(auction_id ?? 0).\(cardID ?? 0)") //.\(card_id ?? 0)
         print("channelchanne\("auction.\(auction_id ?? 0).\(cardID ?? 0)")")
        pusher.delegate = self
        pusher.connect()

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
            
            //self.getJoindData(id: self.card_id, userId: HelperConstant.getUserId())
            self.getParticipants(id: auction_id)
            
        })
        
    }
    
     func listenToOutVideoCall(auction_id: Int?, card_id: Int?) {
        
        print("auction_id: \(auction_id), card_id: \(card_id)")
        // Instantiate Pusher
        pusher = Pusher(
            key: "65b581feebecaee4af62",
            options: PusherClientOptions(host: .cluster("eu"))
        )
        
        // Subscribe to a pusher channel
        let channel = pusher.subscribe("auction.\(auction_id ?? 0).\(cardID ?? 0)") //.\(card_id ?? 0)
         print("channelchanne\("auction.\(auction_id ?? 0).\(cardID ?? 0)")")
        pusher.delegate = self
        
        pusher.connect()
      
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
            //self.getJoindData(id: self.card_id, userId: HelperConstant.getUserId())
            
            if self.iamConductor {
                
            }else{
                if decoded?.video_status == false {
                    self.remoteVideoMutedIndicator.isHidden = false
                    self.remoteView.isHidden = false
                }else{
                    self.remoteVideoMutedIndicator.isHidden = true
                    self.remoteView.isHidden = false
                }
                self.getParticipants(id: auction_id)
            }
            
       
            
        })
        
    }
    
     func listenToMicCall(auction_id: Int?, card_id: Int?) {
        
        print("auction_id: \(auction_id), card_id: \(card_id)")
        // Instantiate Pusher
        pusher4 = Pusher(
            key: "65b581feebecaee4af62",
            options: PusherClientOptions(host: .cluster("eu"))
        )
        
        // Subscribe to a pusher channel
        let channel = pusher4.subscribe("auction.\(auction_id ?? 0).\(cardID ?? 0)") //
        
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
            self.getParticipants(id: auction_id)
        })
        
    }
    
     func listenToAdminRaiseHandCall(auction_id: Int?, card_id: Int?) {
        
        print("auction_id: \(auction_id ?? 0), card_id: \(card_id)")
        // Instantiate Pusher
        pusher6 = Pusher(
            key: "65b581feebecaee4af62",
            options: PusherClientOptions(host: .cluster("eu"))
        )
        
        // Subscribe to a pusher channel
        let channel = pusher6.subscribe("auction.\(auction_id ?? 0).\(cardID ?? 0)") //.\(card_id ?? 0)
         print("channelchanne\("auction.\(auction_id ?? 0).\(cardID ?? 0)")")
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
            
            if self.userRole == .audience {
                if data.raiseHand == true {
                    self.micMuteButton.isHidden = false
                    self.sendRaiseHandView.isHidden = true
                }else{
                    self.micMuteButton.isHidden = true
                    self.sendRaiseHandView.isHidden = false
                }
            }
    
            
            self.getParticipants(id: auction_id)
            
        })
        
    }
    
     func listenToAdminVideoStatusCall(auction_id: Int?, card_id: Int?) {
        
        print("auction_id: \(auction_id), card_id: \(card_id)")
        // Instantiate Pusher
        pusher7 = Pusher(
            key: "65b581feebecaee4af62",
            options: PusherClientOptions(host: .cluster("eu"))
        )
        
        // Subscribe to a pusher channel
        let channel = pusher7.subscribe("auction.\(auction_id ?? 0).\(cardID ?? 0)") //.\(card_id ?? 0)
         print("channelchanne\("auction.\(auction_id ?? 0).\(cardID ?? 0)")")
        pusher7.delegate = self
        pusher7.connect()

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
             
             if self.iamConductor {
                 
             }else{
                 if data.video_status == true {
                     self.videoMuteButton.setImage(UIImage(named: "videoMuteButton"), for: .normal)
                     self.agoraEngine.muteLocalVideoStream(false)
                     self.remoteVideoMutedIndicator.isHidden = true
                     self.remoteView.isHidden = false
                  
                 }else {
                     self.videoMuteButton.setImage(UIImage(named: "videoMuteButtonSelected"), for: .selected)
                     self.agoraEngine.muteLocalVideoStream(true)
                     self.remoteVideoMutedIndicator.isHidden = false
                     self.remoteView.isHidden = true
                 }
             }
        })
    }
    
    func listenToRaiseHandCall(auction_id: Int?, card_id: Int?) {
        
        print("auction_id: \(auction_id), card_id: \(card_id)")
        // Instantiate Pusher
        pusher3 = Pusher(
            key: "65b581feebecaee4af62",
            options: PusherClientOptions(host: .cluster("eu"))
        )
        
        // Subscribe to a pusher channel
        let channel = pusher3.subscribe("auction.\(auction_id ?? 0).\(cardID ?? 0)") //.\(card_id ?? 0)
        print("channelchanne\("auction.\(auction_id ?? 0).\(cardID ?? 0)")")
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
       
            self.requestedUserImage.loadImage(URLS.baseImageURL+(data.image ?? ""))
            self.requestedUserNameLable.text = data.name ?? ""

            self.acceptRejectId = data.id
            self.acceptRjectRaiseHandViewHeight.constant = 100
            self.acceptRjectRaiseHandView.isHidden = false
            
            self.getParticipants(id: auction_id)
            
        })
        
    }
    
     func listenToChangesFromPusherUSD(auction_id: Int?, card_id: Int?) {
        
        print("auction_id: \(auction_id), card_id: \(card_id)")
        // Instantiate Pusher
        bidPusher = Pusher(
            key: "65b581feebecaee4af62",
            options: PusherClientOptions(host: .cluster("eu"))
        )
        
        // Subscribe to a pusher channel
        let channel = bidPusher.subscribe("auction.\(auction_id ?? 0).\(cardID ?? 0)")
         print("channelchanne\("auction.\(auction_id ?? 0).\(cardID ?? 0)")")
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

//            if self.cardID != decoded?.data?.offer?.cardID {
//                ToastManager.shared.showError(message:  "The bidding switched to this card by the admin".localized , view: self.view)
//
//            }
            
            self.cardID = decoded?.data?.offer?.cardID
            self.getCardUpdate(id: self.auctionID)
           // self.getLiveAuctionData(id: self.auctionID)
            self.view.layoutIfNeeded()
            self.cardsTableViewHeight.constant = self.cardsTableView.contentSize.height
            self.view.layoutIfNeeded()
            
            print("\(data.data) says \(data.data)")
            
        })
        
    }
     func listenToChangesFromKWDPusher(auction_id: Int?, card_id: Int?) {
        
        print("auction_id: \(auction_id), card_id: \(card_id)")
        // Instantiate Pusher
        bidPusher = Pusher(
            key: "65b581feebecaee4af62",
            options: PusherClientOptions(host: .cluster("eu"))
        )
        
        // Subscribe to a pusher channel
        let channel = bidPusher.subscribe("auction.\(auction_id ?? 0).\(cardID ?? 0)")
        
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
            self.cardID = decoded?.data?.offer?.cardID
            self.getCardUpdate(id: self.auctionID)
           // self.getLiveAuctionData(id: self.auctionID)
            self.view.layoutIfNeeded()
            self.cardsTableViewHeight.constant = self.cardsTableView.contentSize.height
            self.view.layoutIfNeeded()
            
            print("\(data.data) says \(data.data)")
            
        })
        
    }
    
    
    func listenToCardStatusFromUSDPusher(auction_id: Int?) {
       
       print("auction_id: \(auction_id)")
       // Instantiate Pusher
       pusherCards = Pusher(
           key: "65b581feebecaee4af62",
           options: PusherClientOptions(host: .cluster("eu"))
       )
       
       // Subscribe to a pusher channel
       let channel = pusherCards.subscribe("auction.\(auction_id ?? 0)")
       
       pusherCards.delegate = self
       
       pusherCards.connect()
       
       // Bind to an event called "order-event" on the event channel and fire
       // the callback when the event is triggerred
       
       let _ = channel.bind(eventName: "usd_live_cards_status" , eventCallback: { [weak self] (event: PusherEvent) -> Void in
           
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
           let decoded = try? self.decoder.decode(AddSaleAuctionDataModel.self, from: jsonData)
           guard let data = decoded else {
               print("Could not decode message")
               return
           }
           
           for card in data.data?.cards ?? [] {
               
               if card.selectorStatus == true {
                   self.cardID = card.id
                   self.firstTimeCardSelect = true
                   print(self.cardID, self.cardID)
                   
                   self.noteTV.text = card.notes ?? ""
                   self.animalName.text =  card.name ?? ""
                   self.fatherName.text =  card.fatherName ?? ""
                   self.motherName.text =  card.motherName ?? ""
                   
                   self.bidMaxPrice = card.bidMaxPrice
                   
               }
               
           }
           
           if data.data?.bidCounter == 0 {
               
               for card in data.data?.cards ?? [] {
                   
                   if card.selectorStatus == true {
                       
                       self.priceLabel.text = "\(card.bidMaxPrice ?? "0.0")"
                       self.ownerUserImage.isHidden = false
                       self.ownerUserImage.loadImage(URLS.baseImageURL+(card.offer?.user?.image ?? ""))
                       self.ownerNameLabel.text = "Init price".localized
                       
                   }
                   
               }
               
           }else {
               
               for card in data.data?.cards ?? [] {
                   
                   if card.selectorStatus == true {
                       
                       if card.offer == nil {
                           self.priceLabel.text = "\(card.bidMaxPrice ?? "")"
                           print(card.offer?.price ?? "0.0")
                           
                           self.ownerUserImage.isHidden = false
                           self.ownerUserImage.loadImage(URLS.baseImageURL+(card.owner?.image ?? ""))
                           self.ownerNameLabel.text = "Init Price".localized
                           
                           self.bidMaxPrice = card.bidMaxPrice
                           self.cardID = card.id
                       }else{
                           self.priceLabel.text = "\(card.bidMaxPrice ?? "")"
                           print(card.offer?.price ?? "0.0")
                           
                           self.ownerUserImage.isHidden = false
                           self.ownerUserImage.loadImage(URLS.baseImageURL+(card.offer?.user?.image ?? ""))
                           self.ownerNameLabel.text = card.offer?.user?.name ?? ""
                           
                           self.bidMaxPrice = card.bidMaxPrice
                           self.cardID = card.id
                       }
                       
                   }
                   
               }
               
           }
           
          //self.listenToCardStatusFromPusher(auction_id: self.auctionID)
           
           self.raiseHandRequests(auctionID: self.auctionID, card_id: self.cardID)
           
           self.listenToChangesFromPusherTime(auction_id: self.auctionID, card_id: self.cardID)
           
           if HelperConstant.getCurrency() == "USD" {
               print(self.cardID)
               self.listenToChangesFromPusherUSD(auction_id: self.auctionID, card_id: self.cardID)
           }else {
               print(self.cardID)
               self.listenToChangesFromKWDPusher(auction_id: self.auctionID, card_id: self.cardID)
           }
           
           
           self.listenToOutVideoCall(auction_id: self.auctionID, card_id: self.cardID)
           
           self.listenToMicCall(auction_id: self.auctionID, card_id: self.cardID)
           self.getCardUpdate(id: self.auctionID)
           self.view.layoutIfNeeded()
           self.cardsTableViewHeight.constant = self.cardsTableView.contentSize.height
           self.view.layoutIfNeeded()
           self.getParticipants(id: auction_id)
           
           
       })
       
   }
    
    
    
     func listenToCardStatusFromKWDPusher(auction_id: Int?) {
        
        print("auction_id: \(auction_id)")
        // Instantiate Pusher
        pusherCards = Pusher(
            key: "65b581feebecaee4af62",
            options: PusherClientOptions(host: .cluster("eu"))
        )
        
        // Subscribe to a pusher channel
        let channel = pusherCards.subscribe("auction.\(auction_id ?? 0)")
         print("channelchanne\("auction.\(auction_id ?? 0).\(cardID ?? 0)")")
        pusherCards.delegate = self
        
        pusherCards.connect()
        
        // Bind to an event called "order-event" on the event channel and fire
        // the callback when the event is triggerred
        
        let _ = channel.bind(eventName: "kwd_live_cards_status" , eventCallback: { [weak self] (event: PusherEvent) -> Void in
            
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
            let decoded = try? self.decoder.decode(AddSaleAuctionDataModel.self, from: jsonData)
            guard let data = decoded else {
                print("Could not decode message")
                return
            }
            
            for card in data.data?.cards ?? [] {
                
                if card.selectorStatus == true {
                    self.cardID = card.id
                    self.firstTimeCardSelect = true
        
                    self.noteTV.text = card.notes ?? ""
                    self.animalName.text =  card.name ?? ""
                    self.fatherName.text =  card.fatherName ?? ""
                    self.motherName.text =  card.motherName ?? ""
                    
                    self.bidMaxPrice = card.bidMaxPrice
                    
                }
                
            }
            
            if data.data?.bidCounter == 0 {
                
                for card in data.data?.cards ?? [] {
                    
                    if card.offer == nil {
                        self.priceLabel.text = "\(card.bidMaxPrice ?? "")"
                        print(card.offer?.price ?? "0.0")
                        
                        self.ownerUserImage.isHidden = false
                        self.ownerUserImage.loadImage(URLS.baseImageURL+(card.owner?.image ?? ""))
                        self.ownerNameLabel.text = "Init Price".localized
                        
                        self.bidMaxPrice = card.bidMaxPrice
                        self.cardID = card.id
                    }else{
                        self.priceLabel.text = "\(card.bidMaxPrice ?? "")"
                        print(card.offer?.price ?? "0.0")
                        
                        self.ownerUserImage.isHidden = false
                        self.ownerUserImage.loadImage(URLS.baseImageURL+(card.offer?.user?.image ?? ""))
                        self.ownerNameLabel.text = card.offer?.user?.name ?? ""
                        
                        self.bidMaxPrice = card.bidMaxPrice
                        self.cardID = card.id
                    }
                    
                }
                
            }else {
                
                for card in data.data?.cards ?? [] {
                    
                    if card.selectorStatus == true {
                        
                        self.priceLabel.text = "\(card.offer?.price ?? "0.0")"
                        print(card.offer?.price ?? "0.0")
                        
                        self.ownerUserImage.isHidden = false
                        self.ownerUserImage.loadImage(URLS.baseImageURL+(card.offer?.user?.image ?? ""))
                        self.ownerNameLabel.text = card.offer?.user?.name ?? ""
                        
                        self.bidMaxPrice = card.bidMaxPrice
                        
                    }
                    
                }
                
            }
            
           //self.listenToCardStatusFromPusher(auction_id: self.auctionID)
            
            self.raiseHandRequests(auctionID: self.auctionID, card_id: self.cardID)
            
            self.listenToChangesFromPusherTime(auction_id: self.auctionID, card_id: self.cardID)
            
            if HelperConstant.getCurrency() == "USD" {
                print(self.cardID)
                self.listenToChangesFromPusherUSD(auction_id: self.auctionID, card_id: self.cardID)
            }else {
                print(self.cardID)
                self.listenToChangesFromKWDPusher(auction_id: self.auctionID, card_id: self.cardID)
            }
            
            self.listenToOutVideoCall(auction_id: self.auctionID, card_id: self.cardID)
            
            self.listenToMicCall(auction_id: self.auctionID, card_id: self.cardID)
            self.getCardUpdate(id: self.auctionID)
            self.view.layoutIfNeeded()
            self.cardsTableViewHeight.constant = self.cardsTableView.contentSize.height
            self.view.layoutIfNeeded()
            self.getParticipants(id: auction_id)
        
            
        })
        
    }
    
}
 
