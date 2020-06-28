//
//  Constants.swift
//  VirtualTourist
//
//  Created by M7md on 21/06/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import MapKit

struct Constants {
    
    struct Flickr {
        
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest"
        
        static let SearchBBoxHalfWidth = 1.0
        static let SearchBBoxHalfHeight = 1.0
        static let SearchLatRange = (-90.0, 90.0)
        static let SearchLonRange = (-180.0, 180.0)
    }
    
    struct FlickrParameterKeys {
        
        static let Page = "page"
        static let Method = "method"
        static let Extras = "extras"
        static let APIKey = "api_key"
       static let Format = "format"
       static let SafeSearch = "safe_search"
        static let BoundingBox = "bbox"
       static let PhotosPerPage = "per_page"
        static let NoJSONCallback = "nojsoncallback"
        static let Text = "text"
    }
    struct FlickrParameterValues {
        
 
         static let APIKey = "b6b1bb4a71777a7e6e0b51b46d7f728e"
         static let MediumURL = "url_m"
         static let SearchMethod = "flickr.photos.search"
         static let UseSafeSearch = "1"
         static let ResponseFormat = "json"
         static let DisableJSONCallback = "1"
         static let GalleryPhotosMethod = "flickr.galleries.getPhotos"
         static let PerPage = 10
        
    }
    
}
