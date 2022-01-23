//
//  VM-ContentView.swift
//  Gallery
//
//  Created by Максим Нуждин on 20.01.2022.
//

import Foundation
import SwiftUI

extension ContentView {
    
    @MainActor class ViewModel: ObservableObject {
        
        @Published var text = "some text"
        @Published private(set) var imageArray = [String]()
        @Published private(set) var savedImageArray = [Favourite]()
        @Published var currentImageName: String?
        @Published var currentImage: String?
        @Published var imageFromPicker: UIImage?
        @Published var imageToSave: UIImage?
        @Published var type: Category.ImageType = .sfw
        @Published var category: String = "neko"
        @Published var showImagePicker = false
        @Published var showSaveAlert = false
        
        let saveDirectory = FileManager.documentDirectory.appendingPathComponent("savedImages")
        
        init() {
            do {
                let data = try Data(contentsOf: saveDirectory)
                savedImageArray = try JSONDecoder().decode([Favourite].self, from: data)
            } catch {
                savedImageArray = []
            }
        }
        
        func fetchImages(type: Category.ImageType, category: String) async {
            
            let link = "\(Result.endpoint)/\(type)/\(category)"
            let url = URL(string: link)!
            
            do {
                
                let (data, _) = try await URLSession.shared.data(from: url)
                
                if let res = try? JSONDecoder().decode(Result.self, from: data) {
                    imageArray.append(res.url)
                    currentImage = res.url
                }
            } catch {
                print("unexpected error occured. \(error.localizedDescription)")
            }
        }
        
        func saveImageToGallery() {
            guard let currentImage = imageToSave else {
                print("no image")
                return
            }

            let imageSaver = ImageSaver()

            imageSaver.successHandler = {
                print("Success")
            }

            imageSaver.errorHandler = {
                print($0.localizedDescription)
            }

            imageSaver.writeToPhotoAlbum(image: currentImage)
        }
        
//        func saveToLocalDirectory() {
//
//            guard let currentImage = imageToSave else {
//                print("no image")
//                return
//            }
//
//            if let jpegData = currentImage.jpegData(compressionQuality: 0.75) {
//                try? jpegData.write(to: saveDirectory, options: [.atomic, .completeFileProtection])
//            }
//        }
        
        func makeFavourite() {
            guard let currentImage = imageToSave else {
                return
            }

            let new = Favourite(image: currentImage, name: currentImageName ?? "unknown")
            savedImageArray.append(new)
            
            do {
                let data = try JSONEncoder().encode(savedImageArray)
                try data.write(to: saveDirectory, options: [.atomic, .completeFileProtection])
            } catch {
                print("unable to save into document directory")
            }
        }
    }
}
