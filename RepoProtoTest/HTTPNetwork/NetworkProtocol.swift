//
//  NetworkProtocol.swift
//  CryptoBrow
//
//  Created by Jeoffrey Thirot on 12/02/2024.
//

import Combine
import Foundation

protocol NetworkProtocol {
    func createRequest(endPoint: EndPoint) -> URLRequest
    
    func sendRequest<T: Decodable>(endpoint: EndPoint) async throws -> T
    func sendRequest<T: Decodable>(endpoint: EndPoint, resultHandler: @escaping (Result<T, NetworkError>) -> Void)
    func sendRequest<T: Decodable>(endpoint: EndPoint, type: T.Type) -> AnyPublisher<T, NetworkError>
}

extension NetworkProtocol {
    func createRequest(endPoint: EndPoint) -> URLRequest {
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
}
