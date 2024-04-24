//
//  User.swift
//  CryptoBrow
//
//  Created by Jeoffrey Thirot on 04/04/2024.
//

import Foundation

public struct User: Codable, Identifiable, Hashable {
    public let id: String
    
    let username: String
    let name: String
    let avatar: String
    let isVerified: Bool
    
    let created: Date
    let updated: Date
    
    var mediaUrlForUser: URL {
        let endPoint = PocketEndPoint.list([:])
        guard var url = endPoint.getMediaRequest().url else {
            return URL(string: "https://placehold.co/200x200?text=🚀\nMaya")!
        }
        url.append(component: id)
        return url
    }
    var avatarUrl: URL { mediaUrlForUser.appendingPathComponent(avatar) }
    
    enum CodingKeys: String, CodingKey {
        case id, username, name, avatar, created, updated
        case isVerified = "verified"
    }
}
