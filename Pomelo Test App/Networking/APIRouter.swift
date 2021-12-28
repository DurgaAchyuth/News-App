//
//  APIRouter.swift
//  Pomelo Test App
//
//  Created by Achyuth Bujjigadu  on 27/12/21.
//

import Alamofire

enum APIRouter: URLRequestConvertible {
    case mostPopularList
    
    // MARK: - HTTPMethod

    private var method: HTTPMethod {
        switch self {
        case .mostPopularList:
            return .get
        }
    }
    
    // MARK: - Path

    private var path: String {
        switch self {
        case .mostPopularList:
            return ApiConstants.ApiMethodsUrls.mostPopular
        }
    }
    
    // MARK: - Parameters

    private var parameters: Parameters? {
        switch self {
        case .mostPopularList:
            return .none
        }
    }

    // MARK: - URLRequestConvertible

    func asURLRequest() throws -> URLRequest {
        let queryItems = [URLQueryItem(name: ApiConstants.APIParameterKey.apiParameterkey, value: ApiConstants.APIParameterKey.xApiKey)]
        var urlComps = URLComponents(string: Enviroment.current.baseURL)!
        urlComps.queryItems = queryItems
        let resultUrl = urlComps.url!
        let url = try resultUrl.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        // Parameters
        if let parameters = parameters {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                let jsonString = String(decoding: jsonData, as: UTF8.self)
                print(jsonString)
                urlRequest.httpBody = jsonData

            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        } else {
            urlRequest.httpBody = nil
        }
        return urlRequest
    }
}
