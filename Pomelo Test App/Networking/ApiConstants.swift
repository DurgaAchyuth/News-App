//
//  ApiConstants.swift
//  Pomelo Test App
//
//  Created by Achyuth Bujjigadu  on 27/12/21.
//

import Foundation

public enum ApiConstants {
    enum Internet {
        static let url = "https://www.google.com/"
    }

    enum ApiMethodsUrls {
        static let mostPopular = "mostpopular/v2/emailed/7.json"
    }

    enum APIParameterKey {
        static let apikey = "api-key"
    }
    
    enum AppMessages {
        static let parsingError = "Parsing Error, Please try again."
        static let noData = "No data found...!"
        static let unknowError = "Unknow Error Occured, Please try again!"
        static let appTitle = "App Title Name"
        static let noInternet = "No Internet connection available, Please check it!"
    }
}

public enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case xApiKey = "x-api-key"
}

public enum ContentType: String {
    case json = "application/json"
}
