//
//  FilterProfileCardsViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 25/08/2022.
//

import UIKit

class FilterProfileCardsViewController: BottomPopupViewController {
    
    var selected_Index : Int?
    var height: CGFloat?
    //var Delegate : AddNewAddress!
    //var delegateAction: delegate?
    //var delegYourAdderss: delegateAddress?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    var filter: Int = 5 //0: all, 1: active, 2: pending, 3: purchased, 4: lost
    
    var all = 0
    var active = 0
    var pending = 0
    var purchased = 0
    var lost = 0
    
    var backFilter: ((_ filter: Int) -> Void)?
    
    var data = ["All Cards".localized, "Active Cards".localized, "Pending Cards".localized, "Purchased Cards".localized, "Lost Cards".localized]
    
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var showResutButton: GradientButton!
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppLocalization.currentAppleLanguage() == "en" {
            showResutButton.setTitle("Show the result", for: .normal)
        }else {
            showResutButton.setTitle("اظهر النتائج", for: .normal)
        }
        
        setTableView()
        
    }
    
    override func getPopupHeight() -> CGFloat {
        return height ?? CGFloat(450)
    }
    
    override func getPopupTopCornerRadius() -> CGFloat {
        return 35
    }
    
    override func getPopupPresentDuration() -> Double {
        return presentDuration ?? 1.0
    }
    
    override func getPopupDismissDuration() -> Double {
        return dismissDuration ?? 1.0
    }
    
    override func shouldPopupDismissInteractivelty() -> Bool {
        return shouldDismissInteractivelty ?? false
    }
    
//    self.dismiss(animated: false) {
//        self.dataBackClouser?(self.selectLanguage ?? [], self.valueBack ?? [])
//    }
    
    @IBAction func ShowResultButtonAction(_ sender: Any) {
        dismiss(animated: false, completion: {
            
            if self.filter == 5 {
                self.filter = 0
            }else {
                self.backFilter?(self.filter)
            }
            
        })
    }
    
    func setTableView() {
        
        filterTableView.register(UINib(nibName: "FilterProfileCardsTableViewCell", bundle: nil), forCellReuseIdentifier: "FilterProfileCardsTableViewCell")
        
        let filterTableViewFrame = CGRect(x: 0, y: 0, width: filterTableView.frame.size.width, height: 1)
        filterTableView.tableFooterView = UIView(frame: filterTableViewFrame)
        filterTableView.tableHeaderView = UIView(frame: filterTableViewFrame)
        //filterTableView.contentInset.bottom = 20
        filterTableView.delegate = self
        filterTableView.dataSource = self
        filterTableView.allowsMultipleSelection = false
        
    }
    
}

extension FilterProfileCardsViewController: BottomPopupDelegate {
    func bottomPopupViewLoaded() {
        print("bottomPopupViewLoaded")
        shouldDismissInteractivelty = false
    }
    
    func bottomPopupWillAppear() {
        print("bottomPopupWillAppear")
    }
    
    func bottomPopupDidAppear() {
        print("bottomPopupDidAppear")
    }
    
    func bottomPopupWillDismiss() {
        print("bottomPopupWillDismiss")
    }
    
    func bottomPopupDidDismiss() {
        print("bottomPopupDidDismiss")
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
}

extension FilterProfileCardsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let firstAnimation = AnimationFactory.makeSlideIn(duration: 0.5, delayFactor: 0.05)
            let secondAnimation = AnimationFactory.makeFade(duration: 0.5, delayFactor: 0.05)
            let thirdAnimation = AnimationFactory.makeMoveUpWithBounce(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
            let fourthAnimation = AnimationFactory.makeMoveUpWithFade(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
            //
            let animator = Animator(animation: firstAnimation)
            animator.animate(cell: cell, at: indexPath, in: tableView)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 //0: all, 1: active, 2: pending, 3: purchased, 4: lost
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = filterTableView.dequeueReusableCell(withIdentifier: "FilterProfileCardsTableViewCell", for: indexPath) as? FilterProfileCardsTableViewCell else { return UITableViewCell() }
        
        cell.titleLabel.text = data[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            if let cell = filterTableView.cellForRow(at: indexPath) as? FilterProfileCardsTableViewCell {
                //0: all, 1: active, 2: pending, 3: purchased, 4: lost
                if indexPath.row == 0 {
                    
                    if AppLocalization.currentAppleLanguage() == "en" {
                        showResutButton.setTitle("Show the result (\(all))", for: .normal)
                    }else {
                        showResutButton.setTitle("اظهر النتائج (\(all))", for: .normal)
                    }
                    
                }else if indexPath.row == 1 {
                    
                    if AppLocalization.currentAppleLanguage() == "en" {
                        showResutButton.setTitle("Show the result (\(active))", for: .normal)
                    }else {
                        showResutButton.setTitle("اظهر النتائج (\(active))", for: .normal)
                    }
                        
                }else if indexPath.row == 2 {
                    
                    if AppLocalization.currentAppleLanguage() == "en" {
                        showResutButton.setTitle("Show the result (\(pending))", for: .normal)
                    }else {
                        showResutButton.setTitle("اظهر النتائج (\(pending))", for: .normal)
                    }
                    
                }else if indexPath.row == 3 {
                    
                    if AppLocalization.currentAppleLanguage() == "en" {
                        showResutButton.setTitle("Show the result (\(purchased))", for: .normal)
                    }else {
                        showResutButton.setTitle("اظهر النتائج (\(purchased))", for: .normal)
                    }
                    
                }else {
                    
                    if AppLocalization.currentAppleLanguage() == "en" {
                        showResutButton.setTitle("Show the result (\(lost))", for: .normal)
                    }else {
                        showResutButton.setTitle("اظهر النتائج (\(lost))", for: .normal)
                    }
                    
                }
                
                if cell.isSelected == true {
                    cell.set()
                    //attributeID = "\(item.id ?? 0)"
                    //print("attributeID is : \(attributeID ?? "")")
                    filter = indexPath.row
                    print(indexPath.row)
                }else {
                    cell.unSet()
                    //attributeID = "\(item.id ?? 0)"
                    //print("attributeID is : \(attributeID ?? "")")
                    filter = 5
                }
            }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if let cell = filterTableView.cellForRow(at: indexPath) as? FilterProfileCardsTableViewCell {
            
            if cell.isSelected == true {
                cell.set()
                //attributeID = "\(item.id ?? 0)"
                //print("attributeID is : \(attributeID ?? "")")
                filter = indexPath.row
                print(indexPath.row)
            }else {
                cell.unSet()
                filter = 5
                //attributeID = "\(item.id ?? 0)"
                //print("attributeID is : \(attributeID ?? "")")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
