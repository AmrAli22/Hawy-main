//
//  PickerPhotoCollectionViewCell.swift
//  Hawy
//
//  Created by ahmed abu elregal on 27/08/2022.
//

import UIKit

class PickerPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var photoImage: UIImageView!
    
    var DeleteAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func deleteButtonAction(_ sender: Any) {
        DeleteAction?()
    }
    
}
