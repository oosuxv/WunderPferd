//
//  ImageManager.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 01.05.2022.
//

import UIKit

class ProfileImageManager {
    private let fileName = "profile.png"
    var image: UIImage? {
        get {
            if let dirPath = documentDirectoryPath() {
                let imageUrl = dirPath.appendingPathComponent(fileName)
                let image = UIImage(contentsOfFile: imageUrl.path)
                return image
            }
            return nil
        }
        
        set(newImage) {
            if let pngData = newImage?.pngData(),
                let path = documentDirectoryPath()?.appendingPathComponent(fileName) {
                try? pngData.write(to: path)
            }
        }
    }
    
    func documentDirectoryPath() -> URL? {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path.first
    }
}
