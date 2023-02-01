//
//  AuctionLiveVideo+Networking.swift
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

extension AuctionLiveVideo {
    
    func getLiveAuctionData(id: Int?) {
        
        print("Listnng To (getLiveAuctionData) -  https://hawy-kw.com/api/auctions/sales/show?auction_id=\(id ?? 0) ")
        
        let url = "https://hawy-kw.com/api/auctions/sales/show?auction_id=\(id ?? 0)"
        
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator()
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers) // //URLEncoding.httpBody
            .validate(statusCode: 200...500)
        
            .responseJSON { response in
                print(url)
                print(headers)
                print(response)
                print(response.result)
                
                switch response.result {
                    
                case .success(let JSON):
                    
                    guard let data = response.data else { return }
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        let liveAuctionRequest = try decoder.decode(NewLiveAuctionModel.self, from: data)
                        
                        
                        if liveAuctionRequest.message == "Unauthenticated." {
                            
                            let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
                                
                                
                                let story = UIStoryboard(name: "Authentication", bundle:nil)
                                let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                                UIApplication.shared.windows.first?.makeKeyAndVisible()
                                
                            }
                            
                            alert.addAction(okAction)
                            
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        
                        if liveAuctionRequest.code == 200 {
                            
                            self.auctionID = liveAuctionRequest.item?.id
                            self.time = (liveAuctionRequest.item?.endDate ?? 0)// * 1000
                            self.currentTime = Int(Date.currentTimeStamp)
                            
                            let finalTimeStamp = (self.time ?? 0) - (self.currentTime ?? 0)
                            self.finalTotal = finalTimeStamp
                            
                            
                            
                            
                            for card in liveAuctionRequest.item?.cards ?? [] {
                                
                                if card.selectorStatus == true {
                                    
                                    self.cardID = card.id
                                    self.curretCard = card
                                    self.firstTimeCardSelect = true
                                    self.iamConductor = card.conductor?.id == HelperConstant.getUserId()
                                    self.noteTV.text = card.notes ?? ""
                                    self.animalName.text =  card.name ?? ""
                                    self.fatherName.text =  card.fatherName ?? ""
                                    self.motherName.text =  card.motherName ?? ""
                                    self.bidMaxPrice = card.bidMaxPrice
                                    
                                    
                                    if ( card.conductedBy == "admin" ) && (card.conductor?.id != HelperConstant.getUserId() ) {
                                        self.listenToAdminRaiseHandCall(auction_id: self.auctionID, card_id: self.cardID)
                                        self.listenToAdminVideoStatusCall(auction_id: self.auctionID, card_id: self.cardID)
                                        
                                        self.videoMuteButton.isHidden = true
                                        self.switchCameraButton.isHidden = true
                                        
                                        self.acceptRjectRaiseHandViewHeight.constant = 0
                                        self.acceptRjectRaiseHandView.isHidden = true
                                        
                                        self.descriptionOfWinAndLoseViewHeight.constant = 80
                                        self.descriptionOfWinAndLoseView.isHidden = false
                                        
                                        self.plusMinusViewHeight.constant = 160
                                        self.bidingActionView.isHidden = false
                                        
                                        self.addBidViewHeight.constant = 70
                                        self.BidingAmountView.isHidden = false
                                        
                                        self.sendRaiseHandViewHeight.constant = 90
                                        self.sendRaiseHandView.isHidden = false
                                        
                                        self.cardsTitleView.isHidden = true
                                        self.containerViewOfCardsTableView.isHidden = true
                                        self.cardsTableView.isHidden = true
                                        
                                        self.cardDetailsViewHeight.constant = 160
                                        self.cardDetailsView.isHidden = false
                                        
                                        
                                        if HelperConstant.getCurrency() != "USD" {
                                            self.listenToCardStatusFromKWDPusher(auction_id: self.auctionID)
                                        }else{
                                            self.listenToCardStatusFromUSDPusher(auction_id: self.auctionID)
                                        }
                                        
                                        if card.owner?.id == HelperConstant.getUserId()  {
                                            self.BidingAmountView.isHidden = true
                                            self.bidingActionView.isHidden = true
                                        }else{
                                            
                                            if self.totalTime > 0 {
                                                self.BidingAmountView.isHidden = false
                                                self.bidingActionView.isHidden = false
                                            }
                                            
                                           
                                        }
                                        
                                        
                                    }else{
                                        if card.owner?.id == HelperConstant.getUserId() || card.conductor?.id == HelperConstant.getUserId() { // || 
                                            self.listenToRaiseHandCall(auction_id: self.auctionID, card_id: self.cardID)
                                            
                                            
                                            self.muteMic = true
                                          //  self.VideoStatues = true
                                            self.videoStatus(status: "on")
                                            
                                            self.videoMuteButton.isHidden = false
                                            self.switchCameraButton.isHidden = false
                                            
                                            self.acceptRjectRaiseHandViewHeight.constant = 0
                                            self.acceptRjectRaiseHandView.isHidden = true
                                            
                                            self.descriptionOfWinAndLoseViewHeight.constant = 0
                                            self.descriptionOfWinAndLoseView.isHidden = true
                                            
                                            self.plusMinusViewHeight.constant = 0
                                            self.bidingActionView.isHidden = true
                                            
                                            self.addBidViewHeight.constant = 0
                                            self.bidingActionView.isHidden = true
                                            
                                            self.sendRaiseHandViewHeight.constant = 0
                                            self.sendRaiseHandView.isHidden = true
                                            
                                            self.cardsTitleView.isHidden = false
                                            self.containerViewOfCardsTableView.isHidden = true
                                            self.cardsTableView.isHidden = true
                                            
                                            self.cardDetailsViewHeight.constant = 0
                                            self.cardDetailsView.isHidden = true
                                            
                                        }else{
                                            
                                            self.listenToAdminRaiseHandCall(auction_id: self.auctionID, card_id: self.cardID)
                                            self.listenToAdminVideoStatusCall(auction_id: self.auctionID, card_id: self.cardID)
                                            
                                            self.muteMic = true
                                          //  self.VideoStatues = false
                                            self.videoStatus(status: "off")
                                            self.VideoStatues = false
                                            self.videoMuteButton.isHidden = true
                                            self.switchCameraButton.isHidden = true
                                            
                                            
                                            self.acceptRjectRaiseHandViewHeight.constant = 0
                                            self.acceptRjectRaiseHandView.isHidden = true
                                            
                                            self.descriptionOfWinAndLoseViewHeight.constant = 80
                                            self.descriptionOfWinAndLoseView.isHidden = false
                                            
                                            self.plusMinusViewHeight.constant = 160
                                            self.bidingActionView.isHidden = false
                                            
                                            self.addBidViewHeight.constant = 70
                                            self.bidingActionView.isHidden = false
                                            
                                            self.sendRaiseHandViewHeight.constant = 90
                                            self.sendRaiseHandView.isHidden = false
                                            
                                            self.cardsTitleView.isHidden = true
                                            self.containerViewOfCardsTableView.isHidden = true
                                            self.cardsTableView.isHidden = true
                                            
                                            self.cardDetailsViewHeight.constant = 160
                                            self.cardDetailsView.isHidden = false
                                            
                                            
                                            if HelperConstant.getCurrency() != "USD" {
                                                self.listenToCardStatusFromKWDPusher(auction_id: self.auctionID)
                                            }else{
                                                self.listenToCardStatusFromUSDPusher(auction_id: self.auctionID)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            self.cardItem = liveAuctionRequest.item
                            self.cards = liveAuctionRequest.item?.cards ?? []
                            self.cardsTableView.reloadData()
                            
                            self.JoinUserAuctionVideo()
                            
                            self.getParticipants(id: id)
                            
                            self.raiseHandRequests(auctionID: self.auctionID, card_id: self.cardID)
                            
                            self.listenToChangesFromPusherTime(auction_id: self.auctionID, card_id: self.cardID)
                            
                            if HelperConstant.getCurrency() == "USD" {
                                self.listenToChangesFromPusherUSD(auction_id: self.auctionID, card_id: self.cardID)
                            }else {
                                self.listenToChangesFromKWDPusher(auction_id: self.auctionID, card_id: self.cardID)
                            }
                            
                            self.listenToOutVideoCall(auction_id: self.auctionID, card_id: self.cardID)
                            
                            self.listenToMicCall(auction_id: self.auctionID, card_id: self.cardID)
                            
                            self.startOtpTimer()
                            self.timerLabel.textColor = DesignSystem.Colors.PrimaryBlack.color
                            self.clockImage.image = UIImage(systemName: "clock.fill")
                            
                            
                            if liveAuctionRequest.item?.bidCounter == 0 {
                                
                                for card in liveAuctionRequest.item?.cards ?? [] {
                                    
                                    if card.selectorStatus == true {
                                        self.priceLabel.text = "\(card.bidMaxPrice ?? "0.0")"
                                        self.ownerUserImage.isHidden = false
                                        self.ownerUserImage.loadImage(URLS.baseImageURL+(card.owner?.image ?? ""))
                                        self.ownerNameLabel.text = "Init price".localized
                                       // self.bidMaxPrice = card.bidMaxPrice
                                        
                                    }
                                }
                                
                            }else {
                                
                                for card in liveAuctionRequest.item?.cards ?? [] {
                                    
                                    if card.selectorStatus == true {
                                        
                                        
                                        if card.offer == nil {
                                            self.priceLabel.text = "\(card.bidMaxPrice ?? "")"
                                            print(card.offer?.price ?? "0.0")
                                            
                                            self.ownerUserImage.isHidden = false
                                            self.ownerUserImage.loadImage(URLS.baseImageURL+(card.owner?.image ?? ""))
                                            self.ownerNameLabel.text = "Init price".localized
                                            
                                            self.bidMaxPrice = card.bidMaxPrice
                                            self.cardID = card.id
                                            self.curretCard = card
                                        }else{
                                            self.priceLabel.text = "\(card.bidMaxPrice ?? "")"
                                            print(card.offer?.price ?? "0.0")
                                            
                                            self.ownerUserImage.isHidden = false
                                            self.ownerUserImage.loadImage(URLS.baseImageURL+(card.offer?.user?.image ?? ""))
                                            self.ownerNameLabel.text = card.offer?.user?.name ?? ""
                                            
                                            self.bidMaxPrice = card.bidMaxPrice
                                            self.cardID = card.id
                                            self.curretCard = card
                                        }
                                        
                                   
                                    }
                                    
                                }
                                
                            }
                            
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
    
    func getParticipants(id: Int?) {
        
        print("Listnng To (getParticipants) -  https://hawy-kw.com/api/auctions/sales/show?auction_id=\(id ?? 0)")
        
        let url = "https://hawy-kw.com/api/auctions/sales/show?auction_id=\(id ?? 0)"
        //&user_id=\(HelperConstant.getUserId() ?? 0)"
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        //showIndecator()
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers) // //URLEncoding.httpBody
            .validate(statusCode: 200...500)
        
            .responseJSON { response in
                
                print(headers)
                print(response)
                print(response.result)
                
                switch response.result {
                    
                case .success(let JSON):
                    
                    guard let data = response.data else { return }
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        let liveAuctionRequest = try decoder.decode(NewLiveAuctionModel.self, from: data)
                        print(liveAuctionRequest)
                        
                        if liveAuctionRequest.message == "Unauthenticated." {
                            
                            let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
                                
                                
                                let story = UIStoryboard(name: "Authentication", bundle:nil)
                                let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                                UIApplication.shared.windows.first?.makeKeyAndVisible()
                                
                            }
                            
                            alert.addAction(okAction)
                            
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        
                        if liveAuctionRequest.code == 200 {
                            
                            for card in liveAuctionRequest.item?.cards ?? [] {
                                
                                if card.selectorStatus == true {
                                    self.cardID = card.id
                                    self.curretCard = card
                                    self.AllRequsts = card.joinedUsers ?? []
                                    self.membersCountLabel.text = "\(self.AllRequsts.count)"
                                    self.membersInLiveCollection.reloadData()
                                }
                                
                            }
                            
                            
                            let allUsers = self.curretCard.joinedUsers ?? []
                            let currentCunductor = self.curretCard.conductor
                            
                            
                            if !self.iamConductor {
                                for user in allUsers{
                                    if user.id == currentCunductor?.id {
                                        
                                       if self.totalTime > 0 {
                                           self.bidingActionView.isHidden = false
                                           self.bidingActionView.isHidden = false
                                        }
                                        
                                        break
                                    }else{
//                                        self.bidingActionView.isHidden = true
//                                        self.bidingAmountView.isHidden = true
                                    }
                                }
                            }
                        }
                        
                        //self.hideIndecator()
                    } catch let error {
                        //self.hideIndecator()
                        print(error)
                        
                    }
                    
                case .failure(let error):
                    
                    print("Request failed with error \(error)")
                    
                }
                
            }
        
    }
    
    func getCardUpdate(id: Int?) {
        
        print("Listnng To (getCardUpdate) -  https://hawy-kw.com/api/auctions/sales/show?id=\(id ?? 0)&user_id=\(HelperConstant.getUserId() ?? 0)")
        
        let url = "https://hawy-kw.com/api/auctions/sales/show?id=\(id ?? 0)&user_id=\(HelperConstant.getUserId() ?? 0)"
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        //showIndecator()
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers) // //URLEncoding.httpBody
            .validate(statusCode: 200...500)
        
            .responseJSON { response in
                
                print(headers)
                print(response)
                print(response.result)
                
                switch response.result {
                    
                case .success(let JSON):
                    
                    print("Validation Successful with response JSON \(JSON)")
                    
                    guard let data = response.data else { return }
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        let liveAuctionRequest = try decoder.decode(NewLiveAuctionModel.self, from: data)
                        print(liveAuctionRequest)
                        
                        if liveAuctionRequest.message == "Unauthenticated." {
                            
                            let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
                                
                                
                                let story = UIStoryboard(name: "Authentication", bundle:nil)
                                let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                                UIApplication.shared.windows.first?.makeKeyAndVisible()
                                
                            }
                            
                            alert.addAction(okAction)
                            
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        
                        if liveAuctionRequest.code == 200 {
                            //MARK: - HeaderCard
                            self.cards = liveAuctionRequest.item?.cards ?? []
                            
                            if liveAuctionRequest.item?.bidCounter == 0 {
                                
                                for card in liveAuctionRequest.item?.cards ?? [] {
                                    
                                    if card.selectorStatus == true {
                                        self.priceLabel.text = "\(card.bidMaxPrice ?? "0.0")"
                                        self.ownerUserImage.isHidden = false
                                        self.ownerUserImage.loadImage(URLS.baseImageURL+(card.owner?.image ?? ""))
                                        self.ownerNameLabel.text = "Init price".localized
                                       // self.bidMaxPrice = card.bidMaxPrice
                                        
                                    }
                                }
                                
                            }else {
                                
                                for card in liveAuctionRequest.item?.cards ?? [] {
                                    
                                    if card.selectorStatus == true {
                                        if card.offer == nil {
                                            self.priceLabel.text = "\(card.bidMaxPrice ?? "")"
                                            print(card.offer?.price ?? "0.0")
                                            
                                            self.ownerUserImage.isHidden = false
                                            self.ownerUserImage.loadImage(URLS.baseImageURL+(card.owner?.image ?? ""))
                                            self.ownerNameLabel.text = "Init price".localized
                                            
                                            self.bidMaxPrice = card.bidMaxPrice
                                            self.cardID = card.id
                                            self.curretCard = card
                                        }else{
                                            self.priceLabel.text = "\(card.bidMaxPrice ?? "")"
                                            print(card.offer?.price ?? "0.0")
                                            
                                            self.ownerUserImage.isHidden = false
                                            self.ownerUserImage.loadImage(URLS.baseImageURL+(card.offer?.user?.image ?? ""))
                                            self.ownerNameLabel.text = card.offer?.user?.name ?? ""
                                            
                                            self.bidMaxPrice = card.bidMaxPrice
                                            self.cardID = card.id
                                            self.curretCard = card
                                        }
                                    }
                                    
                                }
                                
                            }
                            self.cardsTableView.reloadData()
                            
                        }
                        
                        //self.hideIndecator()
                    } catch let error {
                        //self.hideIndecator()
                        print(error)
                        
                    }
                    
                case .failure(let error):
                    
                    print("Request failed with error \(error)")
                    
                }
                
            }
        
    }
    
    func liveCardStatus(cardIDDD : Int) { //url: String, parameters: [String:Any]
        
        print("Listnng To (liveCardStatus) -  https://hawy-kw.com/api/auctions/live/videoCall/cards/status")
        
        
        showLoadingView()
        
        let url = "https://hawy-kw.com/api/auctions/live/videoCall/cards/status"
        let param: [String: Any] = [
            
            "card_id" : cardIDDD ?? 0,
            "auction_id": auctionID ?? 0,
            "user_id": HelperConstant.getUserId() ?? 0
            
        ]

        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        //showIndecator()
        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers) // //URLEncoding.httpBody
            .validate(statusCode: 200...500)
        
            .responseJSON { response in
                
                print(param)
                print(headers)
                print(response)
                print(response.result)
                
                self.dismissLoadingView()
                
                switch response.result {
                    
                case .success(let JSON):
                    
                    guard let data = response.data else { return }
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        let liveAuctionRequest = try decoder.decode(NewLiveAuctionModel.self, from: data)
                        
                        self.getCardUpdate(id: self.auctionID)
                        self.getParticipants(id: self.auctionID)
                        if liveAuctionRequest.code == 200 {
                            for card in liveAuctionRequest.item?.cards ?? [] {
                                if card.selectorStatus == true {
                                    
                                    self.cardID = card.id
                                    self.curretCard = card
                                    self.firstTimeCardSelect = true
                                    
                                }
                            }
                            
                        }
                        
                        if liveAuctionRequest.message == "Unauthenticated." {
                            
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
                    } catch let error {
                        //self.hideIndecator()
                        print(error)
                        
                    }
                    
                case .failure(let error): break

                }
            }
    }
    
    func performUpdateStatusAgree(status: String?, CurrentCardID : Int) {
        
        print("Listnng To (performUpdateStatusAgree) -  https://hawy-kw.com/api/auctions/sales/status")
        
        let url = "https://hawy-kw.com/api/auctions/sales/status"
        
        let param: [String: Any] = [
            
            "card_id" : CurrentCardID ,
            "auction_id": auctionID ?? 0,
            "status": status ?? "" //bidLabel.text ?? ""
            
        ]

        
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
                    
                    guard let data = response.data else { return }
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        let forgetPasswordRequest = try decoder.decode(AuctionAcceptRejectModelModel.self, from: data)
                        print(forgetPasswordRequest)
                        
                        if forgetPasswordRequest.code == 200 {
                            
                            self.getCardUpdate(id: self.auctionID)
                            
                            self.getParticipants(id: self.auctionID)
                            
                            
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
    
    func performUpdateStatusDisagree(status: String?, CurrentCardID : Int) { //url: String, parameters: [String:Any]
        
        
        print("Listnng To (performUpdateStatusDisagree) -  https://hawy-kw.com/api/auctions/sales/status")
        
        
        
        let url = "https://hawy-kw.com/api/auctions/sales/status"
        
        let param: [String: Any] = [
            
            "card_id" : CurrentCardID,
            "auction_id": auctionID ?? 0,
            "status": status ?? "" //bidLabel.text ?? ""
            
        ]

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
                        
                        if forgetPasswordRequest.code == 200 {

                            
                            self.getCardUpdate(id: self.auctionID)
                            
                            self.getParticipants(id: self.auctionID)
                            
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
    
    func performUpdateStatusPayDone(status: String? ,CurrentCardID : Int){ //url: String, parameters: [String:Any]
        
        print("Listnng To (performUpdateStatusPayDone) -  https://hawy-kw.com/api/auctions/sales/status")
        
        let url = "https://hawy-kw.com/api/auctions/sales/status"
        
        let param: [String: Any] = [
            
            "card_id" : cardID ?? 0,
            "auction_id": auctionID ?? 0,
            "status": status ?? "" //bidLabel.text ?? ""
            
        ]

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
                                    
                    guard let data = response.data else { return }
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        let forgetPasswordRequest = try decoder.decode(AuctionAcceptRejectModelModel.self, from: data)

                        
                        if forgetPasswordRequest.code == 200 {
        
                            self.getCardUpdate(id: self.auctionID)
                            
                            self.getParticipants(id: self.auctionID)
                            
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
    
    func performAddBidRequest() { //url: String, parameters: [String:Any]
        
        print("Listnng To (performAddBidRequest) -  https://hawy-kw.com/api/bid)")
        
        let url = "https://hawy-kw.com/api/bid"
        
        let param: [String: Any] = [
            
            "card_id" : cardID ?? 0,
            "auction_id": auctionID ?? 0,
            "price": bidLabel.text ?? "",
            "bid_time": Int(Date.currentTimeStamp)
            
        ]
 
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
    
    func videoCallToken(auctionID: Int?, card_id: Int?) {
        
        print("Listnng To (videoCallToken) -  https://hawy-kw.com/api/auctions/live/videoCall/token?auction_id=\(auctionID ?? 0)&card_id=\(cardID ?? 0)")
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator() //
        AF.request("https://hawy-kw.com/api/auctions/live/videoCall/token?auction_id=\(auctionID ?? 0)&card_id=\(cardID ?? 0)", method: .get, parameters: nil, headers: headers)
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
                        let option = AgoraRtcChannelMediaOptions()
                        self.token = productResponse.item?.token
                        self.channelName = productResponse.item?.channelName ?? ""
                        
                        self.agoraEngine.enableVideo()
                        
                        if productResponse.item?.owner?.id ?? 0 == productResponse.item?.currentUser?.id ?? 0 {
                            self.agoraEngine.enableLocalVideo(true)
                            self.agoraEngine.switchCamera()
                            self.userRole = .broadcaster
                            self.setupViewForConductor()
                        }else{
                            self.agoraEngine.enableLocalVideo(false)
                            self.userRole = .audience
                            self.setupViewForParticipane()
                        }
                        
                        
                        if self.userRole == .broadcaster {
                            option.clientRoleType = .broadcaster
                            self.setupLocalVideo()
                        } else {
                            option.clientRoleType = .audience
                            // self.setupRemoteVideo(uid: UInt(productResponse.item?.currentUser?.id ?? 0))
                        }
                        option.channelProfile = .communication
//
//                        self.agoraEngine.muteLocalAudioStream(!(productResponse.item?.currentUser?.isSpeaker ?? false))
//
//                        self.agoraEngine.muteLocalVideoStream(!(productResponse.item?.currentUser?.video_status ?? false))
//
                     //   self.VideoStatues = true
                        self.videoStatus(status: "on")
                        self.joinChannel(u_id: UInt(productResponse.item?.currentUser?.id ?? 0))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            //  self.agoraEngine.switchCamera()
                        })
                    }
                    self.hideIndecator()
                } catch {
                    self.hideIndecator()
                }
            }
    }
    
    func JoinUserAuctionVideo() {
        
        print("Listnng To (JoinUserAuctionVideo) -  https://hawy-kw.com/api/auctions/live/videoCall/user/join")
        
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        let param : [String: Any] = [
            
            "auction_id" : auctionID ?? 0,
            "card_id" : cardID ?? 0
            
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
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    if productResponse.code == 200 {
                        self.videoCallToken(auctionID: self.auctionID, card_id: self.cardID)
                        self.listenToJoinVideoCall(auction_id: self.auctionID, card_id: self.cardID)
                        self.getParticipants(id: self.auctionID)
                        
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
        
        print("Listnng To (deleteUserAuctionVideo) -  https://hawy-kw.com/api/auctions/live/videoCall/user/out")
        
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        let param : [String: Any] = [
            
            "auction_id" : auctionID ?? 0,
            "card_id" : cardID ?? 0
            
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
                        
                        //self.getJoindData(id: self.card_id, userId: HelperConstant.getUserId())
                        self.getParticipants(id: self.auctionID)
                        
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
        
        print("Listnng To (raiseHand) -  https://hawy-kw.com/api/auctions/live/videoCall/user/raiseHand")
        
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        let param : [String: Any] = [
            
            "auction_id" : auctionID ?? 0,
            "card_id" : cardID ?? 0
            
        ]
        
        showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/auctions/live/videoCall/user/raiseHand", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
 
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
                        self.acceptRejectId = productResponse.item?.id //data.data?.id
                        
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
    func raiseHandRequests(auctionID: Int?, card_id: Int?) {
        
        print("Listnng To (raiseHandRequests) -  https://hawy-kw.com/api/auctions/live/videoCall/user/raiseHandRequests?auction_id=\(auctionID ?? 0)&card_id=\(cardID ?? 0)")
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator() //
        AF.request("https://hawy-kw.com/api/auctions/live/videoCall/user/raiseHandRequests?auction_id=\(auctionID ?? 0)&card_id=\(cardID ?? 0)", method: .get, parameters: nil, headers: headers)
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
        
        print("Listnng To (raiseHandStatus) -  https://hawy-kw.com/api/auctions/live/videoCall/user/raiseHand/status")
        
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        let param : [String: Any] = [
            
            "auction_id" : auctionID ?? 0,
            "card_id" : cardID ?? 0,
            "status" : status ?? "", //"accept", //reject
            "user_id" : acceptRejectId ?? 0
        ]
        
        showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/auctions/live/videoCall/user/raiseHand/status", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
                
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
                        self.getParticipants(id: self.auctionID)
                        self.acceptRjectRaiseHandViewHeight.constant = 0
                        self.acceptRjectRaiseHandView.isHidden = true
                        
                        
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
        
        print("Listnng To (microphoneStatus) -  https://hawy-kw.com/api/auctions/live/videoCall/user/microphone")
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        let param : [String: Any] = [
            
            "auction_id" : auctionID ?? 0,
            "card_id" : cardID ?? 0,
            "mic" : mic //"on" //off
        ]
        
        showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/auctions/live/videoCall/user/microphone", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
                
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
 
                        self.getParticipants(id: self.auctionID)
                        
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
        
        print("Listnng To (videoStatus) -  https://hawy-kw.com/api/auctions/live/videoCall/user/videoStatus")
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        let param : [String: Any] = [
            
            "auction_id" : auctionID ?? 0,
            "card_id" : cardID ?? 0,
            "video_status" : status //"on" //off
        ]
        
        showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/auctions/live/videoCall/user/videoStatus", method: .post, parameters: param, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
                
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
                        self.getParticipants(id: self.auctionID)
                        self.VideoStatues = !self.VideoStatues
                    }else{
                        ToastManager.shared.showError(message: productResponse.message ?? "", view: self.view)
                    }
                    self.hideIndecator()
                } catch {
                    self.hideIndecator()
                }
            }
    }
}

