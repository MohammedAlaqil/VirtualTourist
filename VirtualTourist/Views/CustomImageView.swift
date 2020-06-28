//
//  CustomImageView.swift
//  VirtualTourist
//
//  Created by M7md on 21/06/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

protocol CustomImageViewDelegate {
    func imageDidDownload()
}

let imagesCache = NSCache<NSString , AnyObject> ()

class CustomImageView : UIImageView {
    
    var imageURL : URL!
    
    func setPhoto(_ newPhoto : Photo)  {
        if photo != nil {
            return
        }
        photo = newPhoto
    }
    private var photo : Photo!  {
    didSet {
        if let image = photo.getImage() {
            hideActitvityIndicatorView()
            self.image = image
            return
        }
        guard let url = photo.imageURL else {
            return
        }
        loadImageUsingCache(with : url)
    }
    }
    
    func loadImageUsingCache(with url: URL){
        imageURL = url
        image = nil
        showActitvityIndicatorView()
        if let CachedImage = imagesCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            image = CachedImage
            hideActitvityIndicatorView()
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let downloadedImage = UIImage(data: data!) else { return }
            imagesCache.setObject(downloadedImage, forKey: url.absoluteString as NSString)
            
            DispatchQueue.main.async {
                self.image = downloadedImage
                self.photo.set(image: downloadedImage)
                try? self.photo.managedObjectContext?.save()
                self.hideActitvityIndicatorView()
            }
        }.resume()
    }
    
    lazy var activityIndicatorView : UIActivityIndicatorView = {
       let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        self.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicatorView.color = .black
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    func showActitvityIndicatorView() {
        DispatchQueue.main.async {
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func hideActitvityIndicatorView() {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
        }
    }
    
}

