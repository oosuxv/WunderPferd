//
//  ImageManager.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 21.05.2022.
//

import UIKit

class ProfileImageManager {
    private let fileName = "profile.png"
    
    func saveImage(image: UIImage?, userId: String) {
        if let pngData = image?.pngData(),
            let path = documentDirectoryPath()?.appendingPathComponent("\(userId)\(fileName)") {
            try? pngData.write(to: path)
        }
    }
    
    func loadImage(userId: String) -> UIImage? {
        if let dirPath = documentDirectoryPath() {
            let imageUrl = dirPath.appendingPathComponent("\(userId)\(fileName)")
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }
    
    func documentDirectoryPath() -> URL? {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path.first
    }
}
