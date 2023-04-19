//
//  ImageHandler.swift
//  WeatherAppAssessment
//
//  Created by SHARMILA KOTTKOTA on 4/19/23.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class ImageHandler: UIImageView {
    
    var imageURL: URL?
    
    public func loadImageWithUrl(url: URL) {
        imageURL = url
        image = nil
        
        // retrieves image if already available in cache
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        // image does not available in cache.. so retrieving it from url
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error as Any)
                return
            }
            DispatchQueue.main.async(execute: {
                if let imageData = data, let imageToCache = UIImage(data: imageData) {
                    if self.imageURL == url {
                        self.image = imageToCache
                    }
                    imageCache.setObject(imageToCache, forKey: url as AnyObject)
                }
            })
        }).resume()
    }
}
