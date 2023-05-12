//
//  Outfit+CoreDataProperties.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 12/5/2023.
//
//

import Foundation
import CoreData


extension Outfit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Outfit> {
        return NSFetchRequest<Outfit>(entityName: "Outfit")
    }

    @NSManaged public var name: String?
    @NSManaged public var numberOfWears: Int32
    @NSManaged public var price: Double
    @NSManaged public var imageRef: Data?
    @NSManaged public var garments: NSSet?

}

// MARK: Generated accessors for garments
extension Outfit {

    @objc(addGarmentsObject:)
    @NSManaged public func addToGarments(_ value: Garment)

    @objc(removeGarmentsObject:)
    @NSManaged public func removeFromGarments(_ value: Garment)

    @objc(addGarments:)
    @NSManaged public func addToGarments(_ values: NSSet)

    @objc(removeGarments:)
    @NSManaged public func removeFromGarments(_ values: NSSet)

}

extension Outfit : Identifiable {

}
