//
//  SectionsTypeAddedTableViewCell.swift
//  Hawy
//
//  Created by ahmed abu elregal on 02/09/2022.
//

import UIKit

class SectionsTypeAddedTableViewCell: UITableViewCell {
    
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
        checkImage.image = UIImage(named: "arrowUp")
        titleLabel.textColor = DesignSystem.Colors.PrimaryBlue.color
    }
    
    func unSet() {
        checkImage.image = UIImage(named: "arrowDown")
        titleLabel.textColor = DesignSystem.Colors.PrimaryBlack.color
    }
    
}
