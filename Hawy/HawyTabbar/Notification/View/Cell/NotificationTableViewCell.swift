//
//  NotificationTableViewCell.swift
//  Hawy
//
//  Created by ahmed abu elregal on 04/11/2022.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageOutlet: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var auctionImage: UIImageView!
    @IBOutlet weak var auctionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
