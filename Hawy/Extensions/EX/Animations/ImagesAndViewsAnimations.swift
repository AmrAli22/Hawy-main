//
//  ImagesAndViewsAnimations.swift
//  EverDeliever
//
//  Created by Ahmed on 3/13/22.
//

import Foundation
import UIKit

class AnimatedGradientImageView: UIImageView {
    
    let maskLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() -> Void {
        
        // vertical gradient
        // start at bottom
        maskLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        
        //  to bottom + 1/10th
        maskLayer.endPoint = CGPoint(x: 0.5, y: 1.1)
        
        // use "if true" to see the layer itself
        // use "if false" to see the image reveal
        if false {
            // yellow to red
            maskLayer.colors = [UIColor.yellow.cgColor, UIColor.red.cgColor]
            // add it as a sublayer
            layer.addSublayer(maskLayer)
        } else {
            // clear to red
            maskLayer.colors = [UIColor.clear.cgColor, UIColor.red.cgColor]
            // set the mask
            layer.mask = maskLayer
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // set mask layer frame
        maskLayer.frame = bounds
    }
    
    func reveal() -> Void {
        
        let anim1: CABasicAnimation = CABasicAnimation(keyPath: "startPoint.y")
        
        // anim1 animates the gradient start point Y
        //  to -0.1 (1/10th above the top of the view)
        anim1.toValue = -0.1
        anim1.duration = 5.0
        //anim1.repeatCount = 1
        anim1.isRemovedOnCompletion = false
        anim1.fillMode = .forwards
        
        let anim2: CABasicAnimation = CABasicAnimation(keyPath: "endPoint.y")
        
        // anim2 animates the gradient end point Y
        //  to 0.0 (the top of the view)
        anim2.toValue = 0.0
        anim2.duration = 5.0
        //anim2.repeatCount = .infinity
        anim2.isRemovedOnCompletion = false
        anim2.fillMode = .forwards
        
        maskLayer.add(anim1, forKey: nil)
        maskLayer.add(anim2, forKey: nil)
        
    }
    
}

class AnimatedGradientView: UIView {
    
    let maskLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    func commonInit() -> Void {
        
        // vertical gradient
        // start at bottom
        maskLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        
        //  to bottom + 1/10th
        maskLayer.endPoint = CGPoint(x: 0.5, y: 1.1)
        
        // use "if true" to see the layer itself
        // use "if false" to see the image reveal
        if false {
            // yellow to red
            maskLayer.colors = [UIColor.yellow.cgColor, UIColor.red.cgColor]
            // add it as a sublayer
            layer.addSublayer(maskLayer)
        } else {
            // clear to red
            maskLayer.colors = [UIColor.clear.cgColor, UIColor.red.cgColor]
            // set the mask
            layer.mask = maskLayer
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // set mask layer frame
        maskLayer.frame = bounds
    }
    
    func reveal() -> Void {
        
        let anim1: CABasicAnimation = CABasicAnimation(keyPath: "startPoint.y")
        let mFrame = CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: 0)
        
        // anim1 animates the gradient start point Y
        // to -0.1 (1/10th above the top of the view)
        
        anim1.toValue = mFrame //-0.1
        anim1.duration = 5.0
        //anim1.repeatCount = .infinity
        anim1.isRemovedOnCompletion = false
        anim1.fillMode = CAMediaTimingFillMode.forwards
        
        let anim2: CABasicAnimation = CABasicAnimation(keyPath: "endPoint.y")
        
        // anim2 animates the gradient end point Y
        // to 0.0 (the top of the view)
        
        anim2.toValue = mFrame //0.0
        anim2.duration = 5.0
        //anim2.repeatCount = .infinity
        anim2.isRemovedOnCompletion = false
        anim2.fillMode = CAMediaTimingFillMode.forwards
        
        maskLayer.add(anim1, forKey: nil)
        maskLayer.add(anim2, forKey: nil)
        
    }
    
}
