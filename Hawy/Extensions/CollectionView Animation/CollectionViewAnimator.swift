//
//  CollectionViewAnimator.swift
//  BaseProgect
//
//  Created by Restart Technology on 19/09/2022.
//

import Foundation
import UIKit

/// Animator class to access Animation class and all cases in  Animation for collectionView
final class CollectionViewAnimator {
    
    private var hasAnimatedAllCells = false
    private let animation: CollectionViewAnimation
    
    init(animation: @escaping CollectionViewAnimation) {
        self.animation = animation
    }
    
    func animate(cell: UICollectionViewCell, at indexPath: IndexPath, in collectionView: UICollectionView) {
        guard !hasAnimatedAllCells else {
            return
        }
        
        animation(cell, indexPath, collectionView)
        
        hasAnimatedAllCells = collectionView.isLastVisibleCell(at: indexPath)
    }
    
}
