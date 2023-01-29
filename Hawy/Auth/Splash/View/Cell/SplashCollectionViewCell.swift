//
//  SplashCollectionViewCell.swift
//  Hawy
//
//  Created by ahmed abu elregal on 07/08/2022.
//

import UIKit

class SplashCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var splashImage: UIImageView!
    @IBOutlet weak var splashTitle: UILabel!
    
    @IBOutlet weak var firstCircleView: UIView!
    @IBOutlet weak var firstNumLable: UILabel!
    
    @IBOutlet weak var secondCircleView: UIView!
    @IBOutlet weak var secondNumLable: UILabel!
    
    @IBOutlet weak var thirdCircleView: UIView!
    @IBOutlet weak var thirdNumLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
