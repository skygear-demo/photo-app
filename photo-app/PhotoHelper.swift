//
//  PhotoHelper.swift
//  photo-app
//
//  Created by David Ng on 15/9/2017.
//  Copyright © 2017 Skygear. All rights reserved.
//

import Foundation
import UIKit
import SKYKit

class PhotoHelper {
    
    static func resize(image: UIImage, maxWidth: CGFloat, quality: CGFloat = 1.0) -> Data? {
        var actualWidth = image.size.width
        var actualHeight = image.size.height
        let heightRatio = actualHeight / actualWidth
        
        print("FROM: \(actualWidth)x\(actualHeight) ratio \(heightRatio)")
        
        if actualWidth > maxWidth {
            actualWidth = maxWidth
            actualHeight = maxWidth * heightRatio
        }
        
        print("TO: \(actualWidth)x\(actualHeight)")
        
        let rect = CGRect(x: 0, y: 0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)

        let img = UIGraphicsGetImageFromCurrentImageContext()
        guard let imageData = UIImageJPEGRepresentation(img!, quality) else {
            return nil
        }

        print("Image resized")
        return imageData
    
    }
    
    static func upload(imageData: Data, onCompletion: @escaping (_ uploadedAsset: SKYAsset?) -> Void) {

        guard let asset = SKYAsset(name: "photo.jpg", data: imageData) as SKYAsset? else {
            print("Cannot create SKYAsset")
            onCompletion(nil)
            return
        }
        
        asset.mimeType = "image/jpeg"
        
        SKYContainer.default().publicCloudDatabase.uploadAsset(asset) { (uploadedAsset, error) in
            
            if let error = error {
                print("Error uploading asset: \(error)")
                onCompletion(nil)
            } else {
                if let uploadedAsset = uploadedAsset {
                    print("Asset uploaded: \(uploadedAsset) \(uploadedAsset.mimeType) \(uploadedAsset.fileSize)")
                    onCompletion(uploadedAsset)
                } else {
                    print("Asset undefined")
                    onCompletion(nil)
                }
            }
        }
        
//        SKYContainer.default().publicCloudDatabase.uploadAsset(asset, completionHandler: { uploadedAsset, error in
//            if let error = error {
//                print("Error uploading asset: \(error)")
//                onCompletion(nil)
//            } else {
//                if let uploadedAsset = uploadedAsset {
//                    print("Asset uploaded: \(uploadedAsset) \(uploadedAsset.mimeType) \(uploadedAsset.fileSize)")
//                    onCompletion(uploadedAsset)
//                } else {
//                    print("Asset undefined")
//                    onCompletion(nil)
//                }
//            }
//        })
    }
}
