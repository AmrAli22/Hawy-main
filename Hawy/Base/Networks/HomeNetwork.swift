//
//  HomeNetwork.swift
//  Hawy
//
//  Created by ahmed abu elregal on 07/09/2022.
//

import Foundation
import Alamofire

enum HomeNetwork {
    case categories
    case subCategories(categoryId: Int?)
    case sliders
    case cards(subCategoryId: Int?)
    case categoryAndSub
    case addedCardDetails(name: String?, mother_name: String?, father_name: String?, age: String?, main_image: String?, images: [String]?, video: String?, category_id: String?, notes: String?, status: String?, inoculations: [String]?, owners: [String]?, docNum: String?)
    case myAuctions(type: String?)
    case profileMyCards(type: String?, id: Int?)
    //case addSaleAuctionFromHome(day: String?, start_time: String?, name: String?, cards: )
    case avatars
    case profileMyAuctions(id: Int?)
    
    
}

extension HomeNetwork: TargetType {
    var baseURL: String {
        return "https://hawy-kw.com/api"
    }
    
    var path: String {
        switch self {
        case .categories:
            return "/categories"
        case .subCategories(let categoryId):
            return "/subCategories?category_id=\(categoryId ?? 0)"
        case .sliders:
            return "/sliders"
        case .cards(let subCategoryId):
            return "/subCategories?category_id=\(subCategoryId ?? 0)"
        case .categoryAndSub:
            return "/categories/sub"
        case .addedCardDetails:
            return "/auth/profile/cards/store"
            
        case .myAuctions(let type):
            return "/auctions/sales?auction_date=\(type ?? "")&time_from=\(Int(Date.currentTimeStamp))"
            
        case .profileMyCards(let type, let id):
            return "/auth/profile/cards?type=\(type ?? "")&user_id=\(id ?? 0)"
        case .avatars:
            return "/avatars"
        case .profileMyAuctions(let id):
            return "/profile/auctions?user_id=\(id ?? 0)"
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .categories:
            return .get
        case .subCategories:
            return .get
        case .sliders:
            return .get
        case .cards:
            return .get
        case .categoryAndSub:
            return .get
        case .addedCardDetails:
            return .post
            
        case .myAuctions:
            return .get
        case .profileMyCards:
            return .get
        case .avatars:
            return .get
        case .profileMyAuctions:
            return .get
            
        }
    }
    
    var task: TaskRequest {
        switch self {
        case .categories:
            return .requestPlain
        case .subCategories:
            return .requestPlain
        case .sliders:
            return .requestPlain
        case .cards:
            return .requestPlain
        case .categoryAndSub:
            return .requestPlain
        case .addedCardDetails(let name, let mother_name, let father_name, let age, let main_image, let images, let video, let category_id, let notes, let status,let inoculations, let owners, let docNum):
            return .requestParameters(parameters: ["name": name ?? "", "mother_name": mother_name ?? "", "father_name": father_name ?? "", "age": age ?? "", "main_image": main_image ?? "", "images": images ?? "", "video": video ?? "", "category_id": category_id ?? "", "notes": notes ?? "", "status": status ?? "", "inoculations": inoculations ?? "", "owners": owners ?? "", "documentation_number": docNum ?? ""], encoding: JSONEncoding.default)
            
        case .myAuctions:
            return .requestPlain
        case .profileMyCards:
            return .requestPlain
        case .avatars:
            return .requestPlain
            
        case .profileMyAuctions:
            return .requestPlain
            
        }
    }

    
    var headers: [String : String]? {
        switch self {
        case .categories:
            return [
                "Content-Type":"application/json",
                "Accept":"application/json",
                "Accept-Language":AppLocalization.currentAppleLanguage(),
                "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
                "offset": "\(HelperConstant.getOffst() ?? 0)"
            ]
        case .subCategories:
            return [
                "Content-Type":"application/json",
                "Accept":"application/json",
                "Accept-Language":AppLocalization.currentAppleLanguage(),
                "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
                "offset": "\(HelperConstant.getOffst() ?? 0)"
            ]
        case .sliders:
            return [
                "Content-Type":"application/json",
                "Accept":"application/json",
                "Accept-Language":AppLocalization.currentAppleLanguage(),
                "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
                "offset": "\(HelperConstant.getOffst() ?? 0)"
            ]
        case .cards:
            return [
                "Content-Type":"application/json",
                "Accept":"application/json",
                "Accept-Language":AppLocalization.currentAppleLanguage(),
                "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
                "offset": "\(HelperConstant.getOffst() ?? 0)"
            ]
        case .categoryAndSub:
            return [
                "Content-Type":"application/json",
                "Accept":"application/json",
                "Accept-Language":AppLocalization.currentAppleLanguage(),
                "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
                "offset": "\(HelperConstant.getOffst() ?? 0)"
            ]
        case .addedCardDetails:
            return [
                "Content-Type":"application/json",
                "Accept":"application/json",
                "Accept-Language":AppLocalization.currentAppleLanguage(),
                "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
                "offset": "\(HelperConstant.getOffst() ?? 0)"
            ]
            
        case .myAuctions:
            return [
                "Content-Type":"application/json",
                "Accept":"application/json",
                "Accept-Language":AppLocalization.currentAppleLanguage(),
                "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
                "offset": "\(HelperConstant.getOffst() ?? 0)"
            ]
            
        case .profileMyCards:
            return [
                "Content-Type":"application/json",
                "Accept":"application/json",
                "Accept-Language":AppLocalization.currentAppleLanguage(),
                "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
                "offset": "\(HelperConstant.getOffst() ?? 0)"
            ]
            
        case .avatars:
            return [
                "Content-Type":"application/json",
                "Accept":"application/json",
                "Accept-Language":AppLocalization.currentAppleLanguage(),
                "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
                "offset": "\(HelperConstant.getOffst() ?? 0)"
            ]
        case .profileMyAuctions:
            return [
                "Content-Type":"application/json",
                "Accept":"application/json",
                "Accept-Language":AppLocalization.currentAppleLanguage(),
                "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
                "offset": "\(HelperConstant.getOffst() ?? 0)"
            ]
            
        default:
            return [
                "Content-Type":"application/json",
                "Accept":"application/json",
                "Accept-Language":AppLocalization.currentAppleLanguage(),
                "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
                "offset": "\(HelperConstant.getOffst() ?? 0)"
            ]
        }
    }
}

