//
//  UITableView+Register.swift
//  aman
//
//  Created by Enas Abdallah on 04/01/2021.
//

import UIKit
//import SwifterSwift

extension UITableView {
    
//    func registerHeader<T: UITableViewHeaderFooterView> (nibWithViewClass: T.Type) {
//        let nib = UINib(nibName: T.nibName, bundle: nil)
//        register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
//    }
//    
//    func dequeueHeader<T: UITableViewHeaderFooterView>(forIndexPath indexPath: IndexPath) -> T {
//        let cell = dequeueReusableHeaderFooterView(withClass: T.self)
//        return cell
//    }
//    
//    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
//        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
//            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
//        }
//        
//        return cell
//    }
    
    

        func reloadWithAnimation() {
            self.reloadData()
            let tableViewHeight = self.bounds.size.height
            let cells = self.visibleCells
            var delayCounter = 0
            for cell in cells {
                cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
            }
            for cell in cells {
                UIView.animate(withDuration: 1.6, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    cell.transform = CGAffineTransform.identity
                }, completion: nil)
                delayCounter += 1
            }
        }
   
}
