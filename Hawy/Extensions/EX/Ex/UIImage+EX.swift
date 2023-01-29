//
//  UIImage+EX.swift
//  EverDeliever
//
//  Created by Ahmed on 4/7/22.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    func loadProfileCover(_ url : String?) {
        
        guard let linkString = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)  , let url = URL(string: linkString) else { return }
        
        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "background"),
            options: [
                
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
                
            ])
        
        self.kf.indicatorType = .activity
        
    }
    func loadImageProfile(_ url : String?) {
        
        guard let linkString = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)  , let url = URL(string: linkString) else { return }
        
        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "profile"),
            options: [
                
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
                
            ])
        
        self.kf.indicatorType = .activity
        
    }
    func loadImage(_ url : String?) {
        //ahn800
        //placeholder_2
        
        guard let linkString = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)  , let url = URL(string: linkString) else { return }
        
        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder3"),
            options: [
                
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
                
            ])
        
        self.kf.indicatorType = .activity
        
    }
    
    func loadChatImage(_ url : String?) {
        //ahn800
        //placeholder_2
        
        guard let linkString = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)  , let url = URL(string: linkString) else { return }
        
        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "noun-send-3993472"),
            options: [
                
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
                
            ])
        
        self.kf.indicatorType = .activity
        
    }
}
