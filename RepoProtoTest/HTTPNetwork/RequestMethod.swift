//
//  RequestMethod.swift
//  CryptoBrow
//
//  Created by Jeoffrey Thirot on 12/02/2024.
//

import Combine
import Foundation

extension NetworkProtocol {
    func sendRequest<T: Decodable>(endpoint: EndPoint) async throws -> T {
        let urlRequest = createRequest(endPoint: endpoint)
        
        return try await withCheckedThrowingContinuation { continuation in
            let task = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
                .dataTask(with: urlRequest) { data, response, error in
                    if let error {
                        continuation.resume(throwing: NetworkError.unknown(error))
                        return
                    }
                    
                    guard let response = response as? HTTPURLResponse else {
                        continuation.resume(throwing: NetworkError.requestFailed(description: "Unexpected HTTTP answer"))
                        return
                    }
                    guard 200..<400 ~= response.statusCode else {
                        continuation.resume(throwing: NetworkError.unexpectedStatusCode(response.statusCode))
                        return
                    }
                    guard let data = data else {
                        continuation.resume(throwing: NetworkError.invalidData)
                        return
                    }
                    do {
                        // TODO: add this line 👇 in logger to manage when display it in console
                        print("🌐 Successed request with data from url: \(response.url?.debugDescription ?? "[no url]")")
                        print("🌐 data: \(data.prettyJson ?? "[Json invalid]")")
                        // TODO: add this decoder to manage custom iso8601 date format
                        // but need to refacto to add Decoder has part of DI to switch it on the fly
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .custom(decoder.pocketbaseDateDecodingStrategy())
                        let decodedResponse = try decoder.decode(T.self, from: data)
                        continuation.resume(returning: decodedResponse)
                    } catch let error as DecodingError {
                        continuation.resume(throwing: NetworkError.jsonParsingFailed(error))
                    } catch {
                        continuation.resume(throwing: NetworkError.unknown(error))
                    }
                }
            task.resume()
        }
    }
    
    func sendRequest<T>(endpoint: EndPoint, type: T.Type) -> AnyPublisher<T, NetworkError> where T : Decodable {
        let urlRequest = createRequest(endPoint: endpoint)
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse else {
                    throw NetworkError.requestFailed(description: "Unexpected HTTTP answer")
                }
                guard 200..<400 ~= response.statusCode else {
                    throw NetworkError.unexpectedStatusCode(response.statusCode)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                if let error = error as? DecodingError {
                    return .jsonParsingFailed(error)
                } else if let error = error as? NetworkError {
                    return error
                } else {
                    return .unknown(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func sendRequest<T: Decodable>(endpoint: EndPoint, resultHandler: @escaping (Result<T, NetworkError>) -> Void) {
        let urlRequest = createRequest(endPoint: endpoint)
        let urlTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error {
                resultHandler(.failure(.unknown(error)))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                resultHandler(.failure(.requestFailed(description: "Unexpected HTTTP answer")))
                return
            }
            guard 200..<400 ~= response.statusCode else {
                resultHandler(.failure(.unexpectedStatusCode(response.statusCode)))
                return
            }
            guard let data = data else {
                resultHandler(.failure(.invalidData))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                resultHandler(.success(decodedResponse))
            } catch let error as DecodingError {
                resultHandler(.failure(NetworkError.jsonParsingFailed(error)))
            } catch {
                resultHandler(.failure(NetworkError.unknown(error)))
            }
        }
        urlTask.resume()
    }
}
