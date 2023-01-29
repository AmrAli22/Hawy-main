//
//  ChooseCategoryForAuctionTableViewCell.swift
//  Hawy
//
//  Created by ahmed abu elregal on 08/12/2022.
//

import UIKit

class ChooseCategoryForAuctionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
//        if selected == true {
//            set()
//        }else{
//            unSet()
//        }
        
    }
    
    func set() {
        checkImage.image = UIImage(named: "TOGGLE-1")
        titleLabel.textColor = DesignSystem.Colors.PrimaryBlue.color
    }
    
    func unSet() {
        checkImage.image = UIImage(named: "TOGGLE")
        titleLabel.textColor = DesignSystem.Colors.PrimaryDarkGray.color
    }
    
}
