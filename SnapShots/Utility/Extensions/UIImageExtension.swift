//
//  UIImageExtension.swift
//  SnapShots
//
//  Created by mahendran-14703 on 22/11/22.
//

import Foundation
import UIKit

extension UIImage {
    
    private func getDocumentsDirectory(imageName: String) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        return fileURL
    }
    
    func saveImage(imageName: String, image: UIImage) {

        let fileURL = getDocumentsDirectory(imageName: imageName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }

        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
    func deleteImage(imageName: String) {
        
        let fileURL = getDocumentsDirectory(imageName: imageName)
        
        do {
            try FileManager.default.removeItem(atPath: fileURL.path)
        } catch let removeError {
            print("couldn't remove file at path", removeError)
        }
    }
    
    func loadImageFromDiskWith(fileName: String) -> UIImage? {

        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            return UIImage(contentsOfFile: imageUrl.path)
        }
        
        return nil
    }
}
