//
//  SectionsOfPackagesTableViewCell.swift
//  Hawy
//
//  Created by ahmed abu elregal on 08/08/2022.
//

import UIKit

class SectionsOfPackagesTableViewCell: UITableViewCell {
    
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
        
        if selected == true {
            set()
        }else{
            unSet()
        }
        
    }
    
    func set() {
        checkImage.image = UIImage(named: "TOGGLE-1")
    }
    
    func unSet() {
        checkImage.image = UIImage(named: "TOGGLE")
    }
    
}
