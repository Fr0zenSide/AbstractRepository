//
//  DateFormatter+Extensions.swift
//  CryptoBrow
//
//  Created by Jeoffrey Thirot on 04/04/2024.
//

import Foundation

extension DateFormatter {
    /**
     Method to get a specific date formatter with UTC based and without T beetween date and time
     date format looks like this: `2024-04-04 13:47:54.692Z`
     
     - Parameter id: identifier of your resource
     - Returns: url to request this ressource on api
     - Warning: This is an abstract methods, you need to override it on every child.
     
     */
    static func pocketbase() -> ISO8601DateFormatter {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.formatOptions = [.withInternetDateTime,
                                        .withFractionalSeconds,
                                        .withSpaceBetweenDateAndTime]
        return dateFormatter
    }
}


extension JSONDecoder {
    func pocketbaseDateDecodingStrategy() -> (@Sendable (_ decoder: any Decoder) throws -> Date) {
        { decoder in
          let container = try decoder.singleValueContainer()
          let dateString = try container.decode(String.self)

          if let date = DateFormatter.pocketbase().date(from: dateString) {
            return date
          } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
          }
        }
    }
}
