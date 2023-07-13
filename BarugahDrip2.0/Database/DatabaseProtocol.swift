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
    case wear
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    
    ///When there is a change in the wardrobe
    func onGarmentChange(change: DatabaseChange, garments: [Garment])
    
    ///When there is a change in the outfits list
    func onOutfitsChange(change: DatabaseChange, outfits: [Outfit])
    
    ///When there is a change in the garments that make up the outfit
    func onOutfitGarmentsChange(change: DatabaseChange, garments: [Garment])
    
    ///When there is a change in the wearInfo of an outfit
    func onWearOutfitChange(change: DatabaseChange, wears: [WearInfo])

}

protocol DatabaseProtocol: AnyObject {
    
    var currentOutfit: Outfit? {get set}
    
    func addGarment(name: String, price: Double, brand: String, size: String, numberOfWears: Int, datePurchased: Date, image: String) -> Garment
    func deleteGarment(garment: Garment)
    
    func addOutfit(price: Double, wears: Int, outfitName: String, image: String) -> Outfit
    func deleteOutfit(outfit: Outfit)
    
    func addWear(date: Date) -> WearInfo
    func deleteWear(wearInfo: WearInfo)
    
    func addGarmentToOutfit(garment: Garment, outfit: Outfit) -> Bool
    func deleteGarmentFromOutfit(garment: Garment, outfit: Outfit)
    
    func addWearToOutfit(outfit: Outfit, wearInfo: WearInfo) -> Bool
    func deleteWearFromOutfit(outfit: Outfit, wearInfo: WearInfo)
    
    func incrementGarmentInSelectOutfit(outfit: Outfit)
    
    func fetchAllGarments() -> [Garment]
    
    func cleanup()
    
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
}
