//
//  PopularQuestionsTableViewCell.swift
//  Hawy
//
//  Created by ahmed abu elregal on 04/10/2022.
//

import UIKit

class PopularQuestionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var MPLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
