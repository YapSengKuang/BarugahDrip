//
//  WearInfo+CoreDataProperties.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 24/5/2023.
//
//

import Foundation
import CoreData


extension WearInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WearInfo> {
        return NSFetchRequest<WearInfo>(entityName: "WearInfo")
    }

    @NSManaged public var date: Date?
    @NSManaged public var tempCelcuis: Int32
    @NSManaged public var event: String?
    @NSManaged public var outfit: NSSet?

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
