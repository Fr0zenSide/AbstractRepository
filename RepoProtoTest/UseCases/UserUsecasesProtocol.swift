//
//  UserUsecasesProtocol.swift
//  RepoProtoTest
//
//  Created by Jeoffrey Thirot on 24/04/2024.
//

import Foundation

protocol GetAllUserUseCaseProtocol: GetCollectionOnOneRepositoryUseCaseProtocol /*where ResponseModel == User*//*, Repository == UserRepositoryProtocol*/ {
    associatedtype Repository = UserRepositoryProtocol
    associatedtype ResponseModel = Repository.OutputModelType
}
