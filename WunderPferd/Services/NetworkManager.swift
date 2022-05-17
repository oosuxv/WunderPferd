//
//  NetworkManager.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 15.05.2022.
//

import Foundation
import Alamofire

protocol ProfileNetworkManager {
    
    func checkUsername(_ username: String, completion: ((UsernameResponse?, Error?) -> ())?)
    func register(_ username: String, _ password: String, completion: ((TokenResponse?, Error?) -> ())?)
    func login(_ username: String, _ password: String, completion: ((TokenResponse?, Error?) -> ())?)
    func getProfile(profileId: String, completion: ((Profile?, Error?) -> ())?)
}

class NetworkManager {
    
    func performRequest<ResponseType: Decodable>(
            request: URLRequestConvertible,
            headers: HTTPHeaders? = nil,
            onRequestCompleted: ((ResponseType?, Error?) -> ())?
    ) {
        AF.request(request)
            .validate()
            .responseData { (afDataResponse) in

            guard let data = afDataResponse.data, afDataResponse.error == nil
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

extension NetworkManager: ProfileNetworkManager {
    
    func checkUsername(_ username: String, completion: ((UsernameResponse?, Error?) -> ())?) {
        let request = Router.checkUsername(["username" : username])
        performRequest(request: request, onRequestCompleted: completion)
    }
    
    func register(_ username: String, _ password: String, completion: ((TokenResponse?, Error?) -> ())?) {
        let request = Router.register(["username" : username, "password" : password])
        performRequest(request: request, onRequestCompleted: completion)
    }
    
    func login(_ username: String, _ password: String, completion: ((TokenResponse?, Error?) -> ())?) {
        let request = Router.login(["username" : username, "password" : password])
        performRequest(request: request, onRequestCompleted: completion)
    }
    
    func getProfile(profileId: String, completion: ((Profile?, Error?) -> ())?) {
        let request = Router.profile(profileId)
        performRequest(request: request, onRequestCompleted: completion)
    }
}
