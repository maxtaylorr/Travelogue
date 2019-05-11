//
//  Trip+CoreDataClass.swift
//  Travelogue
//
//  Created by Max Taylor on 5/10/19.
//  Copyright © 2019 Max Taylor. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Trip)
public class Trip: NSManagedObject {
    
    convenience init?(name: String?) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate  //UIKit is needed to access UIApplication
        guard let managedContext = appDelegate?.persistentContainer.viewContext,
            let name = name, name != "" else {
                return nil
        }
        
        self.init(entity: Trip.entity(), insertInto: managedContext)
        self.name = name
    }
}
