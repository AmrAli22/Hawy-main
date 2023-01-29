//
//  VaccinationNameTableViewCell.swift
//  Hawy
//
//  Created by ahmed abu elregal on 30/08/2022.
//

import UIKit

class VaccinationNameTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var vaccinationNameView: UIView!
    @IBOutlet weak var vaccinationNameTFOutlet: UITextField!
    @IBOutlet weak var plusButtonOutlet: UIButton!
    @IBOutlet weak var minusButtonOutlet: UIButton!
    @IBOutlet weak var plusImage: UIImageView!
    @IBOutlet weak var minusImage: UIImageView!
    
    var DeleteAction: (() -> Void)?
    var AddAction: (() -> Void)?
    
    lazy var label: PaddedLabel = {
        let label = PaddedLabel()
        label.text = "Vaccination Name"
        label.backgroundColor = DesignSystem.Colors.SecondBackground.color
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        //vaccinationNameView.delegate = self
        vaccinationNameView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
        vaccinationNameView.layer.borderWidth = 1
        vaccinationNameView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
        vaccinationNameView.layer.cornerRadius = 15
        vaccinationNameView.layer.masksToBounds = true
        label.isHidden = true
        plusButtonOutlet.isEnabled = false
        minusButtonOutlet.isEnabled = false
        
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: vaccinationNameView.topAnchor, constant: -10).isActive = true
        label.leftAnchor.constraint(equalTo: vaccinationNameView.leftAnchor, constant: 15).isActive = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func updateButtonAction(_ sender: Any) {
        AddAction?()
    }
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        DeleteAction?()
    }
    
    func select() {
        vaccinationNameView.backgroundColor = DesignSystem.Colors.SecondBackground.color
        vaccinationNameView.layer.borderWidth = 1
        vaccinationNameView.layer.borderColor = DesignSystem.Colors.PrimaryOrange.color.cgColor
        vaccinationNameView.layer.cornerRadius = 15
        vaccinationNameView.layer.masksToBounds = true
        label.isHidden = false
        plusImage.image = UIImage(named: "Search results for Add - Flaticon-1")
        minusImage.image = UIImage(named: "Search results for Add - Flaticon-2")
        plusButtonOutlet.isEnabled = true
        minusButtonOutlet.isEnabled = true
    }
    
    func unSelect() {
        vaccinationNameView.backgroundColor = DesignSystem.Colors.PrimaryLightGray.color
        vaccinationNameView.layer.borderWidth = 1
        vaccinationNameView.layer.borderColor = DesignSystem.Colors.PrimaryLightGray.color.cgColor
        vaccinationNameView.layer.cornerRadius = 15
        vaccinationNameView.layer.masksToBounds = true
        label.isHidden = true
        plusImage.image = UIImage(named: "plus")
        minusImage.image = UIImage(named: "minus")
        plusButtonOutlet.isEnabled = false
        minusButtonOutlet.isEnabled = false
    }
    
}
