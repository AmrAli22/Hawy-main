//
//  CollectionAndTableEX.swift
//  MVVM
//
//  Created by Ahmed on 6/7/21.
//

import Foundation
import UIKit

extension UICollectionView {
    func transition(collectionView: UICollectionView) {
        UIView.transition(with: collectionView, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            //Do the data reload here
            collectionView.reloadData()
        }, completion: nil)
    }
    
 
    
    func animateCollection(collectionView: UICollectionView) {
        collectionView.reloadData()
        let cells = collectionView.visibleCells
        
        let collectionViewHeight = collectionView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: collectionViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.75,
                           delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
}
extension UITableView {
    
    func animateTable(tableView: UITableView) {
        tableView.reloadData()
        let cells = tableView.visibleCells
        
        let tableViewHeight = tableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.75,
                           delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}
