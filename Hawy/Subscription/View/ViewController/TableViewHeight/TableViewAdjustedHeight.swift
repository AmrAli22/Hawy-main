//
//  TableViewAdjustedHeight.swift
//  Hawy
//
//  Created by ahmed abu elregal on 09/08/2022.
//

import Foundation
import UIKit

class TableViewAdjustedHeight: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }
override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}
