//
//  Garment+CoreDataProperties.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 9/6/2023.
//
//

import Foundation
import CoreData


extension Garment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Garment> {
        return NSFetchRequest<Garment>(entityName: "Garment")
    }

    @NSManaged public var brand: String? // brand of garment
    @NSManaged public var dateBought: Date? // date bought
    @NSManaged public var image: String? // image of garment
    @NSManaged public var name: String? // name of garment
    @NSManaged public var numberOfWears: Int32 // number of wears
    @NSManaged public var price: Double // price of garment
    @NSManaged public var size: String? // size of garment
    @NSManaged public var outfits: NSSet? // outfits garment is connected to

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
    
    public func incrementWears() {
        numberOfWears += 1
    }

}

extension Garment : Identifiable {

}
