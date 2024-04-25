//
//  CRUDUseCases.swift
//  RepoProtoTest
//
//  Created by Jeoffrey Thirot on 24/04/2024.
//

import Foundation

/**
 Use case to get a collection with only one repository (online or offline)
 
 */
final class GetAllUseCase<RepositoryType: RepositoryProtocol>: GetCollectionOnOneRepositoryUseCaseProtocol {
    typealias Repository     = RepositoryType
    typealias ResponseModel  = RepositoryType.OutputModelType
    typealias CollectionType = Repository.CollectionType
    
    private let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    func execute(_ params: [String : String]) async throws -> CollectionType {
        do {
            let list = try await repository.getAll(params)
            return list
        } catch let error as NetworkError {
            // TODO: Use Logger here and throw a safe CRUDUseCasesError instead
            // Why CRUDUseCasesError? coz' your users need proper messages displayed in UI != of helping dev to debug
            print("Network error: \(error.description)")
            throw error
        } catch {
            // TODO: Use Logger here and throw a safe CRUDUseCasesError instead
            print("Network error: \(error.localizedDescription)")
            throw error
        }
    }
}

/**
 Use case to get a collection with fallback that are generally an offline repository
 
 - Parameter FirstRepositoryType: Type of a repository which conform to RepositoryProtocol and have the same OutputModelType than the second repository
 - Parameter SecondRepositoryType: Type of a repository  which conform to RepositoryProtocol
 
 */
final class GetAllWithFallbackUseCase<FirstRepositoryType: RepositoryProtocol, SecondRepositoryType: RepositoryProtocol>: GetCollectionWithFallbackUseCaseProtocol
                where FirstRepositoryType.OutputModelType == SecondRepositoryType.OutputModelType,
                      FirstRepositoryType.CollectionType == SecondRepositoryType.CollectionType {
    
    typealias FirstRepository   = FirstRepositoryType
    typealias SecondRepository  = SecondRepositoryType
    typealias ResponseModel     = FirstRepository.OutputModelType
    
    private let firstRepository: FirstRepository // can be remote
    private let secondRepository: SecondRepository // can be local
    
    init(firstRepository: FirstRepository, secondRepository: SecondRepository) {
        self.firstRepository = firstRepository
        self.secondRepository = secondRepository
    }
    
    func execute(_ params: [String : String]) async throws -> FirstRepositoryType.CollectionType {
        do {
            let list = try await firstRepository.getAll(params)
            try? await secondRepository.updateAll(with: list)
            return list
        } catch {
            // TODO: Use Logger here and throw a safe CRUDUseCasesError instead
            print("Network error: \(error.localizedDescription)")
            return try await secondRepository.getAll(params)
        }
    }
}
