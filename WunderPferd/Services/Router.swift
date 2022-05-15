//
//  ProfileNetworkManager.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 15.05.2022.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    case checkUsername([String: String])
    case register([String: String])
    case login([String: String])
    
    var baseURL: URL {
        return URL(string: "https://nanopost.evolitist.com")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .checkUsername: return .get
        case .register: return .post
        case .login: return .get
        }
    }
    
    var path: String {
        switch self {
        case .checkUsername: return "api/auth/checkUsername"
        case .register: return "api/auth/register"
        case .login: return "api/auth/login"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        
        switch self {
        case let .checkUsername(parameters):
            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        case let .register(parameters):
            request = try JSONParameterEncoder().encode(parameters, into: request)
        case let .login(parameters):
            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        }
        return request
    }
}

