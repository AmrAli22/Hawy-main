//
//  AuctionLiveVideo+UItableViewDelegates.swift
//  Hawy
//
//  Created by Amr Ali on 16/01/2023.
//

import UIKit
extension AuctionLiveVideo : UITableViewDelegate , UITableViewDataSource {
    func handleExpandClose(button: Int , idOfCard : Int) {
        
        if totalTime <= 0 {
            let section = button
            let isExpanded = cards[section].isExpanded
            cards[section].isExpanded = !isExpanded
            
            let selectedCard = cards[section].selectorStatus
            cards[section].selectorStatus = !(selectedCard ?? false)
            
            self.cardsTableView.reloadData()
            self.cardsTableView.reloadSections(IndexSet(integer: section), with: .none)
            self.view.layoutIfNeeded()
            self.cardsTableViewHeight.constant = self.cardsTableView.contentSize.height
            self.view.layoutIfNeeded()
            
        }else {
            liveCardStatus(cardIDDD: idOfCard)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
        self.view.layoutIfNeeded()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if totalTime <= 0 && cards[section].isExpanded {
            return 1
        }else {
            return 0
        }
    }
    
//
//    enum class OfferStatus(val rawValue: String) : Serializable {
//        @SerializedName("pending")
//        PENDING("pending"),
//
//        @SerializedName("agree")
//        AGREE("agree"),
//
//        @SerializedName("disagree")
//        DIS_AGREE("disagree"),
//
//        @SerializedName("confirm_payment_and_delivery")
//        CONFIRM_PAYMENT_AND_DELIVERY("confirm_payment_and_delivery"),
//
//        @SerializedName("no_action")
//        NO_ACTION("no_action");

    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = cardsTableView.dequeueReusableCell(withIdentifier: "CardsStatusTableViewCell", for: indexPath) as? CardsStatusTableViewCell else { return UITableViewCell() }
        
        let item = cards[indexPath.section]
        
        if item.auctionStatus == "agree" {
            print(indexPath.section)
            
            cell.bigContainerViewHeight.constant = 280
            cell.containerViewInsideBigViewHeight.constant = 260
            
            cell.afterAcceptedRejectedView.isHidden = false
            cell.afterAcceptedRejectedViewHeight.constant = 40
            
            cell.iconAcceptReject.image = UIImage(named: "Search results for Add - Flaticon-4")
            cell.labelAcceptReject.text =  "Offer Accepted".localized
      
            cell.descriptionView.isHidden = false
            cell.descriptionViewHeight.constant = 120
            
            cell.paymentDoneView.isHidden = false
            cell.paymentDoneViewHeight.constant = 100
            
            cell.acceptAndRejectButtonsView.isHidden = true
            cell.acceptAndRejectButtonsViewHeight.constant = 0
            
        }else if item.auctionStatus == "disagree" {
            print(indexPath.section)
            
            cell.bigContainerViewHeight.constant = 60
            cell.containerViewInsideBigViewHeight.constant = 40
            
            cell.afterAcceptedRejectedView.isHidden = false
            cell.afterAcceptedRejectedViewHeight.constant = 40
            
            cell.iconAcceptReject.image = UIImage(named: "Search results for Add - Flaticon-6")
            cell.labelAcceptReject.text =  "Offer Rejected".localized
            
            cell.descriptionView.isHidden = true
            cell.descriptionViewHeight.constant = 0
            
            cell.paymentDoneView.isHidden = true
            cell.paymentDoneViewHeight.constant = 0
            
            cell.acceptAndRejectButtonsView.isHidden = true
            cell.acceptAndRejectButtonsViewHeight.constant = 0
            
        }else if item.auctionStatus == "confirm_payment_and_delivery" {
            print(indexPath.section)
            
            cell.bigContainerViewHeight.constant = 60
            cell.containerViewInsideBigViewHeight.constant = 40
            
            cell.afterAcceptedRejectedView.isHidden = false
            cell.afterAcceptedRejectedViewHeight.constant = 40
            
            cell.iconAcceptReject.image = UIImage(named: "Search results for Add - Flaticon-4")
            cell.labelAcceptReject.text = "Offer Accepted".localized
            
            cell.descriptionView.isHidden = true
            cell.descriptionViewHeight.constant = 0
            
            cell.paymentDoneView.isHidden = true
            cell.paymentDoneViewHeight.constant = 0
            
            cell.acceptAndRejectButtonsView.isHidden = true
            cell.acceptAndRejectButtonsViewHeight.constant = 0
            
        }else if item.auctionStatus == "pending" {
            print(indexPath.section)
            cell.bigContainerViewHeight.constant = 130
            cell.containerViewInsideBigViewHeight.constant = 110
            
            cell.afterAcceptedRejectedView.isHidden = true
            cell.afterAcceptedRejectedViewHeight.constant = 0
            
            cell.descriptionView.isHidden = true
            cell.descriptionViewHeight.constant = 0
            
            cell.paymentDoneView.isHidden = true
            cell.paymentDoneViewHeight.constant = 0
            
            cell.acceptAndRejectButtonsView.isHidden = false
            cell.acceptAndRejectButtonsViewHeight.constant = 110
            
        }else{
            cell.afterAcceptedRejectedView.isHidden = true
            cell.afterAcceptedRejectedViewHeight.constant = 0
        }
        cell.PaymentDoneAction = {
                self.performUpdateStatusPayDone(status: "confirm_payment_and_delivery", CurrentCardID: item.id ?? 0)
        }
        cell.AcceptAction = {
            self.performUpdateStatusAgree(status: "agree", CurrentCardID: item.id ?? 0)
        }
        cell.RejectAction = {
               self.performUpdateStatusDisagree(status: "disagree", CurrentCardID: item.id ?? 0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let myCustomView = UIView()
        let headerView = UITableViewHeaderFooterView()
        let contentView = headerView.contentView
        let headerCell = cardsTableView.dequeueReusableCell(withIdentifier: "LiveCardsTableViewCell") as! LiveCardsTableViewCell
        
        contentView.addSubview(myCustomView)
        myCustomView.addSubview(headerCell)
        
        let item = cards[section]
        
        if totalTime <= 0 {
            if cards[section].isExpanded {
                headerCell.set()
            }else {
                headerCell.unSet()
            }
        }else {
            if item.selectorStatus == true {
                headerCell.set()
            }else {
                headerCell.unSet()
            }
        }
        headerCell.expeadableButton.tag = section
        headerCell.productImage.loadImage(URLS.baseImageURL+(item.mainImage ?? ""))
        headerCell.titleLabel.text = item.name
        headerCell.priceLabel.text = item.bidMaxPrice
        headerCell.currencyLabel.text = HelperConstant.getCurrency()
        
        myCustomView.translatesAutoresizingMaskIntoConstraints = false
        headerCell.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            myCustomView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            myCustomView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            myCustomView.topAnchor.constraint(equalTo: contentView.topAnchor),
            myCustomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            headerCell.leadingAnchor.constraint(equalTo: myCustomView.leadingAnchor, constant: 0),
            headerCell.trailingAnchor.constraint(equalTo: myCustomView.trailingAnchor, constant: 0),
            headerCell.topAnchor.constraint(equalTo: myCustomView.topAnchor),
            headerCell.bottomAnchor.constraint(equalTo: myCustomView.bottomAnchor)
            
        ])
        
        
        headerCell.ExpandableAction = { tag in        
            
            if ( (self.cards[section].conductedBy == "me") || (self.cards[section].conductedBy == "admin") ) && (self.cards[section].conductor?.id == HelperConstant.getUserId()) {
                
            
                
                self.handleExpandClose(button: tag, idOfCard: self.cards[section].id ?? 0)
                
            }else{
                
            }
       
            
        }
        
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

}
