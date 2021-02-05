//
//  CustomImageView.swift
//  GetPhotos
//
//  Created by Anshu Vij on 8/12/20.
//  Copyright © 2020 anshu vij. All rights reserved.
//

//MARK: - CustomImageView Class

import UIKit

let imageCache = NSCache<NSString,UIImage>()
class CustomImageView : UIImageView
{
    var imageUrlString : String?
    func  loadImagesUsingUrl(urlString : String)
    {
        imageUrlString = urlString
        if let imageToCache = imageCache.object(forKey: urlString as NSString)
        {
            self.image = imageToCache
            return
        }
        guard let url = URL(string: urlString) else {
            return
        }
        DispatchQueue.global().async{
            let data = try? Data(contentsOf: url)
            
            if let data = data, let imageData = UIImage(data: data) {
                DispatchQueue.main.async {
                    if self.imageUrlString == urlString
                    {
                      self.image = imageData
                    }
                     imageCache.setObject(imageData, forKey: urlString as NSString)
                    
                    
                    
                }
            }
            
        }
        
        
    }
}
