//
//  FileManagerExt.swift
//  Gallery
//
//  Created by Максим Нуждин on 23.01.2022.
//

import Foundation


extension FileManager {
    
    static var documentDirectory: URL {
        
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
