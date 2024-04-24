//
//  UserUseCaseMock.swift
//  CryptoBrow
//
//  Created by Jeoffrey Thirot on 04/04/2024.
//

import Foundation

/*fileprivate */struct UserModelMock {
    
    static private let fakeProfiles: [(name: String, profileUrl: String)] = [
        ("🧑🏻‍💻 Ptitin 🥰", "https://pbs.twimg.com/profile_images/911240815565033474/Schwsf7I_400x400.jpg"),
        ("Guillaume", "https://www.playactors.com/wp-content/uploads/2022/03/Guillaume.jpg"),
        ("Kate", "https://pbs.twimg.com/profile_images/378800000261618973/869b4ab3c6a44fce08ab17f7e3990c29_400x400.jpeg"),
        ("Jeo", "https://media.licdn.com/dms/image/D4E03AQHZVpa61jxNoQ/profile-displayphoto-shrink_800_800/0/1666252962073?e=2147483647&v=beta&t=BEXGo7MBhYk6zlIHIpk4V3qgEO__MGQOveRvCUt8gGM")
    ]

    static func get() -> User { Self.list().first! }

    static func list() -> [User] {
        (0..<10).map { i in
            User(
                id: UUID().uuidString,
                username: "Username-\(i + 1)",
                name: "M. Name \(i + 1)",
                avatar: Self.fakeProfiles.randomElement()!.profileUrl,
                isVerified: Bool.random(),
                created: .now,
                updated: .now)
        }
    }
}

struct UserUseCaseMock: GetAllUserUseCaseProtocol {
//struct UserUseCaseMock: GetCollectionOnOneRepositoryUseCaseProtocol {
    typealias Repository = RemoteUserRepository
//    typealias ResponseModel = Repository.OutputModelType
    
    func execute(_ params: [String: String]) async throws -> any Collection<ResponseModel> {
        UserModelMock.list()
    }
}
