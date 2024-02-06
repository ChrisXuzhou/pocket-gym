//
//  Imagehelper.swift
//  Ren-Swiftui
//
//  Created by betterchris on 2022/6/3.
//

import Foundation
import SwiftUI

enum StorageType {
    case userDefaults, fileSystem
}

private func filePath(forKey key: String) -> URL? {
    let fileManager = FileManager.default
    
    let folderURL = try! fileManager
        .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        .appendingPathComponent("imgs", isDirectory: true)
    
    try! fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)

    return folderURL.appendingPathComponent(key + ".jpeg")
}

func store(image: UIImage,
           forKey key: String,
           withStorageType storageType: StorageType) {
    if let jpegRepresentation = image.jpeg(.lowest) {
        switch storageType {
        case .fileSystem:
            if let filePath = filePath(forKey: key) {
                do {
                    try jpegRepresentation.write(to: filePath,
                                                 options: .atomic)
                } catch let err {
                    log("Saving file resulted in error: \(err)")
                }
            }
        case .userDefaults:
            UserDefaults.standard.set(jpegRepresentation,
                                      forKey: key)
        }
    }
}

func retrieveImage(forKey key: String,
                   inStorageType storageType: StorageType) -> UIImage? {
    switch storageType {
    case .fileSystem:
        if let filePath = filePath(forKey: key),
           let fileData = FileManager.default.contents(atPath: filePath.path),
           let image = UIImage(data: fileData) {
            return image
        }
    case .userDefaults:
        if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
           let image = UIImage(data: imageData) {
            return image
        }
    }

    return nil
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest = 0
        case low = 0.25
        case medium = 0.5
        case high = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
