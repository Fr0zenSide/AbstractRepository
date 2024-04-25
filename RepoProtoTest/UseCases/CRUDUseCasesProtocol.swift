//
//  CRUDUseCasesProtocol.swift
//  CryptoBrow
//
//  Created by Jeoffrey Thirot on 16/04/2024.
//

import Foundation

enum CRUDUseCasesError: Error {
    case networkError
    case notFound
}

public protocol GetCollectionUseCaseProtocol<ResponseModel> {
    associatedtype ResponseModel: Decodable & Identifiable
    associatedtype CollectionType: RandomAccessCollection
                        where CollectionType.Element: Identifiable,
                              CollectionType.Element == ResponseModel
//    associatedtype ResponseModel: Decodable & Hashable
    
//    func execute(_ params: [String: String]) async throws -> any RandomAccessCollection<ResponseModel>
    func execute(_ params: [String: String]) async throws -> CollectionType
}

public protocol GetUseCaseProtocol<ResponseModel> {
    associatedtype ResponseModel: Decodable & Identifiable
//    associatedtype ResponseModel: Decodable & Hashable
    
    func execute(_ params: [String: String]) async throws -> ResponseModel
}

/**
  * Useful to have only one repo like full online or full offline usecase
 */
public protocol GetCollectionOnOneRepositoryUseCaseProtocol<Repository>: GetCollectionUseCaseProtocol 
                    where ResponseModel == Repository.OutputModelType {
    associatedtype Repository: RepositoryProtocol
}

/**
  * Useful to have two repo like one call online and fallback offline for a usecase
 */
public protocol GetCollectionWithFallbackUseCaseProtocol<FirstRepository, SecondRepository>: GetCollectionUseCaseProtocol 
                    where ResponseModel == FirstRepository.OutputModelType,
                          ResponseModel == SecondRepository.OutputModelType {
    associatedtype FirstRepository: RepositoryProtocol
                        where FirstRepository.CollectionType == SecondRepository.CollectionType
    associatedtype SecondRepository: RepositoryProtocol
}
