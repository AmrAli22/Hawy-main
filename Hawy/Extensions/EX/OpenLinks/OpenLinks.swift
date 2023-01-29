//
//  OpenLinks.swift
//  MVVM
//
//  Created by Ahmed on 6/7/21.
//

import Foundation
import UIKit

class OpenLink: NSObject {
    
    class func OpenURL(url: String) {
        let urlComponents = URLComponents (string: url)!
        UIApplication.shared.open (urlComponents.url!)
    }
    
}
