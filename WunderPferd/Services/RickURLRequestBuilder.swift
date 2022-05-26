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
    case characters(String)
    
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
        case .characters: return "character"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var url = baseURL.appendingPathComponent(path)
        switch self {
        case let .characters(ids):
            url = url.appendingPathComponent(ids)
        default:
            break
        }
        
        var request = URLRequest(url: url)
        request.method = method
        
        switch self {
        case let .locations(page):
            request = try URLEncodedFormParameterEncoder().encode(["page": page], into: request)
        default:
            break
        }
        return request
    }
}
