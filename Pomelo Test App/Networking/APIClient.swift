//
//  APIClient.swift
//  Pomelo Test App
//
//  Created by Achyuth Bujjigadu  on 27/12/21.
//

import Alamofire

enum APIError: Error {
    case noData
    case parsingError
}

enum APIClient {
    
    private static let session: Session = {
      let configuration = URLSessionConfiguration.af.default
      configuration.timeoutIntervalForRequest = 30
      return Session(configuration: configuration)
        
    }()

    static func isNetworkReachable() -> Bool {
        let manager = NetworkReachabilityManager(host: ApiConstants.Internet.url)
        return manager?.isReachable ?? false
    }

    static func getMostPopularList(completion: @escaping (Result<ResponseResult, APIError>) -> Void) {
        session.request(APIRouter.mostPopularList).responseJSON { response in
            guard case .success = response.result, response.response?.statusCode == 200 else {
                return
            }
            guard let data = response.data,
                  let apiResposne = try? JSONDecoder().decode(ResponseResult.self, from: data)
            else {
                return completion(.failure(.parsingError))
            }
            if let token = apiResposne as ResponseResult? {
                completion(.success(token))
            } else {
                completion(.failure(.noData))
            }
        }
    }
    
}
