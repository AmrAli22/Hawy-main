//
//  MoveUpWithBounceCollectionCellAnimator.swift
//  BaseProgect
//
//  Created by Restart Technology on 19/09/2022.
//

import Foundation
import UIKit

/// typealias Animation for cell, indexPath, tableView for collectionView
typealias CollectionViewAnimation = (UICollectionViewCell, IndexPath, UICollectionView) -> Void

/// AnimationFactory this enum contain for animation type for collectionView
// 1- makeFade
// 2- makeMoveUpWithBounce
// 3- makeSlideIn
// 4- makeMoveUpWithFade
enum CollectionViewAnimationFactory {
    
    static func makeFade(duration: TimeInterval, delayFactor: Double) -> CollectionViewAnimation {
        return { cell, indexPath, _ in
            
            cell.alpha = 0
            
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                animations: {
                    cell.alpha = 1
                })
        }
    }
    
    static func makeMoveUpWithBounce(rowHeight: CGFloat, duration: TimeInterval, delayFactor: Double) -> CollectionViewAnimation {
        
        return { cell, indexPath, collectionView in
            
            cell.transform = CGAffineTransform(translationX: 0, y: rowHeight)
            
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                usingSpringWithDamping: 0.4,
                initialSpringVelocity: 0.1,
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                })
            
        }
        
    }
    
    static func makeSlideIn(duration: TimeInterval, delayFactor: Double) -> CollectionViewAnimation {
        
        return { cell, indexPath, collectionView in
            
            cell.transform = CGAffineTransform(translationX: collectionView.bounds.width, y: 0)
            
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                })
            
        }
        
    }
    
    static func makeMoveUpWithFade(rowHeight: CGFloat, duration: TimeInterval, delayFactor: Double) -> CollectionViewAnimation {
        
        return { cell, indexPath, collectionView in
            
            cell.transform = CGAffineTransform(translationX: 0, y: rowHeight / 2)
            cell.alpha = 0
            
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                    cell.alpha = 1
                })
            
        }
        
    }
    
}
