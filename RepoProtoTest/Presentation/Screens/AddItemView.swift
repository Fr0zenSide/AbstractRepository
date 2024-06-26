//
//  AddItemView.swift
//  CryptoBrow
//
//  Created by Jeoffrey Thirot on 15/04/2024.
//

import SwiftUI

struct AddItemView<ListCollectionType: GetCollectionUseCaseProtocol, SearchCollectionType: GetCollectionUseCaseProtocol>: View {
    
    @StateObject private var viewModel: ViewModel<ListCollectionType, SearchCollectionType>
    @State private var query: String = ""
    
    // MARK: - Constructors
    /**
     Method to create the View to add new entry in the CRUD list
     
     */
    init(list: ListCollectionType,
         search: SearchCollectionType) {
        print("🐞 \(#fileID) \(#function)")
        _viewModel = StateObject(wrappedValue: ViewModel(list, with: search))
    }
    
    var body: some View {
        NavigationStack {
            List {
                if let data = viewModel.searchResult {
                    ForEach(data) { item in
                        // TODO: Replace this one to use Generic View than can be build with ResponseModel of CollectionType
                        UserCellView(item as! User) {
                            viewModel.select(this: item as! User)
                        }
                    }
                } else {
                    Text("Empty result")
                }
            }
            .navigationTitle("Find new relations")
//            .navigationBarTitleDisplayMode(.large)
            // TODO: have a search bar displayed when the screen appear, the list is empty or when we scroll back 
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search relations")
            .onSubmit(of: .search, viewModel.launchSearch)
            .onChange(of: query) { _, newQuery in
                Task { await viewModel.search(matching: query) }
            }
            .refreshable {
                viewModel.launchSearch()
//                await viewModel.reload()
            }
        }
    }
}

#Preview {
    AddItemView(list: UserUseCaseMock(), search: UserUseCaseMock())
}
