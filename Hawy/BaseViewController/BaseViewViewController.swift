//
//  BaseViewViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 17/09/2022.
//

import UIKit
import Foundation
import NVActivityIndicatorView

class BaseViewViewController: UIViewController {
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .ballClipRotatePulse, color: DesignSystem.Colors.PrimaryBlue.color, padding: 0)
    
    lazy var containerOfLoading: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.15)
        return view
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    func showIndecator() {
        addLoaderToView(mainView: view, containerOfLoading: containerOfLoading, loading: loading)
    }
    
    func hideIndecator() {
        removeLoader(containerOfLoading: containerOfLoading, loading: loading)
    }
    
}

extension UIViewController {

    func addLoaderToView(mainView: UIView, containerOfLoading: UIView, loading: NVActivityIndicatorView) {
        
        loading.isUserInteractionEnabled = false
        loading.translatesAutoresizingMaskIntoConstraints = false
        DispatchQueue.main.async {
            self.view.addSubview(containerOfLoading)
            containerOfLoading.addSubview(loading)
            NSLayoutConstraint.activate([
                
                containerOfLoading.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 0),
                containerOfLoading.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: 0),
                containerOfLoading.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 0),
                containerOfLoading.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 0),
                
                loading.widthAnchor.constraint(equalToConstant: 50),
                loading.heightAnchor.constraint(equalToConstant: 50),
                loading.centerYAnchor.constraint(equalTo: containerOfLoading.centerYAnchor, constant: 0),
                loading.centerXAnchor.constraint(equalTo: containerOfLoading.centerXAnchor, constant: 0)
                
            ])
            
            loading.startAnimating()
        }
     
    }

    func removeLoader(containerOfLoading: UIView, loading: NVActivityIndicatorView)  {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            containerOfLoading.removeFromSuperview()
            loading.stopAnimating()
        }
    }
}
