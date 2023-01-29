//
//  L102Language.swift
//  Localization102
//
//  Created by Moath_Othman on 2/24/16.
//  Copyright © 2016 Moath_Othman. All rights reserved.
//

import UIKit


class L102Language {
    
    class var currentLanguage: String {
        let lang = UserDefaults.standard.array(forKey: "AppleLanguages")!
        let firstLanguage = lang[0] as! String
        if firstLanguage.lowercased().range(of: "ar") != nil {
            return "ar"
        } else {
            return "en"
        }
    }
    
    class var isRTL: Bool {
        return L102Language.currentLanguage == "ar"
    }
    
    class func setLanguage(code: String) {
        UserDefaults.standard.set([code], forKey: "AppleLanguages")
    }
    
}

































//// constants
//let APPLE_LANGUAGE_KEY = "AppleLanguages"
///// L102Language
//class L102Language {
//    /// get current Apple language
//    class func currentAppleLanguage() -> String{
//        let userdef = UserDefaults.standard
//        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
//        let current = langArray.firstObject as! String
//        let endIndex = current.startIndex
//        let currentWithoutLocale = current.substring(to: current.index(endIndex, offsetBy: 2))
//        return currentWithoutLocale
//    }
//
//    class func currentAppleLanguageFull() -> String{
//        let userdef = UserDefaults.standard
//        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
//        let current = langArray.firstObject as! String
//        return current
//    }
//
//    /// set @lang to be the first in Applelanguages list
//    class func setAppleLAnguageTo(lang: String) {
//        let userdef = UserDefaults.standard
//        userdef.set([lang,currentAppleLanguage()], forKey: APPLE_LANGUAGE_KEY)
//        userdef.synchronize()
//    }
//
//    class var isRTL: Bool {
//        return L102Language.currentAppleLanguage() == "ar"
//    }
//}
