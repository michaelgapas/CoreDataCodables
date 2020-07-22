//
//  UIImageViewExtension.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/16/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import UIKit

extension UIImageView {

    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?, isInverted: Bool) {
        let imageCache = NSCache<NSString, UIImage>()
        self.image = nil
        //If imageurl's imagename has space then this line going to work for this
        let imageServerUrl = URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let cachedImage = imageCache.object(forKey: NSString(string: imageServerUrl)) {
            self.image = cachedImage
            return
        }

        if let url = URL(string: imageServerUrl) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(String(describing: error))")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: imageServerUrl))
                            if isInverted == true {
                                self.image = downloadedImage.invertImage()
                            } else {
                                self.image = downloadedImage
                            }
                        }
                    }
                }
            }).resume()
        }
    }
    
    func roundedImage() {
        self.layer.cornerRadius = self.frame.size.width / 2
    }
}

extension UIImage {
    func invertImage() -> UIImage {
        let beginImage = CIImage(image: self)
        if let filter = CIFilter(name: "CIColorInvert") {
            filter.setValue(beginImage, forKey: kCIInputImageKey)
            let newImage = UIImage(ciImage: filter.outputImage!)
            return newImage
        }
        return self
    }
}
