//
//  CurrentCollectionReusableView.swift
//  Hawy
//
//  Created by ahmed abu elregal on 09/10/2022.
//

import UIKit

class CurrentCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var firstTimerLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    var timer2: Timer?
    var totalTime: Int = 0
    var finalTotal: Int = 0
    
    var Click: ((_ sender: Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {
        
        Click?(sender.tag)
        
    }
    //MARK:- SetUp startOtpTimer
    public func startOtpTimer(data: StockAuctionItem?) {
        
        let endTime = (data?.endDate ?? 0)
        let currentTime = Int(Date.currentTimeStamp)
        
        let finalTimeStamp = endTime - currentTime
        self.finalTotal = finalTimeStamp
        
        self.totalTime = finalTotal
        
        self.timer2 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    //MARK:- SetUp updateTimer
    @objc func updateTimer() {
        
        print(self.totalTime)
        print(self.timeFormatted(self.totalTime))
        
        if self.totalTime <= 0 {
            timerLabel.text = "00 : 00 : 00"
            timerLabel.textColor = DesignSystem.Colors.PrimaryDarkRed.color
            self.timer2?.invalidate()
            
        }else {
            
            timerLabel.text = self.timeFormatted(self.totalTime) // will show timer
            timerLabel.textColor = DesignSystem.Colors.PrimaryBlack.color
            
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

