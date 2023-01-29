//
//  UICollectionView+Ext.swift
//  BaseProgect
//
//  Created by Restart Technology on 19/09/2022.
//

import Foundation
import UIKit

/// check isLastVisibleCell at indexPath for collectionView
extension UICollectionView {
    
    func isLastVisibleCell(at indexPath: IndexPath) -> Bool {
        guard let lastindexPath = indexPathsForVisibleItems.last else { return false }
        return lastindexPath == indexPath
    }
    
}
