//
//  NetworkManager.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 29.04.2022.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol {
    
}

class NetworkManager: NetworkManagerProtocol {
    func performRequest<ResponseType: Decodable>(
            url: String,
            method: HTTPMethod,
            parameters: Parameters? = nil,
            headers: HTTPHeaders? = nil,
            onRequestStarted: (() -> ())?,
            onRequestCompleted: ((ResponseType?, Error?) -> ())?
        ) {
            onRequestStarted?()
            AF.request(url,
                       method: method,
                       parameters: parameters,
                       encoding: JSONEncoding.default,
                       headers: headers)
                .validate()
                .responseData { (afDataResponse) in
                    
                    guard let data = afDataResponse.data,
                          afDataResponse.error == nil
                    else {
                        onRequestCompleted?(nil, afDataResponse.error)
                        return
                    }
                    
                    do {
                        let decodedValue: ResponseType = try JSONDecoder().decode(ResponseType.self, from: data)
                        onRequestCompleted?(decodedValue, nil)
                    }
                    catch (let error) {
                        print("Response parsing error: \(error.localizedDescription)")
                        onRequestCompleted?(nil, error)
                    }
                }
        }
}
