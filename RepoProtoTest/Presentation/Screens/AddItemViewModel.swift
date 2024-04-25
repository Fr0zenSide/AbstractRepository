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
        
        private var listUseCase: ContentListCollectionType
        private var searchUseCase: ContentSearchCollectionType? = nil
        
        private var query: String?
        
        // Public variables
        
        private(set) var title: String = "Add new Relation"
        @Published private(set) var errorMessage: String? = nil
        
        @Published private(set) var listResult: ContentListCollectionType.CollectionType? = nil
        @Published private(set) var searchResult: ContentSearchCollectionType.CollectionType? = nil
        
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
                print("See the default list result:", result)
                listResult = result
            } catch {
                // FIXME: need to display error
                print("⚠️ Error:", error)
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
                let result = try await searchUseCase.execute([
                    "query": query/*.lowercased()*/,
                    "userId": "il0anx20mfzmkju"]) // FIXME: remove hard coded id here 👈
                
                // searchResult = result.items // FIXME: Here we need to use directly our Collection not .items
                searchResult = result
            } catch {
                // FIXME: need to display error
                print("⚠️ Error:", error)
                searchResult = nil
            }
        }
    }
}
