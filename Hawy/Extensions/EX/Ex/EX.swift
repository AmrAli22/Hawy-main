//
//  EX.swift
//  MVVM
//
//  Created by Ahmed on 5/1/21.
//

import Foundation
import UIKit
//import MBProgressHUD

extension UIViewController {
    
//    func showIndicator(withTitle title: String, and description: String) {
//        let indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
//        indicator.label.text = title
//        indicator.isUserInteractionEnabled = false
//        indicator.customView?.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        indicator.detailsLabel.text = description
//        indicator.show(animated: true)
//        self.view.isUserInteractionEnabled = false
//    }
//    func hideIndicator() {
//        MBProgressHUD.hide(for: self.view, animated: true)
//        self.view.isUserInteractionEnabled = true
//    }
    
}
extension UINavigationController {
    func push(VC: UIViewController) {
        let transetion = CATransition()
        transetion.duration = 0.5
        transetion.type = CATransitionType.push
        transetion.subtype = CATransitionSubtype.fromRight
        transetion.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transetion, forKey: kCATransition)
        pushViewController(VC, animated: false)
        //navigationController?.modalPresentationStyle = .formSheet
        //navigationController?.pushViewController(walletVC, animated: true)
        //navigationController?.push(VC: walletVC)
    }
}

extension String {
    var Localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

extension String{
//    var localized:String {
//        return NSLocalizedString(self, comment: "")
//    }
    
    public var replacedArabicDigitsWithEnglish: String {
        var str = self
        let map = ["٠": "0","١": "1","٢": "2","٣": "3","٤": "4","٥": "5","٦": "6","٧": "7", "٨": "8","٩": "9"]
        map.forEach { str = str.replacingOccurrences(of: $0, with: $1) }
        return str
    }
    public var replacedEnglishDigitsWithArabic: String {
        var str = self
        let map = ["0":"٠","1":"١","2":"٢","3":"٣","4":"٤","5":"٥","6":"٦","7":"٧","8":"٨","9":"٩"]
        map.forEach { str = str.replacingOccurrences(of: $0, with: $1) }
        return str
    }
}
extension Date {
    
    func convertToMonthYearFormat() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        //MMM dd yyyy
        //MMM yyyy
        //yyyy-MM-dd'T'HH:mm:ssZ
        return dateFormatter.string(from: self)
    }
    
}
extension String {
    
    func conveertToDate() -> Date? {
        
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale        = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone      = .current
        
        return dateFormatter.date(from: self)
        
    }
    
    func convertToDisplayformat() -> String {
        
        guard let date = self.conveertToDate() else { return "N/A" }
        
        return date.convertToMonthYearFormat()
    }
    
}
extension String {
    func maxLength(length: Int) -> String {
        var str = self
        let nsString = str as NSString
        if nsString.length >= length {
            str = nsString.substring(with:
                                        NSRange(
                                            location: 0,
                                            length: nsString.length > length ? length : nsString.length)
            )
        }
        return  str
    }
}
extension String{
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
}
extension String {
    
    func utf8DecodedString()-> String {
        let data = self.data(using: .utf8)
        if let message = String(data: data!, encoding: .nonLossyASCII){
            return message
        }
        return ""
    }
    
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8)
        return text!
    }
    
}

extension String {
    
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,3})$").evaluate(with: self)
    }
    var isValidPhone: Bool {
        //NSPredicate(format: "SELF MATCHES %@", "^[0-9]{10}$").evaluate(with: self)
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: self)
    }
    
    func isValidPhone(phone: String?) -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    
    func isValidEmaiil() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let emailRegex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: .caseInsensitive)
        let valid = emailRegex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        print("Email validation \(valid)")
        return valid
    }
    // vrify Valid PhoneNumber or Not
    func isValidPhonee() -> Bool {
        //"^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneRegex = try! NSRegularExpression(pattern: "^[0-9+]{0,1}+[0-9]{5,16}$", options: .caseInsensitive)
        let valid = phoneRegex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        print("phone validation \(valid)")
        return valid
    }
    func applyPatternOnNumbers(pattern:String = "+# (###) ###-####", replacmentCharacter:Character = "#") -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            //let stringIndex = String.Index(encodedOffset: index)
            let stringIndex = String.Index(utf16Offset: index, in: pureNumber)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
    
    func isValidPassword() -> Bool {
        //"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        //"^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    func isValidStrongPassword() -> Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 8 characters total
        let password = self.trimmingCharacters(in: CharacterSet.whitespaces)
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)

    }
    
}

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(
            NSAttributedString.Key.strikethroughStyle,
               value: NSUnderlineStyle.single.rawValue,
                   range:NSMakeRange(0,attributeString.length))
        return attributeString
    }
}


