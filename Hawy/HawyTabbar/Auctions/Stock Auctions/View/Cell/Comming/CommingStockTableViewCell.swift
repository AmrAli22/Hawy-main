//
//  CommingStockTableViewCell.swift
//  Hawy
//
//  Created by ahmed abu elregal on 07/10/2022.
//

import UIKit

class CommingStockTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commingStockLabel: UILabel!
    @IBOutlet weak var totalParticipantLabel: UILabel!
    @IBOutlet weak var totalParticipantValueLabel: UILabel!
    @IBOutlet weak var remainingParticipantLabel: UILabel!
    @IBOutlet weak var remainingParticipantValueLabel: UILabel!
    @IBOutlet weak var subscriptionFeeLabel: UILabel!
    @IBOutlet weak var subscriptionFeeValueLabel: UILabel!
    
    @IBOutlet weak var subscribeButtonOutlet: GradientButton!
    
    var SubscribeAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func subscribeButtonAction(_ sender: Any) {
        
        SubscribeAction?()
        
    }
    
    
}
