//
//  UIImagePickerControllerExtension.swift
//  MVVM
//
//  Created by Ahmed on 6/7/21.
//

import Foundation
import UIKit
import AVFoundation


protocol PickerImageDelegate {
    func didPickedImage(_ image: UIImage)
}

class PickImageVC: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: PickerImageDelegate!
    
    func pick(){
        let alert:UIAlertController = UIAlertController(title: "Choose Image",
                                                        message: nil, preferredStyle: UIAlertController.Style.alert)
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Photo gallery", style: UIAlertAction.Style.default) { UIAlertAction in
            self.openGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { UIAlertAction in
        }
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        
//        if let topController = UIApplication.inputViewController() {
//            print("topController\(topController)")
//            _ = topController.navigationController?.popViewController(animated: true)
//            topController.present(alert, animated: true, completion: nil)
//
//        }
        //        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: Image Pick Management
    func openCamera() {
        let picker = UIImagePickerController()
        
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            
            if self.determineStatus(){
                picker.sourceType = .camera
                picker.delegate = self
                
                picker.allowsEditing = true
                picker.cameraDevice = .front
                
            }
        }
        else {
            print("Sorry, this device has no camera")
        }
    }
    
    func openGallery() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        
    }
    
    
    func determineStatus() -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status {
        case .authorized:
            return true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {_ in })
            return false
        case .restricted:
            return false
        case .denied:
            let alert = UIAlertController(
                title: "Need Authorization",
                message: "Wouldn't you like to authorize this app " +
                "to use the camera?",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                title: "No", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(
                title: "OK", style: .default, handler: {
                    _ in
                    let url = NSURL(string:UIApplication.openSettingsURLString)!
                    UIApplication.shared.open(url as URL)
                    //open
                    //openURL
            }))
            
            return false
        @unknown default:
            fatalError("")
        }
    }
    
}

extension UIImage {
    static func gradientImage(bounds: CGRect, colors: [UIColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map(\.cgColor)

        // This makes it left to right, default is top to bottom
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        let renderer = UIGraphicsImageRenderer(bounds: bounds)

        return renderer.image { ctx in
            gradientLayer.render(in: ctx.cgContext)
        }
    }
}
