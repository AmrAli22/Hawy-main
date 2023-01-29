//
//  SalesAuctionsProductsCollectionViewCell.swift
//  Hawy
//
//  Created by ahmed abu elregal on 11/08/2022.
//

import UIKit

class SalesAuctionsProductsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardPriceLabel: UILabel!
    @IBOutlet weak var ownerStackView: UIStackView!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var bidMaxPriceLabel: UILabel!
    @IBOutlet weak var spoilerHereLabel: UILabel!
    
    @IBOutlet weak var productImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
