//
//  MyPackagesTableViewCell.swift
//  Hawy
//
//  Created by ahmed abu elregal on 01/11/2022.
//

import UIKit

class MyPackagesTableViewCell: UITableViewCell {

    @IBOutlet weak var packageTitle: UILabel!
    @IBOutlet weak var enddataTitle: UILabel!
    @IBOutlet weak var categoriesTitle: UILabel!
    @IBOutlet weak var categoriesNumber: UILabel!
    @IBOutlet weak var categoriesDate: UILabel!
    @IBOutlet weak var categoriesPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
