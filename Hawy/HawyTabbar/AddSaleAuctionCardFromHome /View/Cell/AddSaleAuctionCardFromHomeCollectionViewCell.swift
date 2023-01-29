//
//  AddSaleAuctionCardFromHomeCollectionViewCell.swift
//  Hawy
//
//  Created by ahmed abu elregal on 14/09/2022.
//

import UIKit

class AddSaleAuctionCardFromHomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: GradientView!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceValue: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                //You can change this method according to your need.
//                containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//                containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
//                containerView.gradientLayer.colors = [DesignSystem.Colors.PrimaryBlue.color.cgColor, DesignSystem.Colors.PrimaryOrange.color.cgColor]
                
                //containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                //containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                //containerView.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
            }
            
            else {
                //You can change this method according to your need.
                //containerView.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                //containerView.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                //containerView.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
            }
        }
    }
    
}
