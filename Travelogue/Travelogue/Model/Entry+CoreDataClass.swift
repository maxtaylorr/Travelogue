//
//  Entry+CoreDataClass.swift
//  Travelogue
//
//  Created by Max Taylor on 5/10/19.
//  Copyright © 2019 Max Taylor. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Entry)
public class Entry: NSManagedObject {
    
    var dateAdded: Date? {
        get {
            return rawDateAdded as Date?
        }
        set {
            rawDateAdded  = newValue as NSDate?
        }
    }
    
    var image: UIImage? {
        get {
            if let imageData = rawImage as Data? {
                return UIImage(data: imageData)
            } else {
                return nil
            }
        }
        set {
            if let image = newValue {
                rawImage = convertImageToNSData(image: image)
            }
        }
    }
    
    convenience init?(name: String?, content: String?, image: UIImage?, trip: Trip) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext,
            let name = name, name != "" else {
                return nil
        }
        self.init(entity: Entry.entity(), insertInto: managedContext)
        self.name = name
        self.content = content
        
        self.dateAdded = Date(timeIntervalSinceNow: 0)
        
        if let image = image {
            self.rawImage = convertImageToNSData(image: image)
        }
    }
    
    func convertImageToNSData(image: UIImage) -> NSData? {

        return processImage(image: image).pngData() as NSData?
    }
    
    func processImage(image: UIImage) -> UIImage {
        if (image.imageOrientation == .up) {
            return image
        }
        
        UIGraphicsBeginImageContext(image.size)
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size), blendMode: .copy, alpha: 1.0)
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        guard let unwrappedCopy = copy else {
            return image
        }
        
        return unwrappedCopy
    }
    
    func update(name: String, content: String?, image: UIImage?, trip: Trip) {
        self.name = name
        self.content = content
    
        self.dateAdded = Date(timeIntervalSinceNow: 0)
        self.trip = trip
        
        if let image = image {
            self.rawImage = convertImageToNSData(image: image)
        }
    }
}
