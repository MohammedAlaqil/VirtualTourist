//
//  FlickerAPI.swift
//  VirtualTourist
//
//  Created by M7md on 21/06/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import MapKit

struct FlickerAPI {
    
    static func getPhotosURL(with coordinate : CLLocationCoordinate2D , pageNumber : Int , completion : @escaping ([URL]? , Error? , String? ) -> () ){
        let methodParameters = [ Constants.FlickrParameterKeys.Method : Constants.FlickrParameterValues.SearchMethod , Constants.FlickrParameterKeys.APIKey : Constants.FlickrParameterValues.APIKey , Constants.FlickrParameterKeys.BoundingBox : bboxString(for : coordinate) , Constants.FlickrParameterKeys.SafeSearch : Constants.FlickrParameterValues.UseSafeSearch , Constants.FlickrParameterKeys.Extras : Constants.FlickrParameterValues.MediumURL , Constants.FlickrParameterKeys.Format : Constants.FlickrParameterValues.ResponseFormat , Constants.FlickrParameterKeys.NoJSONCallback : Constants.FlickrParameterValues.DisableJSONCallback , Constants.FlickrParameterKeys.Page : pageNumber , Constants.FlickrParameterKeys.PhotosPerPage : Constants.FlickrParameterValues.PerPage , ] as [String : Any ]
        
        let request = URLRequest(url: getURL(from : methodParameters))
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil , error , nil)
                return
            }
            
            guard let statusCode = ( response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
            completion(nil , nil , "status code get another than 2 hundred .")
                return
        }
            guard let data = data else {
                completion(nil , nil , "No data")
                return
            }
            
            guard let result = try? JSONSerialization.jsonObject(with: data, options: []) as! [String : Any] else {
                completion(nil , nil , "couldn't parse the data")
                return
            }
            
            guard let stat = result["stat"] as? String , stat == "ok"  else {
                completion(nil , nil , "API returned an error , error code and message \(result)")
                return
            }
            
            guard let photosDictionary = result["photos"] as? [String:Any] else {
                completion(nil , nil , "cannot find key 'photo' in \(result)")
                return
            }
            guard let photosArray = photosDictionary["photo"] as? [[String:Any]] else {
                completion(nil , nil , "cannot find key 'photo' in \(photosDictionary)")
                return
            }
            
            let photosURLs = photosArray.compactMap { photosDictionary -> URL? in
                guard let url = photosDictionary["url_m"] as? String else { return nil }
                return URL(string : url)
            }
            completion(photosURLs , nil , nil )
    }
        task.resume()
}
    
    static func getURL (from parameters: [String:Any]  ) -> URL {
        var components = URLComponents()
        components.scheme = Constants.Flickr.APIScheme
        components.host = Constants.Flickr.APIHost
        components.path = Constants.Flickr.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key , value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
    
    static func bboxString (for coordinate : CLLocationCoordinate2D) -> String {
        
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        
        let minLongitude = max(longitude - Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.0)
        let minLatitude = max(latitude  - Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.0)
        let maxLongitude = min(longitude + Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.1)
        let maxLatitude = min(latitude  + Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.1)

        return "\(minLongitude),\(minLatitude),\(maxLongitude),\(maxLatitude)"
        
    }
}

