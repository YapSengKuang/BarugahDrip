//
//  Garment+CoreDataProperties.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 14/7/2023.
//
//

import Foundation
import CoreData


extension Garment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Garment> {
        return NSFetchRequest<Garment>(entityName: "Garment")
    }

    @NSManaged public var brand: String?
    @NSManaged public var dateBought: Date?
    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var numberOfWears: Int32
    @NSManaged public var price: Double
    @NSManaged public var size: String?
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
    
    public func incrementWears(){
        numberOfWears += 1
    }
}

extension Garment : Identifiable {

}
