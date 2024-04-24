//
//  AddItemView.swift
//  CryptoBrow
//
//  Created by Jeoffrey Thirot on 15/04/2024.
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
    
    @MainActor final class ViewModel: ObservableObject {
        
        // MARK: - Variables
        // Private variables
        
        private var addRelationsUseCase: RelationUseCaseProtocol
//        private var getAllUsersUseCase: any GetAllUserUseCaseProtocol
        private var getAllUsersUseCase: any OnlineGetAllUseCaseProtocol<RemoteUserRepository>
        private var query: String?
        
        // Public variables
        
        private(set) var title: String = "Add new Relation"
        @Published private(set) var errorMessage: String? = nil
        @Published private(set) var profiles: [User] = []
        @Published private(set) var profilesResult: PocketListContainer<User>? = nil
        
        private(set) var coordinator: any PocketCoordinatorable
        
        // Animation flags
        @Published var hideLoading: Bool        = true
        @Published var hideEmpty: Bool          = true
        @Published var hideLoadingMore: Bool    = true
        @Published var hideError: Bool          = true
        
        
        // MARK: - Constructors
        /**
         Method to create the viewModel of Relation list
         
         */
        init(_ addRelations: RelationUseCaseProtocol,
             getAllUsers: some OnlineGetAllUseCaseProtocol<RemoteUserRepository>,
//             getAllUsers: some GetAllUserUseCaseProtocol,
             coordinator: some PocketCoordinatorable) {
            print("🐞 init ViewModel in", #fileID)
            addRelationsUseCase = addRelations
            getAllUsersUseCase = getAllUsers
            self.coordinator = coordinator
            initScreen()
        }
        
        private func initScreen() {
            print("🐞 \(#fileID) \(#function)")

        }
        
        
        // MARK: - Public methods
        
        func reload() async {
            // Maybe for that you need to have a task you can cancel if someone try to reload again
            await fetchUsers()
        }
        
        func search(matching: String) async {
            // update profiles here after a task
            query = matching
            getProfiles()
        }
        
        func select(this user: User) {
            print("add a new user:", user)
        }
        
        
        // MARK: - Private methods
        
        func getProfiles() {
            Task {
                await fetchUsers()
            }
        }
        
        private func fetchUsers() async {
            guard let query, query.count >= 3
            else {
                print("Don't launch request with just this search:", query as Any)
                profiles = []
                return
            }
            
            do {
                let result = try await getAllUsersUseCase.execute([
                    "query": query/*.lowercased()*/,
                    "userId": "il0anx20mfzmkju"]) // FIXME: remove hard coded id here 👈
                // Manage that 👇👇👇👇
                // exclude current profileId from search
                
//                profiles = result.filter { $0.id != profile.id && !excludeProfileIds.contains($0.id) }
//                profiles = result as! [User]
//                profiles = result as! PocketListContainer<User>
                if result is PocketListContainer<User> {
                    profilesResult = result as! PocketListContainer<User>
                    profiles = profilesResult!.items as! [User]
                } else {
                    profiles = []
                }
            } catch {
                // FIXME: need to display error
                print("⚠️ Error:", error)
                profiles = []
            }
        }
    }
}


struct AddItemView: View {
    
    @StateObject private var viewModel: ViewModel
    @State private var query: String = ""
    
    // MARK: - Constructors
    /**
     Method to create the View to add new entry in the CRUD list
     
     */
    init(addRelation: RelationUseCaseProtocol,
//         getAllUsers: some GetAllUserUseCaseProtocol,
         getAllUsers: some OnlineGetAllUseCaseProtocol<RemoteUserRepository>,
         coordinator: some PocketCoordinatorable) {
        print("🐞 \(#fileID) \(#function)")
        _viewModel = StateObject(wrappedValue: ViewModel(addRelation, getAllUsers: getAllUsers, coordinator: coordinator))
    }
    
    var body: some View {
        NavigationStack {
            List(viewModel.profiles) { profile in
                UserCellView(profile) {
                    viewModel.select(this: profile)
                }
            }
            .navigationTitle("Find new relations")
            .searchable(text: $query, prompt: "Search relations")
            .onChange(of: query) { newQuery in
                Task { await viewModel.search(matching: query) }
            }
            .refreshable {
                await viewModel.reload()
            }
        }
    }
}

#Preview {
    AddItemView(addRelation: RelationUseCaseMock(), getAllUsers: UserUseCaseMock(), coordinator: PocketCoordinator())
}
