//
//  Helper.swift
//  EverDeliever
//
//  Created by Ahmed on 4/28/22.
//

import Foundation
import UIKit

//MARK:- HelperConstant
class HelperConstant: NSObject {
    
    //MARK:- userDefault
    static let userDefault = UserDefaults.standard
    
    //MARK:- Save Aceess Token
    class func saveToken(access_token: String){
        
        userDefault.set(access_token, forKey: "access_token")
    }
    //MARK:- Get Aceess Token
    class func getToken() -> String?{
        let defult = UserDefaults.standard
        
        return defult.object(forKey: "access_token") as? String
    }
    
    //MARK:- Save Aceess Token
    class func saveCurrency(currency: String){
        
        userDefault.set(currency, forKey: "currency")
    }
    //MARK:- Get Aceess Token
    class func getCurrency() -> String?{
        let defult = UserDefaults.standard
        
        return defult.object(forKey: "currency") as? String
    }
    
    //MARK:- Save Aceess Token
    class func saveName(name: String){
        
        userDefault.set(name, forKey: "name")
    }
    //MARK:- Get Aceess Token
    class func getName() -> String?{
        let defult = UserDefaults.standard
        
        return defult.object(forKey: "name") as? String
    }
    
    //MARK:- Save Aceess Token
    class func saveUserId(userId: Int){
        
        userDefault.set(userId, forKey: "userId")
    }
    //MARK:- Get Aceess Token
    class func getUserId() -> Int?{
        let defult = UserDefaults.standard
        
        return defult.object(forKey: "userId") as? Int
    }
    
    //MARK:- Save Aceess Token
    class func saveUserIdFaceId(userId: Int){
        
        userDefault.set(userId, forKey: "userId")
    }
    //MARK:- Get Aceess Token
    class func getUserIdFaceId() -> Int?{
        let defult = UserDefaults.standard
        
        return defult.object(forKey: "userId") as? Int
    }
    
    //MARK:- Save Aceess Token
    class func savePhoneFaceId(phoneFaceId: String){
        
        userDefault.set(phoneFaceId, forKey: "phoneFaceId")
    }
    //MARK:- Get Aceess Token
    class func getPhoneFaceId() -> String?{
        let defult = UserDefaults.standard
        
        return defult.object(forKey: "phoneFaceId") as? String
    }
    
    //MARK:- Save Aceess Token
    class func saveIsoCodeFaceId(isoCodeFaceId: String){
        
        userDefault.set(isoCodeFaceId, forKey: "isoCodeFaceId")
    }
    //MARK:- Get Aceess Token
    class func getIsoCodeFaceId() -> String?{
        let defult = UserDefaults.standard
        
        return defult.object(forKey: "isoCodeFaceId") as? String
    }
    
    //MARK:- Save Aceess Token
    class func saveCountryCodeFaceId(countryCodeFaceId: String){
        
        userDefault.set(countryCodeFaceId, forKey: "countryCodeFaceId")
    }
    //MARK:- Get Aceess Token
    class func getCountryCodeFaceId() -> String?{
        let defult = UserDefaults.standard
        
        return defult.object(forKey: "countryCodeFaceId") as? String
    }
    
    //MARK:- Save Aceess Token
    class func saveNameFaceId(nameFaceId: String){
        
        userDefault.set(nameFaceId, forKey: "nameFaceId")
    }
    //MARK:- Get Aceess Token
    class func getNameFaceId() -> String?{
        let defult = UserDefaults.standard
        
        return defult.object(forKey: "nameFaceId") as? String
    }
    
    //MARK:- Save Aceess Token
    class func saveOffst(offset: Int){
        
        userDefault.set(offset, forKey: "offset")
    }
    //MARK:- Get Aceess Token
    class func getOffst() -> Int?{
        let defult = UserDefaults.standard
        
        return defult.object(forKey: "offset") as? Int
    }
    
    //MARK:- Save For Fast Order
    class func saveFastOrder(fastOrder: String){
        
        userDefault.set(fastOrder, forKey: "fastOrder")
    }
    //MARK:- Get For Fast Order
    class func getFastOrder() -> String?{
        let defult = UserDefaults.standard
        
        return defult.object(forKey: "fastOrder") as? String
    }
    
    //MARK:- Save For Fast Order
    class func saveLocationLat(locationLat: Double){
        
        userDefault.set(locationLat, forKey: "lat")
    }
    //MARK:- Get For Fast Order
    class func getLocationLat() -> Double? {
        let defult = UserDefaults.standard
        
        return defult.object(forKey: "lat") as? Double
    }
    
    //MARK:- Save For Fast Order
    class func saveLocationLong(locationLong: Double) {
        
        userDefault.set(locationLong, forKey: "long")
    }
    //MARK:- Get For Fast Order
    class func getLocationLong() -> Double? {
        let defult = UserDefaults.standard
        
        return defult.object(forKey: "long") as? Double
    }
    
    //MARK:- Save For Fast Order
    class func saveLocationTitle(locationTitle: String) {
        
        userDefault.set(locationTitle, forKey: "title")
    }
    //MARK:- Get For Fast Order
    class func getLocationTitle() -> String? {
        let defult = UserDefaults.standard
        
        return defult.object(forKey: "title") as? String
    }
    
    //MARK:- Save For Fast Order
    class func saveLocationDesc(locationDesc: String) {
        
        userDefault.set(locationDesc, forKey: "Desc")
    }
    //MARK:- Get For Fast Order
    class func getLocationDesc() -> String? {
        let defult = UserDefaults.standard
        
        return defult.object(forKey: "Desc") as? String
    }
    
//    //MARK:- Save Aceess RememberToken
//    class func saveRememberToken(remember_token: String){
//
//        userDefault.set(remember_token, forKey: "remember_token")
//    }
//    //MARK:- Get Aceess RememberToken
//    class func getRememberToken() -> String?{
//        let defult = UserDefaults.standard
//
//        return defult.object(forKey: "remember_token") as? String
//    }
//
//    //MARK:- Save User ID
//    class func saveUerID(ID: Int){
//
//        userDefault.set(ID, forKey: "id")
//    }
//    //MARK:- Get User ID
//    class func getUserID() -> Int?{
//        let defult = UserDefaults.standard
//
//        return defult.object(forKey: "id") as? Int
//    }
//
//    //MARK:- Save User ID
//    class func saveUerIDFromReg(ID: Int){
//
//        userDefault.set(ID, forKey: "user_id")
//    }
//    //MARK:- Get User ID
//    class func getUserIDFromReg() -> Int?{
//        let defult = UserDefaults.standard
//
//        return defult.object(forKey: "user_id") as? Int
//    }
//
//    //MARK:- Save Name
//    class func saveName(name: String){
//
//        userDefault.set(name, forKey: "name")
//    }
//    //MARK:- Get Name
//    class func getName() -> String?{
//        let defult = UserDefaults.standard
//
//        return defult.object(forKey: "name") as? String
//    }
//
//    //MARK:- Save UserType
//    class func saveUserType(UserType: String){
//
//        userDefault.set(UserType, forKey: "UserType")
//    }
//    //MARK:- Get UserType
//    class func getUserType() -> String?{
//        let defult = UserDefaults.standard
//
//        return defult.object(forKey: "UserType") as? String
//    }
//
//    //MARK:- Save Email
//    class func saveEmail(email: String){
//
//        userDefault.set(email, forKey: "email")
//    }
//    //MARK:- Get Email
//    class func getEmail() -> String?{
//        let defult = UserDefaults.standard
//
//        return defult.object(forKey: "email") as? String
//    }
//    //MARK:- Save Password
//    class func savePassword(password: String){
//
//        userDefault.set(password, forKey: "password")
//    }
//    //MARK:- Get Password
//    class func getPassword() -> String?{
//        let defult = UserDefaults.standard
//
//        return defult.object(forKey: "password") as? String
//    }
//
//    //MARK:- Save EmailOrPhone
//    class func saveEmailOrPhone(EmailOrPhone: String){
//
//        userDefault.set(EmailOrPhone, forKey: "EmailOrPhone")
//    }
//    //MARK:- Get EmailOrPhone
//    class func getEmailOrPhone() -> String?{
//        let defult = UserDefaults.standard
//
//        return defult.object(forKey: "EmailOrPhone") as? String
//    }
//
//    //MARK:- Save Password SignUp
//    class func savePasswordSignUp(password: String){
//
//        userDefault.set(password, forKey: "passwordSignUp")
//    }
//    //MARK:- Get Password SignUp
//    class func getPasswordSignUp() -> String?{
//        let defult = UserDefaults.standard
//
//        return defult.object(forKey: "passwordSignUp") as? String
//    }
//    //
//    //MARK:- Save EmailOrPhone
//    class func saveEmailOrPhoneLogin(EmailOrPhone: String){
//
//        userDefault.set(EmailOrPhone, forKey: "EmailOrPhoneLogin")
//    }
//    //MARK:- Get EmailOrPhone
//    class func getEmailOrPhoneLogin() -> String?{
//        let defult = UserDefaults.standard
//
//        return defult.object(forKey: "EmailOrPhoneLogin") as? String
//    }
//
//    //MARK:- Save Password SignUp
//    class func savePasswordLogin(password: String){
//
//        userDefault.set(password, forKey: "passwordLogin")
//    }
//    //MARK:- Get Password SignUp
//    class func getPasswordLogin() -> String?{
//        let defult = UserDefaults.standard
//
//        return defult.object(forKey: "passwordLogin") as? String
//    }
//    //
//
//    //MARK:- Save Location Address
//    class func saveLocationAddress(address: String){
//
//        userDefault.set(address, forKey: "address")
//    }
//    //MARK:- Get Location Address
//    class func getLocationAddress() -> String?{
//        let defult = UserDefaults.standard
//
//        return defult.object(forKey: "address") as? String
//    }
//    //MARK:- Save Location City
//    class func saveLocationCity(city: String){
//
//        userDefault.set(city, forKey: "city")
//    }
//    //MARK:- Get Location City
//    class func getLocationCity() -> String?{
//        let defult = UserDefaults.standard
//
//        return defult.object(forKey: "city") as? String
//    }
//
//    //MARK:- Save Location Id
//    class func saveLocationId(id: Int){
//
//        userDefault.set(id, forKey: "addressId")
//    }
//    //MARK:- Get Location Id
//    class func getLocationId() -> Int?{
//        let defult = UserDefaults.standard
//
//        return defult.object(forKey: "addressId") as? Int
//    }
    
}
