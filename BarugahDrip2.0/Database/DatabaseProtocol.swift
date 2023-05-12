//
//  DatabaseProtocol.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 10/5/2023.
//

import Foundation
import UIKit

enum DatabaseChange{
    /*
     Used to define what change has been done to the database
     */
    case add
    case remove
    case update
}

enum ListenerType{
    /*
     Used to specify type of data our listener will be dealing with
     */
    case all
    case outfits
    case garment
    case outfit
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    
    ///When there is a change in the wardrobe
    func onGarmentChange(change: DatabaseChange, garments: [Garment])
    
    ///When there is a change in the outfits list
    func onOutfitsChange(change: DatabaseChange, outfits: [Outfit])
    
    ///When there is a change in the garments that make up the outfit
    func onOutfitGarmentsChange(change: DatabaseChange, garments: [Garment])

}

protocol DatabaseProtocol: AnyObject {
    
    var currentOutfit: Outfit? {get set}
    var currentUser: User? {get set}
    
    func addGarment(name: String, price: Double, brand: String, size: String, numberOfWears: Int, datePurchased: Date) -> Garment
    func deleteGarment(garment: Garment)
    
    func addOutfit(price: Double, wears: Int, outfitName: String)
    func deleteOutfit(outfit: Outfit)
    
    func addGarmentToOutfit(garment: Garment, outfit: Outfit) -> Bool
    func deleteGarmentFromOutfit(garment: Garment, outfit: Outfit)
    
    func cleanup()
    
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    
    func addUser(name: String)
    
    func deleteUser(user: User)
}
