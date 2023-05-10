//
//  Garment+CoreDataProperties.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 10/5/2023.
//
//

import Foundation
import CoreData


extension Garment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Garment> {
        return NSFetchRequest<Garment>(entityName: "Garment")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var brand: String?
    @NSManaged public var size: String?
    @NSManaged public var numberOfWears: Int16
    @NSManaged public var dateBought: Date?
    @NSManaged public var imageRef: String?
    @NSManaged public var outfits: NSSet?

}

// MARK: Generated accessors for outfits
extension Garment {

    @objc(addOutfitsObject:)
    @NSManaged public func addToOutfits(_ value: Outfit)

    @objc(removeOutfitsObject:)
    @NSManaged public func removeFromOutfits(_ value: Outfit)

    @objc(addOutfits:)
    @NSManaged public func addToOutfits(_ values: NSSet)

    @objc(removeOutfits:)
    @NSManaged public func removeFromOutfits(_ values: NSSet)

}

extension Garment : Identifiable {

}
