//
//  Result.swift
//  Gallery
//
//  Created by Максим Нуждин on 20.01.2022.
//

import Foundation
import UIKit


struct Result: Codable {
    
    let url: String
    static let endpoint = "https://api.waifu.pics" 
}

struct Favourite: Codable, Hashable {
    
    var image: UIImage
    var name: String
}

struct Category {
    
    var name: String
    
    enum ImageType: String, CaseIterable {
        case sfw
        case nsfw
    }
    
    static let nsfwCategory: [String] = ["waifu", "neko", "trap", "blowjob"]
    static let sfwCategory: [String] = SFWImageCategory.allCases.map { $0.rawValue }
    
    enum NSFWImageCategory: String, CaseIterable {
        case waifu, neko, trap, blowjob
    }
    
    enum SFWImageCategory: String, CaseIterable {
        case waifu, neko, shinobu, megumin, bully
        case cuddle, cry, hug, awoo, kiss, lick
        case pat, smug, bonk, yeet, blush, smile
        case wave, highfive, handhold, nom, bite
        case glomp, slap, kill, kick, happy
        case wink, poke, dance, cringe
    }
}


public protocol ImageCodable: Codable {}
extension UIImage: ImageCodable {}

extension ImageCodable where Self: UIImage {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(data: try container.decode(Data.self))!
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.pngData()!)
    }
}
