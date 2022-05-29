//
//  NetworkManager.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 15.05.2022.
//

import Foundation
import Alamofire

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
                ServiceLocator.logger.info("response parse failed: \(error.localizedDescription)")
                onRequestCompleted?(nil, error)
            }
        }
    }
    
    func performRequest(
            url: String,
            method: HTTPMethod = .get,
            headers: HTTPHeaders? = nil,
            onRequestCompleted: ((Data?, Error?) -> ())?
    ) {
        AF.request(url, method: method, headers: headers)
            .validate()
            .responseData { (afDataResponse) in

            guard let data = afDataResponse.data, afDataResponse.error == nil
            else {
                onRequestCompleted?(nil, afDataResponse.error)
                return
            }
            onRequestCompleted?(data, nil)
        }
    }
}

extension NetworkManager: ProfileNetworkManager {
    
    func getProfile(profileId: String, completion: ((Profile?, Error?) -> ())?) {
        let request = ProfileURLRequestBuilder.profile(profileId)
        performRequest(request: request, onRequestCompleted: completion)
    }
}

extension NetworkManager: AuthorizeNetworkManager {
    func login(_ username: String, _ password: String, completion: ((TokenResponse?, Error?) -> ())?) {
        let request = ProfileURLRequestBuilder.login(["username" : username, "password" : password])
        performRequest(request: request, onRequestCompleted: completion)
    }
}

extension NetworkManager: LocationNetworkManager {
    
    func getLocations(page: Int, completion: ((LocationsResponse?, Error?) -> ())?) {
        let request = RickURLRequestBuilder.locations(page)
        performRequest(request: request, onRequestCompleted: completion)
    }
}

extension NetworkManager: RegisterNetworkManager {
    
    func checkUsername(_ username: String, completion: ((UsernameResponse?, Error?) -> ())?) {
        let request = ProfileURLRequestBuilder.checkUsername(["username" : username])
        performRequest(request: request, onRequestCompleted: completion)
    }
    
    func register(_ username: String, _ password: String, completion: ((TokenResponse?, Error?) -> ())?) {
        let request = ProfileURLRequestBuilder.register(["username" : username, "password" : password])
        performRequest(request: request, onRequestCompleted: completion)
    }
}

extension NetworkManager: CharacterNetworkManager {
    
    func getCharacter(id: String, completion: ((Character?, Error?) -> ())?) {
        let request = RickURLRequestBuilder.characters(id)
        performRequest(request: request, onRequestCompleted: completion)
    }
    
    func getMultipleCharacters(idListCommaSeparated ids: String, completion: (([Character]?, Error?) -> ())?) {
        let request = RickURLRequestBuilder.characters(ids)
        performRequest(request: request, onRequestCompleted: completion)
    }
}

extension NetworkManager: ImageNetworkManager {
    
    func getImage(url: String, completion: ((Data?, Error?) -> ())?) {
        performRequest(url: url, onRequestCompleted: completion)
    }
}
