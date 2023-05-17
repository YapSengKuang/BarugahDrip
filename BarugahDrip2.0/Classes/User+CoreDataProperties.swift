//
//  User+CoreDataProperties.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 17/5/2023.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var name: String?

}

extension User : Identifiable {

}
