//
//  ImageService.swift
//  WunderPferd
//
//  Created by Student1 on 24.05.2022.
//

import Foundation
import UIKit

protocol ImageServiceProtocol {
    func getImage(urlString: String, completion: @escaping (UIImage?) -> ())
}

class ImageService: ImageServiceProtocol {
    
    init(networkManager: ImageNetworkManager) {
        self.networkManager = networkManager
    }
    
    let networkManager: ImageNetworkManager
    var imageDict: [String: UIImage] = [:]
    let updateQueue = DispatchQueue(label: "ImageServiceQueue")
    
    func getImage(urlString: String, completion: @escaping (UIImage?) -> ()) {
        if let image = imageDict[urlString] {
            completion(image)
            return
        } else {
            DispatchQueue.global().async {
                self.networkManager.getImage(urlString: urlString) {
                    [weak self] data, error in
                    guard let self = self,
                            error == nil,
                            let data = data else {
                        completion(nil)
                        return
                    }
                    let image = UIImage(data: data)
                    self.updateQueue.async {  // в отдельном последовательном потоке обновляем словарь
                        [weak self] in
                        self?.cleanImageDictIfNeeded()
                        self?.imageDict[urlString] = image
                    }
                    completion(image)
                }
            }
        }
    }
    
    private func cleanImageDictIfNeeded() {
        let allKeys = imageDict.keys
        guard allKeys.count > 50 else {
            return
        }
        let firstKeys = allKeys.prefix(allKeys.count - 50)
        for key in firstKeys {
            imageDict[key] = nil
        }
    }
}
