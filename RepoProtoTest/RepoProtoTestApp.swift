//
//  RepoProtoTestApp.swift
//  RepoProtoTest
//
//  Created by Jeoffrey Thirot on 24/04/2024.
//

import SwiftUI

@main
struct RepoProtoTestApp: App {
    var body: some Scene {
        WindowGroup {
            AddItemView(getAllUsers: GetAllUseCase(repository: RemoteUserRepository()))
        }
    }
}
