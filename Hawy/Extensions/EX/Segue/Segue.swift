//
//  Segue.swift
//  MVVM
//
//  Created by Ahmed on 10/2/21.
//

import Foundation
import UIKit

extension UIViewController {
    
    func moveWithFullScreen(_ vc : String, sec: Float, full: Bool, storyBoardName: String) {
        
        let dispatchAfter = DispatchTimeInterval.seconds(Int(sec))
        //To call or execute function after some time(After sec)
        DispatchQueue.main.asyncAfter(deadline: .now() + dispatchAfter) { [weak self] in
            guard let self = self else { return }
            let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
            let VC  = storyboard.instantiateViewController(withIdentifier: vc)
            let navController = UINavigationController(rootViewController: VC)
            navController.isNavigationBarHidden = full
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
//            let viewController: UIViewController? = self?.storyboard?.instantiateViewController(withIdentifier: vc)
//            viewController?.modalPresentationStyle = .fullScreen
//            let navi = UINavigationController(rootViewController: viewController!)
//            self?.navigationController?.pushViewController(navi, animated: true)
        }
        
    }
    func moveWithsheetScreen(_ vc : String, sec: Float, full: Bool, storyBoardName: String) {
        
        let dispatchAfter = DispatchTimeInterval.seconds(Int(sec))
        //To call or execute function after some time(After sec)
        DispatchQueue.main.asyncAfter(deadline: .now() + dispatchAfter) { [weak self] in
            guard let self = self else { return }
            let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
            let VC  = storyboard.instantiateViewController(withIdentifier: vc)
            let navController = UINavigationController(rootViewController: VC)
            navController.isNavigationBarHidden = full
            self.present(navController, animated: true, completion: nil)
        }
        
    }
    
    func goVC(_ vc : String, storyBoardName: String)  {
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: vc)
        // present(vc, animated: true, completion: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func dismiss()  {
        navigationController?.popViewController(animated: true)
        //  dismiss(animated: true, completion: nil)
    }
    
    func showAnimate()
             {
                 self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                 self.view.alpha = 0.0;
                 UIView.animate(withDuration: 0.25, animations: {
                     self.view.alpha = 1.0
                     self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

                 });
             }

    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
      
}
