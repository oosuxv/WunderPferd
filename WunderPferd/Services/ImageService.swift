//
//  ImageService.swift
//  WunderPferd
//
//  Created by Vadim Gorodilov on 27.05.2022.
//

import Foundation
import UIKit

protocol ImageService {
    func getImage(url: String, completion: @escaping (UIImage?, String?) -> ())
}

class CachedImageService: ImageService {
    
    private struct Constants {
        static let queueLabel = "ImageServiceQueue"
        static let requestLimit = 8
    }
    
    init(imageNetworkManager: ImageNetworkManager) {
        self.imageNetworkManager = imageNetworkManager
        requestQueue.maxConcurrentOperationCount = Constants.requestLimit
    }
    
    let imageNetworkManager: ImageNetworkManager
    var imageDictionary: [String: UIImage] = [:]
    let updateQueue = DispatchQueue(label: Constants.queueLabel)
    let requestQueue = OperationQueue()
    
    func getImage(url: String, completion: @escaping (UIImage?, String?) -> ()) {
        if let image = imageDictionary[url] {
            completion(image, url)
            return
        } else {
            requestQueue.addOperation {
                self.imageNetworkManager.getImage(url: url) {
                    [weak self] data, error in
                    guard let self = self,
                            error == nil,
                            let data = data else {
                        ServiceLocator.logger.error("image load failed: \(error?.localizedDescription ?? "")")
                        completion(nil, nil)
                        return
                    }
                    let image = UIImage(data: data)
                    self.updateQueue.async {
                        [weak self] in
                        self?.cleanImageDictIfNeeded()
                        self?.imageDictionary[url] = image
                    }
                    completion(image, url)
                }
            }
        }
    }
    
    private func cleanImageDictIfNeeded() {
        let allKeys = imageDictionary.keys
        guard allKeys.count > 50 else {
            return
        }
        let firstKeys = allKeys.prefix(allKeys.count - 50)
        for key in firstKeys {
            imageDictionary[key] = nil
        }
    }
}
