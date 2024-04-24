//
//  UserCellView.swift
//  CryptoBrow
//
//  Created by Jeoffrey Thirot on 16/04/2024.
//

import SwiftUI

extension UserCellView {
    @MainActor class ViewModel: ObservableObject {
        @Published var imageUrl: URL?
        @Published var title: String
        @Published var subtitle: String? = nil
//        @Published var state: RelationState?
        var hideAction: Bool { actionHandler == nil }
        
        var actionHandler: (() -> ())? = nil
        
        init(imageUrl: URL? = nil, title: String, subtitle: String? = nil, actionHandler: (() -> Void)? = nil) {
            self.imageUrl = imageUrl
            self.title = title
            self.subtitle = subtitle
            self.actionHandler = actionHandler
        }
    }
}

struct UserCellView: View {
    @StateObject var viewModel: ViewModel
    
    init(_ user: User, actionHandler: (() -> Void)? = nil) {
        self.init(url: user.avatarUrl, title: user.username, actionHandler: actionHandler)
    }
    
    init(imageUrl: String? = nil, title: String, subtitle: String? = nil, actionHandler: (() -> Void)? = nil) {
        let url = imageUrl != nil ? URL(string: imageUrl!) : nil
        self.init(url: url, title: title, subtitle: subtitle, actionHandler: actionHandler)
    }
    
    init(url: URL? = nil, title: String, subtitle: String? = nil, actionHandler: (() -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: ViewModel(imageUrl: url, title: title, subtitle: subtitle, actionHandler: actionHandler))
    }

    var body: some View {
        HStack(spacing: 20) {
            LoaderImage(url: viewModel.imageUrl)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            
            VStack {
                
                Text(viewModel.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if let subtitle = viewModel.subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
//            if let state = viewModel.state, !viewModel.hideAction {
//                Button {
//                    print("RelationCellView button was tapped with state: \(state)")
//                    viewModel.actionHandler?()
//                } label: {
//                    state.buttonView()
//                }
//                .buttonStyle(.addFriend)
//                .frame(minWidth: 100, maxWidth: 100)
//            }
        }
    }
}

#Preview {
    VStack {
        UserCellView(UserModelMock.get()) {
            print("Has action")
        }
        .previewLayout(.sizeThatFits)
        .padding()
        UserCellView(UserModelMock.get(), actionHandler: nil)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
