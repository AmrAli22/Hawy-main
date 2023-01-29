//
//  URLS.swift
//  EverDeliever
//
//  Created by Ahmed on 5/9/22.
//

import Foundation

//MARK:- URLS Constant
struct URLS {
    
    //http://e63f-197-61-158-0.ngrok.io
    //https://ever-deliver.moltaqa-wo.net/
    //http://10.0.0.251/laravel/ever-deliver/public/
    //https://ever-deliver.com/
    
    static let baseURL            =  "https://ever-deliver.com/"
    static let baseImageURL       =  "https://hawy-kw.com"
    
    static let uploadImage        =  baseURL+"api/upload_image"
    
    static let addToCart          =  baseURL+"api/cart/add"
    
    static let addLocation        =  baseURL+"api/addresses/add"
    static let updateLocation     =  baseURL+"api/addresses/update"
    static let removeLocation     =  baseURL+"api/addresses/remove"
    static let defualtLocation    =  baseURL+"api/addresses/current"
    static let listLocation       =  baseURL+"api/addresses"
    
    static let chat               =  baseURL+"api/chat_messages"
    
    static let distance           =  baseURL+"api/addresses/distance"
    
}
