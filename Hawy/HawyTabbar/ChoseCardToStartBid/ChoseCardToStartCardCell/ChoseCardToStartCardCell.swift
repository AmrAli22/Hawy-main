//
//  ChoseCardToStartCardCell.swift
//  Hawy
//
//  Created by Amr Ali on 20/01/2023.
//

import UIKit

class ChoseCardToStartCardCell: UICollectionViewCell {

  
    @IBOutlet weak var ConductorHere: UILabel!
    @IBOutlet weak var costOfCard: UILabel!
    @IBOutlet weak var NameOfCard: UILabel!
    @IBOutlet weak var CardImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    var isConductorHere = false {
        didSet {
            if isConductorHere {
                ConductorHere.isHidden = false
                ConductorHere.text = "Conductor is Here"
            }else{
                ConductorHere.isHidden = true
                ConductorHere.text = ""
            }
        }
    }
}
