//
//  NetworkError.swift
//  CryptoBrow
//
//  Created by Jeoffrey Thirot on 12/02/2024.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    case requestFailed(description: String)
    case unexpectedStatusCode(_ statusCode: Int)
    case invalidData
    case jsonParsingFailed(_ error: DecodingError)
    case unknown(_ error: any Error)
    
    var description: String {
        switch self {
        case .requestFailed(let description):       return "Request failed: \(description)"
        case .unexpectedStatusCode(let statusCode): return "Invalid status code: \(statusCode)"
        case .invalidData:                          return "Invalid data"
        case .jsonParsingFailed(let error):         return "Failed to parse JSON: \(error.localizedDescription)"
        case .unknown(let error):                   return "An unknown error occured \(error.localizedDescription)"
        }
    }
}
