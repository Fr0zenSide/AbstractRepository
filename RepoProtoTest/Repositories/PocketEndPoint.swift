//
//  PocketEndPoint.swift
//  CryptoBrow
//
//  Created by Jeoffrey Thirot on 29/03/2024.
//

import Foundation

enum PocketEndPoint: EndPoint {
    
    // MARK: - End Points declaration
    
    case list(_ params: [String: String] = [:])
    case detail(id: String)
    case relation(id: String)
    
    
    // MARK: Protperties
    
    var scheme: String { "http" }
    var host: String { "192.168.1.23" }
    var port: Int? { 8090 }
    var apiPath: String { "/api/collections/" }
    var apiFilePath: String { "/api/files/" }
    
    var path: String {
        switch self {
        case .list: return "users/records"
        case .detail(let id): return "relations/records/\(id)"
        case .relation(_): return "relations/records"
        }
    }
    
    var method: RequestMethod { .GET }
    
    var header: [String : String]? { ["accept": "application/json"] }
    
    var body: [String : String]? { nil }
    
    var queryParams: [String : String]? {
        switch self {
        case .list(let params):
            return ["perPage": "20",
                    "page": "1",
                    "sort": "-created,username"]
                .merging(params) { (_, new) in new } // override default params with arguments
        case .detail(_):
            return [:]
        case .relation(let id):
            return ["perPage": "20",
                    "page": "1",
                    "filter": "(owner.id='\(id)')",
                    "sort": "-created,type,user.username",
                    "expand": "owner,user"]
        }
    }
}

extension PocketEndPoint: EndPointUrl, EndPointMediaUrl {
    
    func getRequest() -> URLRequest {
        let endPoint = self
        var urlComponents = URLComponents()
        urlComponents.scheme = endPoint.scheme
        urlComponents.host = endPoint.host
        urlComponents.port = endPoint.port
        urlComponents.path = endPoint.apiPath + endPoint.path
        if let queryParams = endPoint.queryParams {
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = urlComponents.url else {
            // if you see this message, you need to rework the endPoint setup 😉
            preconditionFailure("Failed to create url with your endPoint setup.")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request.allHTTPHeaderFields = endPoint.header
        if let body = endPoint.body {
            let encoder = JSONEncoder()
            request.httpBody = try? encoder.encode(body)
        }
        return request
    }
    
    func getMediaRequest() -> URLRequest {
        let endPoint = self
        var urlComponents = URLComponents()
        urlComponents.scheme = endPoint.scheme
        urlComponents.host = endPoint.host
        urlComponents.port = endPoint.port
        urlComponents.path = endPoint.apiFilePath + endPoint.path.removes(of: "records")
//        if let queryParams = endPoint.queryParams {
//            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
//        }
        guard let url = urlComponents.url else {
            // if you see this message, you need to rework the endPoint setup 😉
            preconditionFailure("Failed to create media url with your endPoint setup.")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request.allHTTPHeaderFields = endPoint.header
        if let body = endPoint.body {
            let encoder = JSONEncoder()
            request.httpBody = try? encoder.encode(body)
        }
        return request
    }
}
