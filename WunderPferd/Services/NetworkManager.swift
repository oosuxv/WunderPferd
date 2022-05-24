//
//  NetworkManager.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 29.04.2022.
//

import Foundation
import Alamofire

protocol CharacterNetworkManager {
    func getCharacter(id: Int, completion: ((Character?, Error?) -> ())?)
}

protocol ImageNetworkManager {
    func getImage(urlString: String, completion: ((Data?, Error?) -> ())?)
}

extension NetworkManager : ImageNetworkManager {
    func getImage(urlString: String, completion: ((Data?, Error?) -> ())?) {
        dataRequest(url: urlString, method: .get, onRequestCompleted: completion)
    }
}

extension NetworkManager: CharacterNetworkManager {
    func getCharacter(id: Int, completion: ((Character?, Error?) -> ())?) {
        performRequest(url: "https://rickandmortyapi.com/api/character/\(id)", method: .get, onRequestCompleted: completion)
    }
}

class NetworkManager {
    func performRequest<ResponseType: Decodable>(
            url: String,
            method: HTTPMethod,
            parameters: Parameters? = nil,
            headers: HTTPHeaders? = nil,
            onRequestCompleted: ((ResponseType?, Error?) -> ())?
        ) {
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
    
    func dataRequest (
            url: String,
            method: HTTPMethod,
            parameters: Parameters? = nil,
            headers: HTTPHeaders? = nil,
            onRequestCompleted: ((Data?, Error?) -> ())?
        ) {
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
                    
                    
                        
                        onRequestCompleted?(data, nil)
                    
                }
        }
}
