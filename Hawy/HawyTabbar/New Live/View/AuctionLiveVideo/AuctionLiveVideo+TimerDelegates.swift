//
//  AuctionLiveVideo+TimerDelegates.swift
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
    
    //MARK:- SetUp startOtpTimer
    public func startOtpTimer() {
        
        self.totalTime = finalTotal
        
        self.timer2 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    //MARK:- SetUp updateTimer
    @objc func updateTimer() {
        
        if self.totalTime <= 0 {
            self.timerLabel.text = "00 : 00 : 00"
            self.timerLabel.textColor = DesignSystem.Colors.PrimaryDarkRed.color
            self.clockImage.image = UIImage(named: "asset-2")
            self.timer2?.invalidate()
            
            self.plusButtonOutlet.isEnabled = false
            self.minusButtonOutlet.isEnabled = false
            self.addBidButton.isEnabled = false
            self.sendRaiseHandButton.isEnabled = false
            self.controlButtons.isHidden = true
            self.remoteVideoMutedIndicator.isHidden = false
            
            VideoStatues = false
            
            if iamConductor{
                handleEndOfTimeForConductor()
            }else{
                handleEndOfTimeForUser()
            }
            
            
            
            
            //            self.plusButtonOutlet.isEnabled = false
            //            self.minusButtonOutlet.isEnabled = false
            //            self.addBidButton.isEnabled = false
            //            self.sendRaiseHandButton.isEnabled = false
            //            self.controlButtons.isHidden = true
            //            self.remoteVideoMutedIndicator.isHidden = false
            
            
            
            
            //            if iamConductor {
            //                winnigView.isHidden = true
            //                self.bidingActionView.isHidden = true
            //                               self.BidingAmountView.isHidden = true
            //
            //                               auctionFinalBidingStatues.isHidden = false
            //                               auctionFInalBidingStatuesLabel.backgroundColor = .orange
            //                               auctionFInalBidingStatuesLabel.textColor  =  .red
            //                               auctionFInalBidingStatuesLabel.text       =  "AuctionEnded".localized
            //
            //
            //                VideoStatues = false
            //                controlButtons.isHidden = true
            //
            //            }else{
            //                VideoStatues = false
            //                controlButtons.isHidden = true
            //            }
            //
            
            
            //            if curretCard.offer?.userID == HelperConstant.getUserId() {
            //                if !iamConductor {
            //                    winnigView.isHidden = false
            //                }else{
            //                    self.bidingActionView.isHidden = true
            //                    self.BidingAmountView.isHidden = true
            //                }
            //           }
            
        }else if self.totalTime <= 3600 {
            
            self.timerLabel.labelFlash()
            
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
    
    func handleEndOfTimeForConductor(){
        
    }
    
    func handleEndOfTimeForUser(){
        sendRaiseHandView.isHidden = true
        BidingAmountView.isHidden  = true
        bidingActionView.isHidden  = true
    }
    
    
}




