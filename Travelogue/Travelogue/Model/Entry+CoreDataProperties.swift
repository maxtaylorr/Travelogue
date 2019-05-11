//
//  Entry+CoreDataProperties.swift
//  Travelogue
//
//  Created by Max Taylor on 5/10/19.
//  Copyright © 2019 Max Taylor. All rights reserved.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var name: String?
    @NSManaged public var rawImage: NSData?
    @NSManaged public var rawDateAdded: NSDate?
    @NSManaged public var content: String?
    @NSManaged public var trip: Trip?

}
