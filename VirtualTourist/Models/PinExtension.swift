//
//  PinExtension.swift
//  VirtualTourist
//
//  Created by M7md on 21/06/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import MapKit

extension Pin {
    var coordinate : CLLocationCoordinate2D {
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    func compare(to coordinate : CLLocationCoordinate2D) -> Bool{
        return (latitude == coordinate.latitude && longitude == coordinate.longitude)
    }
    public override func awakeFromInsert (){
        super.awakeFromInsert()
        creationDate = Date()
    }
}
