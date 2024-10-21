//
//  APiConstant.swift
//  NineSolAssignment
//
//  Created by Waqar on 16/11/2023.
//

import Foundation
public enum APIConstants {
    
    private enum ServerPath:String{
        case serverURL = "https://newsapi.org/v2/"
    }
    public static let baseUrl = ServerPath.serverURL.rawValue
    public static let apiKey = "c9a52b5b08f44b8595c0fc991daac920"
}
public enum ApiEndPoint {
    static let  getNews = "everything?"
    
}
