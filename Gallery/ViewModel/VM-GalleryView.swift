//
//  VM-GalleryView.swift
//  Gallery
//
//  Created by Максим Нуждин on 23.01.2022.
//

import Foundation
import SwiftUI

extension GalleryView {
    
    @MainActor class GalleryViewModel: ObservableObject {
        
        let columns: [GridItem] = Array(repeating: .init(.flexible(minimum: 120, maximum: 150)), count: 2)
        @Published var onlyFavourite = false
    }
}
