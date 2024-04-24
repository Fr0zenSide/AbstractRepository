//
//  LoaderImage.swift
//  MayaFit
//
//  Created by Jeoffrey Thirot on 27/07/2022.
//

import SwiftUI

struct LoaderImage: View {

    var url: URL? = nil
    var placeholder: Image? = nil
    
    init(url: String? = nil, placeholder: Image? = nil) {
        if let url {
            self.url = URL(string: url)
        } else {
            self.url = nil
        }
        self.placeholder = placeholder
    }
    
    init(url: URL? = nil, placeholder: Image? = nil) {
        self.url = url
        self.placeholder = placeholder
    }

    var body: some View {
        if let url = url {
            AsyncImage(url: url, transaction: Transaction(animation: .spring(response: 0.3))) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Color.purple.opacity(0.1)
                        ProgressView()
                    }
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .transition(.opacity)
                    
    
                case .failure(_):
                    Image(systemName: "exclamationmark.icloud")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.secondary)

                @unknown default:
                    Image(systemName: "exclamationmark.icloud")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.secondary)
                }
            }
        } else {
            if let placeholder {
                placeholder
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "photo.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct LoaderImage_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LoaderImage(url: "https://pbs.twimg.com/profile_images/378800000261618973/869b4ab3c6a44fce08ab17f7e3990c29_400x400.jpeg")
                .frame(width: 240, height: 240) // I don't use maxWidth/maxHeight because for certain picture ratio the circle can be smaller
                .clipShape(Circle())
                .padding(.all, 5)
                .overlay(
                    Circle()
                        .stroke(LinearGradient(colors: [.blue, .indigo, .orange, .red], startPoint: .leading, endPoint: .top), lineWidth: 1)

                )
        }
    }
}
