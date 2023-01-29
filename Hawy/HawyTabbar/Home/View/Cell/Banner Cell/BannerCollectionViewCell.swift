//
//  BannerCollectionViewCell.swift
//  Hawy
//
//  Created by ahmed abu elregal on 06/08/2022.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: GradientView!
    @IBOutlet weak var sliderImage: UIImageView!
    @IBOutlet weak var sliderTitle: UILabel!
    @IBOutlet weak var sliderDate: UILabel!
    @IBOutlet weak var sliderAuctionTitle: UILabel!
    @IBOutlet weak var sliderDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
