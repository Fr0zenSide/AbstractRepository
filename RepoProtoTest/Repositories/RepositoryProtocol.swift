//
//  RepositoryProtocol.swift
//  CryptoBrow
//
//  Created by Jeoffrey Thirot on 16/02/2024.
//

import Foundation

// TODO: I try to use this protocol for local & remote repositories
public protocol RepositoryProtocol {
    associatedtype InputModelType: Encodable // Seems we don't need a Codable instance
    associatedtype OutputModelType: Decodable & Identifiable // Seems we don't need a Codable instance if we don't save also in local repo directly
    associatedtype CollectionType: RandomAccessCollection where CollectionType.Element: Identifiable, CollectionType.Element == OutputModelType

    func getAll(_ params: [String: String]) async throws -> CollectionType
    func getOne(_ id: String) async throws -> OutputModelType
    func create(_ requestModel: InputModelType) async throws
    func update(id: String, data: InputModelType) async throws
    func updateAll(with data: CollectionType) async throws
    func delete(_ id: String) async throws
    func deleteAll() async throws
}
