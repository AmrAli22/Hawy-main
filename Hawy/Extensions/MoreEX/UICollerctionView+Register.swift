//
//  UICollerctionView+Register.swift
//  Hojoj
//
//  Created by Mohammed Elnaggar on 9/21/20.
//  Copyright © 2020 Mohammed Elnaggar. All rights reserved.
//

import UIKit

//extension UICollectionView {
//
//    func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T {
//        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
//            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
//        }
//        return cell
//    }
//}

//extension UICollectionView {
//    func registerHeader<T: UICollectionReusableView >(_: T.Type) {
//        register(UINib(nibName: T.nibName, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier)
//    }
//    
//    func dequeueHeader<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
//        guard let view = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
//            fatalError("Could not dequeue Header with identifier: \(T.reuseIdentifier)")
//        }
//        return view
//    }
//}
