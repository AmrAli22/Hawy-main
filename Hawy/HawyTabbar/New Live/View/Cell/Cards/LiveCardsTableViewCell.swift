//
//  LiveCardsTableViewCell.swift
//  Hawy
//
//  Created by ahmed abu elregal on 04/01/2023.
//

import UIKit

class LiveCardsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewBoder: UIView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectedUnselectedImage: UIImageView!
    @IBOutlet weak var heightBidLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var expeadableButton: UIButton!
    
    var ExpandableAction: ((_ sender: Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set() {
        selectedUnselectedImage.image = UIImage(named: "TOGGLE-1")
        titleLabel.textColor = DesignSystem.Colors.PrimaryBlue.color
        viewBoder.layer.borderColor = DesignSystem.Colors.PrimaryBlue.color.cgColor
        viewBoder.layer.borderWidth = 1
        priceLabel.textColor = DesignSystem.Colors.PrimaryBlue.color
        currencyLabel.textColor = DesignSystem.Colors.PrimaryBlue.color
        heightBidLabel.textColor = DesignSystem.Colors.PrimaryBlue.color
    }
    
    func unSet() {
        selectedUnselectedImage.image = UIImage(named: "TOGGLE")
        titleLabel.textColor = DesignSystem.Colors.PrimaryDarkGray.color
        viewBoder.layer.borderColor = DesignSystem.Colors.PrimaryDarkGray.color.cgColor
        viewBoder.layer.borderWidth = 1
        priceLabel.textColor = DesignSystem.Colors.PrimaryDarkGray.color
        currencyLabel.textColor = DesignSystem.Colors.PrimaryDarkGray.color
        heightBidLabel.textColor = DesignSystem.Colors.PrimaryDarkGray.color
    }
    
    @IBAction func expeadableButtonTapped(_ sender: UIButton) {
        
        if let ExpandableAction = ExpandableAction {
            ExpandableAction(sender.tag)
            
        }
        
      
        
    }
    
}
