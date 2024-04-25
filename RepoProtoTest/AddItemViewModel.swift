//
//  AddItemViewModel.swift
//  RepoProtoTest
//
//  Created by Jeoffrey Thirot on 24/04/2024.
//

import SwiftUI

extension AddItemView {
    
//    enum ViewState: Equatable {
//        case idle
//        case loading
//        case empty
//        case loaded//([Relation])
//        case error//(String)
//    }
    
    @MainActor
    final class ViewModel<ContentListCollectionType: GetCollectionUseCaseProtocol, ContentSearchCollectionType: GetCollectionUseCaseProtocol>: ObservableObject {
        
        // MARK: - Variables
        // Private variables
        
//        private var getAllUsersUseCase: any GetCollectionOnOneRepositoryUseCaseProtocol<RemoteUserRepository>
        
//        private var listUseCase: any GetCollectionUseCaseProtocol
//        private var searchUseCase: (any GetCollectionUseCaseProtocol)? = nil
//
        private var listUseCase: ContentListCollectionType
        private var searchUseCase: ContentSearchCollectionType? = nil
        
        private var query: String?
        
        // Public variables
        
        private(set) var title: String = "Add new Relation"
        @Published private(set) var errorMessage: String? = nil
//        @Published private(set) var profiles: [User] = []
//        @Published private(set) var profilesResult: PocketListContainer<User>? = nil
        
//        @Published private(set) var listResult: (any Collection<GetCollectionUseCaseProtocol.ResponseModel>)? = nil
//        @Published private(set) var searchResult: (any Collection<GetCollectionUseCaseProtocol.ResponseModel>)? = nil
//
        
//        @Published private(set) var listResult: (any RandomAccessCollection<ListCollectionType.ResponseModel>)? = nil
        @Published private(set) var listResult: ContentListCollectionType.CollectionType? = nil
//        @Published private(set) var searchResul (any RandomAccessCollection<ListCollectionType.ResponseModel>)? = nil
        @Published private(set) var searchResult: ContentSearchCollectionType.CollectionType? = nil
//        var explicitSearchResult: [SearchCollectionType.ResponseModel] {
//            get {
//                guard let dataSource: [SearchCollectionType.ResponseModel] = searchResult as? [SearchCollectionType.ResponseModel]
//                else {
//                    return []
//                }
//                return dataSource
//            }
//        }
        
        // Animation flags
        @Published var hideLoading: Bool        = true
        @Published var hideEmpty: Bool          = true
        @Published var hideLoadingMore: Bool    = true
        @Published var hideError: Bool          = true
        
        
        // MARK: - Constructors
        /**
         Method to create the viewModel of Relation list
         
         */
        init(_ list: ContentListCollectionType,
            with search: ContentSearchCollectionType? = nil) {
            print("🐞 init ViewModel in", #fileID)
            
            listUseCase = list
            searchUseCase = search
            
            initScreen()
        }
//
//        init(_ list: some GetCollectionUseCaseProtocol,
//            with search: (some GetCollectionUseCaseProtocol)? = nil) {
//            print("🐞 init ViewModel in", #fileID)
//            
//            listUseCase = list
//            searchUseCase = search
//            
//            initScreen()
//        }
//        
//        init(_ getAllUsers: some GetCollectionOnOneRepositoryUseCaseProtocol<RemoteUserRepository>
//             //getAllUsers: some GetAllUseCase<RemoteUserRepository>
////             getAllUsers: some OnlineGetAllUseCaseProtocol<RemoteUserRepository>
////             getAllUsers: some GetAllUserUseCaseProtocol
//            ) {
//            print("🐞 init ViewModel in", #fileID)
////            getAllUsersUseCase = getAllUsers
//            listUseCase = getAllUsers
//            
//            initScreen()
//        }
        
        private func initScreen() {
            print("🐞 \(#fileID) \(#function)")

        }
        
        
        // MARK: - Public methods
        
        func reload() async {
            // Maybe for that you need to have a task you can cancel if someone try to reload again
            await fetchList()
        }
        
        func search(matching: String) async {
            // update profiles here after a task
            query = matching
            launchSearch()
        }
        
        func select(this user: User) {
            print("add a new user:", user)
        }
        
        
        func getList() {
            Task {
                await fetchList()
            }
        }
        
        func launchSearch() {
            Task {
                await fetchSearch()
            }
        }
        
        
        // MARK: - Private methods
        
        private func fetchList() async {
            do {
                let result = try await listUseCase.execute([:])
                //FIXME: feed the right property to feed default list
                print("See the default list result:", result)
                listResult = result
            } catch {
                // FIXME: need to display error
                print("⚠️ Error:", error)
                // FIXME: empty the right property to empty the default list
//                profiles = []
                listResult = nil
            }
        }
        
        private func fetchSearch() async {
            guard let searchUseCase else { return }
            guard let query, query.count >= 3
            else {
                print("Don't launch request with just this search:", query as Any)
                searchResult = nil
                return
            }
            
            do {
                let result/*: PocketListContainer<User>*/ = try await searchUseCase.execute([
                    "query": query/*.lowercased()*/,
                    "userId": "il0anx20mfzmkju"])/* as! PocketListContainer<User>*/ // FIXME: remove hard coded id here 👈
                // Manage that 👇👇👇👇
                // exclude current profileId from search
                
//                profiles = result.filter { $0.id != profile.id && !excludeProfileIds.contains($0.id) }
//                profiles = result as! [User]
//                profiles = result as! PocketListContainer<User>
                
//                if result is PocketListContainer<User> {
//                    profilesResult = result as! PocketListContainer<User>
//                    profiles = profilesResult!.items as! [User]
//                } else {
//                    profiles = []
//                }
                
//                guard let typedResult = result as? PocketListContainer<User> else {
//                    profiles = []
//                    return
//                }
//                profilesResult = typedResult
//                profiles = typedResult.items // FIXME: Here we need to use directly our Collection not .items
                searchResult = result
            } catch {
                // FIXME: need to display error
                print("⚠️ Error:", error)
                searchResult = nil
            }
        }
    }
}
