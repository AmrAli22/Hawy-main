//
//  CardsStatusTableViewCell.swift
//  Hawy
//
//  Created by ahmed abu elregal on 04/01/2023.
//

import UIKit

class CardsStatusTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bigContainerView: UIView!
    @IBOutlet weak var bigContainerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var containerViewInsideBigView: UIView!
    @IBOutlet weak var containerViewInsideBigViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var iconAcceptReject: UIImageView!
    @IBOutlet weak var labelAcceptReject: UILabel!
    
    @IBOutlet weak var afterAcceptedRejectedView: UIView!
    @IBOutlet weak var afterAcceptedRejectedViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var paymentDoneView: UIView!
    @IBOutlet weak var paymentDoneViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var acceptAndRejectButtonsView: UIView!
    @IBOutlet weak var acceptAndRejectButtonsViewHeight: NSLayoutConstraint!
    
    var PaymentDoneAction: (() -> Void)?
    var AcceptAction: (() -> Void)?
    var RejectAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func paymentDoneButtonTapped(_ sender: UIButton) {
        PaymentDoneAction?()
    }
    
    @IBAction func acceptButtonTapped(_ sender: UIButton) {
        AcceptAction?()
    }
    
    @IBAction func rejectButtonTapped(_ sender: UIButton) {
        RejectAction?()
    }
    
}
