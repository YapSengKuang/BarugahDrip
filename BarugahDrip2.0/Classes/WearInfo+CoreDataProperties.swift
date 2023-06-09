//
//  WearInfo+CoreDataProperties.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 9/6/2023.
//
//

import Foundation
import CoreData


extension WearInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WearInfo> {
        return NSFetchRequest<WearInfo>(entityName: "WearInfo")
    }

    @NSManaged public var date: Date? // date worn
    @NSManaged public var event: String? // event description
    @NSManaged public var tempCelcuis: Int32 // temp in c
    @NSManaged public var outfit: NSSet? // outfit instance 

}

// MARK: Generated accessors for outfit
extension WearInfo {

    @objc(addOutfitObject:)
    @NSManaged public func addToOutfit(_ value: Outfit)

    @objc(removeOutfitObject:)
    @NSManaged public func removeFromOutfit(_ value: Outfit)

    @objc(addOutfit:)
    @NSManaged public func addToOutfit(_ values: NSSet)

    @objc(removeOutfit:)
    @NSManaged public func removeFromOutfit(_ values: NSSet)

}

extension WearInfo : Identifiable {

}
