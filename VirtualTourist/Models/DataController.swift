//
//  DataController.swift
//  VirtualTourist
//
//  Created by M7md on 21/06/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    static let sharedInstance = DataController()
    
    let persistentContainer = NSPersistentContainer(name: "VirtualTourist")
    var viewContext : NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    func load(){
        persistentContainer.loadPersistentStores { (storeDiscription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
        }
    }
}
