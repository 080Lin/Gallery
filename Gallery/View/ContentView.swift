//
//  ContentView.swift
//  Gallery
//
//  Created by Максим Нуждин on 20.01.2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    @State private var tempImage: UIImage?
    
    var body: some View {
        NavigationView {
            VStack {
                Section {
                    Picker("Choose type", selection: $viewModel.type) {
                        ForEach(Category.ImageType.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }.pickerStyle(.segmented)
                    switch viewModel.type {
                    case .sfw:
                        Picker("Choose category", selection: $viewModel.category) {
                            ForEach(Category.sfwCategory, id: \.self) {
                                Text($0)
                            }
                        }
                    case .nsfw:
                        Picker("Choose category", selection: $viewModel.category) {
                            ForEach(Category.nsfwCategory, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                } header: {
                    Text("Sorting settings")
                }
                AsyncImage(url: URL(string: viewModel.currentImage ?? "https://i.pinimg.com/564x/da/75/3c/da753c5dd461789966da797bf7aac139.jpg"), transaction: Transaction(animation: .easeInOut)
                ) { phase in
                    switch phase {
                    case .success(let img):
                        img
                            .resizable()
                            .scaledToFit()
                        let _ = DispatchQueue.main.async {
                            viewModel.imageToSave = img.snapshot()
                        }
                    case .empty:
                        ProgressView()
                    case .failure:
                        EmptyView()
                    @unknown default:
                        Text("unexpected error")
                    }
                }.onTapGesture {
                    Task {
                        await viewModel.fetchImages(type: viewModel.type, category: viewModel.category)
                    }
                }
                Button("save") {
                    viewModel.showSaveAlert.toggle()
                    viewModel.saveImageToGallery()
                }
                Spacer()
            }.task {
                await viewModel.fetchImages(type: viewModel.type, category: viewModel.category)
            }
            .sheet(isPresented: $viewModel.showImagePicker) {
                ImagePicker(image: $tempImage)
            }
            .alert(isPresented: $viewModel.showSaveAlert, TextAlert(title: "title", message: "message", placeholder: "placeholder", action: {name in
                viewModel.currentImageName = name
                viewModel.makeFavourite()
            }))
            .navigationTitle("Gallery")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("Gallery") {
                        GalleryView(viewModel: viewModel)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("photo library") {
                        viewModel.showImagePicker.toggle()
                    }
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
