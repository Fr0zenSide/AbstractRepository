//
//  RemoteUserRepository.swift
//  CryptoBrow
//
//  Created by Jeoffrey Thirot on 16/04/2024.
//

import Foundation

public struct RemoteUserRepository: UserRepositoryProtocol {
    private let networkService: NetworkProtocol
    
    init(networkService: NetworkProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    public func getAll(_ params: [String : String]) async throws -> any Collection<OutputModelType> {
        guard let query = params["query"], 
              let userId = params["userId"]
        else {
            preconditionFailure("Missing minimum configuration to use: [RemoteUserRepository.getAll([:])]")
        }
        
        let trimQuery = query.trim()
        let searchUser = "username~'\(trimQuery)'"
        let excludeCurrentUser = "id!='\(userId)'"
        let filters = ["filter": "(\(searchUser) && \(excludeCurrentUser))"]
        let endPoint = PocketEndPoint.list(filters)
        let result: PocketListContainer<User> = try await self.networkService.sendRequest(endpoint: endPoint)
        return result
    }
    
    public func getOne(_ id: String) async throws -> OutputModelType {
        // TODO: out of scope for the moment
        preconditionFailure("Not implemented yet!")
    }
    
    public func create(_ requestModel: InputModelType) async throws {
        // TODO: out of scope for the moment
        preconditionFailure("Not implemented yet!")
    }
    
    public func update(id: String, data: InputModelType) async throws {
        // TODO: out of scope for the moment
        preconditionFailure("Not implemented yet!")
    }
    
    public func updateAll(with data: any Collection<OutputModelType>) async throws {
        // TODO: out of scope for the moment
        preconditionFailure("Not implemented yet!")
    }
    
    public func delete(_ id: String) async throws {
        // TODO: out of scope for the moment
        preconditionFailure("Not implemented yet!")
    }
    
    public func deleteAll() async throws {
        // TODO: out of scope for the moment
        preconditionFailure("Not implemented yet!")
    }
}
