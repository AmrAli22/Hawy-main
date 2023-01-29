//
//  UIViewController+ShowMessage.swift
//  aman
//
//  Created by Enas Abdallah on 04/01/2021.
//

import UIKit
//import SwiftMessages
//import ARSLineProgress
//import GoogleMaps
extension UIViewController {
    
//    func showMessage(title: String? = nil, sub: String?, type: Theme = .warning, layout: MessageView.Layout = .statusLine, showButton: Bool = false) {
//        // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
//        // files in the main bundle first, so you can easily copy them into your project and make changes.
//        let view = MessageView.viewFromNib(layout: layout)
//
//        // Theme message elements with the warning style.
//        view.configureTheme(type)
//        view.button?.isHidden = showButton ? false : true
//        view.button?.backgroundColor = .clear
//        view.button?.tintColor = .white
//        view.backgroundColor = .amanDarkBlueColor
//        view.bodyLabel?.font = UIFont(name: ElMessiriFont.medium.rawValue, size: 16)
//        // Add a drop shadow.
//        //        view.configureDropShadow()
//
//        // Set message title, body, and icon. Here, we're overriding the default warning
//        // image with an emoji character.
//
//        showButton
//            ? view.configureContent(title: title ?? "", body: sub ?? "", iconImage: nil, iconText: "", buttonImage: #imageLiteral(resourceName: "messageClose"), buttonTitle: nil, buttonTapHandler: { _ in SwiftMessages.hide() })
//            : view.configureContent(title: title ?? "", body: sub ?? "", iconText: "")
//
//        // add Configuration for view
//        var config = SwiftMessages.Config()
//        config.duration = showButton ? .seconds(seconds: 30) : .automatic
//        // Show the message.
//        SwiftMessages.show(config: config, view: view)
//    }
    
    
    // Mark:- Alert Action
    func displayMyAlertMessage(userMessage:String, handler: @escaping (Bool) -> Void = { _ in }) {
        let myAlert = UIAlertController(title:"", message:userMessage, preferredStyle: UIAlertController.Style.alert);
        let okAction = UIAlertAction(title: "Ok".localized, style: .default) { (_) in
            handler(true)
        }
//        let cancel = UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel, handler: { action in
//        })
        myAlert.addAction(okAction)
      //  myAlert.addAction(cancel)
        self.present(myAlert, animated:true, completion:nil);
    }
    
    func showBanner (title: String, subtitle:String,color:UIColor,warning:Bool = false , handler: @escaping (Bool) -> Void = { _ in }) {
        
        
        let image = warning ? #imageLiteral(resourceName: "Group 9825") : #imageLiteral(resourceName: "Logo")
        let banner = Banner(title: title , subtitle: subtitle, image: image, backgroundColor: color)
        banner.textColor = UIColor.white
        banner.dismissesOnTap = true
        handler(true)
        banner.show(duration: 3.0)
    }
    

    
    func shareContent(text:String , url:String) {
        let objectsToShare:URL = URL(string: url)!
        let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,text as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.mail]
        
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    func callNumber(phoneNumber:String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    func customAppearenceNavBar(navBackgroundColor:UIColor ,navigationBarTitleColor :UIColor ) {
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = navBackgroundColor
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = navigationBarTitleColor
        appearance.titleTextAttributes = [.foregroundColor: navigationBarTitleColor]
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    
//    func showIndicator(){
//        ARSLineProgress.show()
//    }
//
//    func hideIndicator(){
//        ARSLineProgress.hide()
//    }
    
    
    
 

 func setBluerEffectView() {
    let blurEffect = (NSClassFromString("_UICustomBlurEffect") as! UIBlurEffect.Type).init()
    let blurView = UIVisualEffectView(frame: UIScreen.main.bounds)
    blurEffect.setValue(3, forKeyPath: "blurRadius")
    blurView.effect = blurEffect
    blurView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    view.insertSubview(blurView, at: 0)
 
}

    func addBlurEffect(viewEffect : UIView){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
           let blurEffectView = UIVisualEffectView(effect: blurEffect)
           blurEffectView.frame = viewEffect.bounds
           blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           viewEffect.addSubview(blurEffectView)
       }
    
//    func setMapViewUberStyle (mapView: GMSMapView) {
//
//        do {
//            // Set the map style by passing the URL of the local file.
//            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
//                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
//            } else {
//                NSLog("Unable to find style.json")
//            }
//        } catch {
//            NSLog("One or more of the map styles failed to load. \(error)")
//        }
//
//
//    }

}
