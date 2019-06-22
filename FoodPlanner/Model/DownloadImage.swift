//
//  DownloadImage.swift
//  FoodPlanner
//
//  Created by Björn Åhström on 2019-06-22.
//  Copyright © 2019 Björn Åhström. All rights reserved.
//

import Foundation
import UIKit
import Firebase

let cache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func downloadImageFromStorage(dishId: String, imageReference: StorageReference?) {
        var image:UIImage?
        if let cachedImage = cache.object(forKey: dishId as NSString) {
            self.image = cachedImage
            return
        }
        
        let downloadImageRef = imageReference?.child(dishId)
        if downloadImageRef?.name == dishId {
            
            let downloadTask = downloadImageRef?.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
                
                if let error = error {
                    print("No image \(error.localizedDescription)")
                } else {
                    
                    
                    DispatchQueue.main.async {
                        if let data = data {
                            image = UIImage(data: data)
                            cache.setObject(image!, forKey: dishId as NSString)
                            
                            self.image = image
                            self.contentMode = .scaleAspectFill
                        }
                    }
                }
            }
            downloadTask?.observe(.progress) { (snapshot) in
                //print(snapshot.progress ?? "No more progress")
            }
            
        }
    }
}
