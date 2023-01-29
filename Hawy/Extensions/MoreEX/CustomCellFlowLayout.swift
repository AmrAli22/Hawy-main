//
//  CustomImageFlowLayout.swift
//  ZDT_InstaTutorial
//
//  Created by Sztanyi Szabolcs on 22/12/15.
//  Copyright © 2015 Zappdesigntemplates. All rights reserved.
//

import UIKit

class CustomCellFlowLayout: UICollectionViewFlowLayout {

    
    override init() {
        super.init()
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    var cellsPerRow: Int = 2
    var height : CGFloat = 193
    override var itemSize: CGSize {
        get {
            guard let collectionView = collectionView else { return super.itemSize }
            let marginsAndInsets = sectionInset.left + sectionInset.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
            let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
            return CGSize(width: itemWidth, height: height )
        }
        set {
            super.itemSize = newValue
        }
    }


    func setupLayout() {
        
        minimumInteritemSpacing = 10
        minimumLineSpacing = 10
        scrollDirection = .vertical
        self.sectionInset =  UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    

}

//Mark:- Custom shadow for cell

extension UICollectionViewCell {
    func  shadowCollectionCell(cell:UICollectionViewCell){
              cell.layer.masksToBounds = false
//              cell.layer.shadowColor = UIColor.black.cgColor
//              cell.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//              cell.layer.shadowOpacity = 0.2
              cell.layer.shadowRadius = 20
              
          }
    
  
      
}
