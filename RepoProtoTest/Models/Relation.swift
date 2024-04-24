//
//  Relation.swift
//  CryptoBrow
//
//  Created by Jeoffrey Thirot on 04/04/2024.
//

import Foundation

enum SharingType: String, Codable, CaseIterable {
    case live, afterWorkout, resume
}

enum RelationType: String, Codable, CaseIterable {
    case family, bestFriend, friend, colleague, other
}

public struct Relation: Codable, Identifiable, Hashable {

    public let id: String
    
    let owner: String
    let user: String
    let sharingType: SharingType
    let type: RelationType
    let isValidated: Bool
    
    // To have detail of expanding relation in db (here the ower and the user of a relation entry (1,1))
    let expand: Expand
    
    let created: Date
    let updated: Date
    
    enum CodingKeys: String, CodingKey {
        case id, owner, user, sharingType, type, expand, created, updated
        case isValidated = "validated"
    }
    
    public struct Expand: Codable, Hashable {
        let owner: User
        let user: User
    }
}

extension Relation {
    public static func ==(lhs: Relation, rhs: Relation) -> Bool { lhs.id == rhs.id }
}
