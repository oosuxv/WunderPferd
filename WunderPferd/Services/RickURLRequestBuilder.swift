//
//  RickURLRequestBuilder.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 24.05.2022.
//

import Foundation
import Alamofire

enum RickURLRequestBuilder: URLRequestConvertible {
    case locations(Int)
    
    var baseURL: URL {
        return URL(string: "https://rickandmortyapi.com/api")!
    }
    
    var method: HTTPMethod {
        switch self {
        default: return .get
        }
    }
    
    var path: String {
        switch self {
        case .locations: return "location"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        
        switch self {
        case let .locations(page):
            request = try URLEncodedFormParameterEncoder().encode(["page": page], into: request)
        }
        return request
    }
}
