//
//  EndPoint.swift
//  CryptoBrow
//
//  Created by Jeoffrey Thirot on 12/02/2024.
//

import Foundation

public enum RequestMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

public protocol EndPoint {
    var host: String { get }
    var port: Int? { get }
    var scheme: String { get }
    var apiPath: String { get }
    var apiFilePath: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
    var queryParams: [String: String]? { get } // Added for query parameters
//    var pathParams: [String: String]? { get }  // Added for path parameters
}

extension EndPoint {
    var scheme: String { "https" }
    var port: Int? { nil }
    
    var apiPath: String { "" }
    var apiFilePath: String { "" }
}


// MARK: - Useful to manage url of endPoint

public protocol EndPointUrl {
    func getRequest() -> URLRequest
}

public protocol EndPointMediaUrl {
    func getMediaRequest() -> URLRequest
}
