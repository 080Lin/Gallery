//
//  GalleryView.swift
//  Gallery
//
//  Created by Максим Нуждин on 20.01.2022.
//

import SwiftUI

struct GalleryView: View {
    
    @ObservedObject var viewModel: ContentView.ViewModel
    @StateObject var galleryModel = GalleryViewModel()
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: galleryModel.columns) {
                if !galleryModel.onlyFavourite {
                    ForEach(viewModel.imageArray, id: \.self) { image in
                        AsyncImage(url: URL(string: image), transaction: Transaction(animation: .easeInOut)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let img):
                                img
                                    .resizable()
                                    .scaledToFit()
                            case .failure(let error):
                                Text(error.localizedDescription)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                } else {
                    ForEach(viewModel.savedImageArray, id: \.self) { image in
                        VStack {
                            Image(uiImage: image.image)
                                .resizable()
                                .scaledToFit()
//                            AsyncImage(url: URL(string: image.url), transaction: Transaction(animation: .easeInOut)) { phase in
//                                switch phase {
//                                case .empty:
//                                    ProgressView()
//                                case .success(let img):
//                                    img
//                                        .resizable()
//                                        .scaledToFit()
//                                case .failure(let error):
//                                    Text(error.localizedDescription)
//                                @unknown default:
//                                    EmptyView()
//                                }
//                            }
                            Text(image.name)
                        }
                    }
                }
            }.padding()
        }
        .toolbar {
            Toggle("switch", isOn: $galleryModel.onlyFavourite)
        }
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView(viewModel: ContentView.ViewModel())
    }
}
