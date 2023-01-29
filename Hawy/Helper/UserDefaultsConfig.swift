//
//  UserDefaultsConfig.swift
//  EverDeliever
//
//  Created by Ahmed on 4/7/22.
//

import Foundation

enum UserDefaultsKeys: String {
    case user
    case update
}

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}



extension UserDefaults {
    
    func save<T:Encodable>(customObject object: T, inKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(object) {
            self.set(encoded, forKey: key)
        }
    }
    
    func retrieve<T:Decodable>(object type:T.Type, fromKey key: String) -> T? {
        if let data = self.data(forKey: key) {
            let decoder = JSONDecoder()
            if let object = try? decoder.decode(type, from: data) {
                return object
            }else {
                print("Couldnt decode object")
                return nil
            }
        }else {
            print("Couldnt find key")
            return nil
        }
    }
    
    
    func setMockMessages(count: Int) {
        set(count, forKey: "mockMessages")
        synchronize()
    }
    
    func mockMessagesCount() -> Int {
        if let value = object(forKey: "mockMessages") as? Int {
            return value
        }
        return 20
    }
    
}

struct UserDefaultsConfig {
    static func  saveFirebaseToken(token:String) {
        
        let def = UserDefaults.standard
        def.setValue(token, forKey: "firebaseToken")
        def.synchronize()
        
    }
    
    static func getFirebaseToken() -> String? {
        
        let def = UserDefaults.standard
        if let token: String = def.object(forKey: "firebaseToken") as? String {
            print("token from helper::", token)
            return token
        } else {
            return ""
        }
    }
}

//MARK:- Helper
class Helper: NSObject {
    
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
    class func saveTokenGuide(access_token: String){
        
        userDefault.set(access_token, forKey: "access_token2")
    }
    //MARK:- Get Aceess Token
    class func getTokenGuide() -> String?{
        let defult = UserDefaults.standard
        
        return defult.object(forKey: "access_token2") as? String
    }
    //online
    
    //MARK:- Save Aceess Token
    class func saveOnline(access_token: Bool){
        
        userDefault.set(access_token, forKey: "online")
    }
    
    //MARK:- Get Aceess Token
    class func getOnline() -> Bool?{
        let defult = UserDefaults.standard
        
        return defult.object(forKey: "online") as? Bool
    }
    
    //MARK:- Save Aceess Token
    class func saveFCM(fcm: String){
        
        userDefault.set(fcm, forKey: "fcm")
    }
    
    //MARK:- Get Aceess Token
    class func getFCM() -> String?{
        let defult = UserDefaults.standard
        
        return defult.object(forKey: "fcm") as? String
    }
    
    //MARK:- Save Location Lat Address
    class func saveLocationLatAddress(address: Double){
        
        userDefault.set(address, forKey: "lat")
    }
    //MARK:- Get Location Lat Address
    class func getLocationLatAddress() -> Double?{
        let defult = UserDefaults.standard
        
        return defult.object(forKey: "lat") as? Double
    }
    //MARK:- Save Location Long Address
    class func saveLocationLongAddress(city: Double){
        
        userDefault.set(city, forKey: "long")
    }
    //MARK:- Get Location Long Address
    class func getLocationLongAddress() -> Double?{
        let defult = UserDefaults.standard
        
        return defult.object(forKey: "long") as? Double
    }
    
}

//
//  UserManager.swift
//  MAURICAR
//
//  Created by Enas Abdallah on 19/11/2021.
//

//import Foundation
//
//final class UserManager {
//
//    static let shared = UserManager()
//
//    func loadUser() {
//        guard UserManager.userLoggedIn else {
//            UserManager.deleteCurrentUser()
//            return
//        }
//
//
//    }
//
////     func fetchPreofile() {
////        ClientProfileRequest.profile.send(AuthResponse.self){ [weak self](response) in
////         guard let _ = self else { return }
////            switch response {
////            case .failure(let error):
////                guard let errorMessage = error as? APIError else {
////                    print( error?.localizedDescription ?? "" )
////
////                    return
////                }
////                print( errorMessage.localizedDescription )
////
////
////            case .success(let value):
////                User.currentUser = value.data
////
////            }
////        }
////    }
////
//
//
//    static func deleteCurrentUser() {
//        KeyChain.deleteToken()
//        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.user.rawValue)
//    }
//
//    static var userLoggedIn: Bool {
//        return KeyChain.tokenExist && User.currentUser != nil
//    }
//}
