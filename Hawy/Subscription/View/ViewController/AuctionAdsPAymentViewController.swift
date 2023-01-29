//
//  AuctionAdsPAymentViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 18/11/2022.
//

import UIKit

class AuctionAdsPAymentViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var auctionAdsTypeLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var type: Int?
    var startDate: Int?
    var endDate: Int?
    var total: String?
    
    var startdateAd: String?
    var enddateAd: String?
    var adPrice: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = HelperConstant.getName() ?? "no name"
        
        if type == 0 {
            auctionAdsTypeLabel.text = "Sales Auction".localized
        }else if type == 1 {
            auctionAdsTypeLabel.text = "Live Auction".localized
        }else if type == 2 {
            auctionAdsTypeLabel.text = "Stock Auction".localized
        }else if type == 3 {
            auctionAdsTypeLabel.text = "Ad".localized
        }
        
        
        
        if type == 3 {
            
            startDateLabel.text = startdateAd
            endDateLabel.text = enddateAd
            totalPriceLabel.text = "\(adPrice ?? 0.0)" + (HelperConstant.getCurrency() ?? "KWD")
            
        }else {
            
            let formatter3 = DateFormatter()
            formatter3.dateFormat = " dd/MM/yyyy hh:mm a"
            
            print(formatter3.string(from: Date(timeIntervalSince1970: TimeInterval(startDate ?? 0))))
            startDateLabel.text = formatter3.string(from: Date(timeIntervalSince1970: TimeInterval(startDate ?? 0)))
            
            print(formatter3.string(from: Date(timeIntervalSince1970: TimeInterval(endDate ?? 0))))
            endDateLabel.text = formatter3.string(from: Date(timeIntervalSince1970: TimeInterval(endDate ?? 0)))
            
            totalPriceLabel.text = "\(total ?? "0.0")" + (HelperConstant.getCurrency() ?? "KWD")
            
        }
        
        
        
        
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        let stroyboard = UIStoryboard(name: "Subscriptions", bundle: nil)
        let VC = stroyboard.instantiateViewController(withIdentifier: "SuccessPaymentViewController") as? SuccessPaymentViewController
        present(VC!, animated: true, completion: nil)
    }
    
}
