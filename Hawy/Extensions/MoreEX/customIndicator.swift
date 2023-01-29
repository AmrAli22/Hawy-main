//
//  customIndicator.swift
//  aman
//
//  Created by Enas Abdallah on 04/02/2021.
//

import Foundation
import UIKit

struct ActivityIndicator {
    
    let viewForActivityIndicator = UIView()
    let view: UIView
    let navigationController: UINavigationController?
    let tabBarController: UITabBarController?
    let activityIndicatorView = UIActivityIndicatorView()
    let loadingTextLabel = UILabel()
    
    var navigationBarHeight: CGFloat { return navigationController?.navigationBar.frame.size.height ?? 0.0 }
    var tabBarHeight: CGFloat { return tabBarController?.tabBar.frame.height ?? 0.0 }
    
    func showActivityIndicator() {
        viewForActivityIndicator.frame = CGRect(x: 200, y: 300, width: self.view.frame.size.width/2, height: self.view.frame.size.height/2)
        viewForActivityIndicator.backgroundColor = UIColor.clear
        view.addSubview(viewForActivityIndicator)
        activityIndicatorView.center =  CGPoint(x: activityIndicatorView.center.x, y: activityIndicatorView.center.y)
        
        activityIndicatorView.transform = CGAffineTransform.init(scaleX: 2, y: 2)
        loadingTextLabel.textColor = UIColor.white
        loadingTextLabel.text = "watting_offer".localized
        //loadingTextLabel.font = UIFont(name: ElMessiriFont.medium.rawValue, size: 10)
        loadingTextLabel.sizeToFit()
        loadingTextLabel.center = CGPoint(x: activityIndicatorView.center.x, y: activityIndicatorView.center.y + 60)
        viewForActivityIndicator.addSubview(loadingTextLabel)
        
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.style = .large
        activityIndicatorView.color = .blue
        viewForActivityIndicator.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }
    
    func stopActivityIndicator() {
        viewForActivityIndicator.removeFromSuperview()
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
}
