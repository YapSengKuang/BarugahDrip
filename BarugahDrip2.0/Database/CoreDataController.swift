//
//  CoreDataController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 10/5/2023.
//

import Foundation
import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate {
    var currentOutfit: Outfit? // instance of current outfit
    var outfitGarmentsFetchedResultsController: NSFetchedResultsController<Garment>? // controller for garments from an outfit
    var outfitWearInfoFetchedResultsController: NSFetchedResultsController<WearInfo>? // controller for wear from an outfit
    var allOutfitsFetchedResultsController: NSFetchedResultsController<Outfit>? // controller for all outfits
    var allGarmentsFetchedResultsController: NSFetchedResultsController<Garment>? // controller for all garments
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer // coredata
    
    override init() {
        // Initialise persistentContainer
        persistentContainer = NSPersistentContainer(name: "BarugahDrip2_0")
        
        // Load Core data and provide closure for error handling
        
        persistentContainer.loadPersistentStores() { (description,error) in
            if let error = error{
                fatalError("Failed to load Core Data Stack with error: \(error)")
            }
        }
        super.init()
    }
    
    func addGarment(name: String, price: Double, brand: String, size: String, numberOfWears: Int, datePurchased: Date, image: String) -> Garment {
        /**
         Create and add a garment to CoreData given a valid name, price, brand, size, number of wears and date purchased.
         */
        let garment = NSEntityDescription.insertNewObject(forEntityName: "Garment", into: persistentContainer.viewContext) as! Garment
        garment.name = name
        garment.price = price
        garment.brand = brand
        garment.size = size
        garment.numberOfWears = Int32(numberOfWears)
        garment.dateBought = datePurchased
        garment.image = image
        
        return garment
    }
    
    func deleteGarment(garment: Garment) {
        /**
         Deletes a garment from coredata
         */
        persistentContainer.viewContext.delete(garment)
        
    }
    
    func addOutfit(price: Double, wears: Int, outfitName: String, image: String) -> Outfit{
        /**
         Creates and adds an empty outfit to CoreDate, given valid price, wears and outfitName
         */
        let outfit = NSEntityDescription.insertNewObject(forEntityName: "Outfit", into: persistentContainer.viewContext) as! Outfit
        outfit.price = price
        outfit.name = outfitName
        outfit.image = image
        outfit.dateCreated = Date()
        
        return outfit
        
    }
    
    func deleteOutfit(outfit: Outfit) {
        /**
         Deletes an outfit given the Outfit instance from CoreData
         */
        persistentContainer.viewContext.delete(outfit)
    }
    
    func addWear(date: Date) -> WearInfo {
        /**
         Creates WearInfo to CoreData, given date, tempCelcuis and event
         */
        let wearInfo = NSEntityDescription.insertNewObject(forEntityName: "WearInfo", into: persistentContainer.viewContext) as! WearInfo
        wearInfo.date = date
        
        return wearInfo
    }
    
    func deleteWear(wearInfo: WearInfo) {
        /**
         Deletes a WearInfo from coreData
         */
        persistentContainer.viewContext.delete(wearInfo)
    }
    
    func addWearToOutfit(outfit: Outfit, wearInfo: WearInfo) -> Bool {
        /**
         Adds a WearInfo class to outfits
         */
        outfit.addToWears(wearInfo)
        
       
        cleanup()
        return true
    }
    
    func deleteWearFromOutfit(outfit: Outfit, wearInfo: WearInfo) {
        /**
         Removes a WearInfo from Outfit
         */
        outfit.removeFromWears(wearInfo)
        cleanup()
    }
    
    func addGarmentToOutfit(garment: Garment, outfit: Outfit) -> Bool {
        /**
         Adds a garment to an outfit. Does not do this in Coredata
         */
        outfit.addToGarments(garment)
        return true
    }
    
    func deleteGarmentFromOutfit(garment: Garment, outfit: Outfit) {
        /**
         Removes garment from a given outfit
         */
        outfit.removeFromGarments(garment)
    }
    
    func fetchAllGarments() -> [Garment]{
        /**
         Fetches all garments in CoreData, using results controller. If there is no results controller, this is initialised
         */
        
        
        if allGarmentsFetchedResultsController == nil {
            //Create fetch request
            let request: NSFetchRequest<Garment> = Garment.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "dateBought", ascending: true)
            request.sortDescriptors = [nameSortDescriptor]
            
            //Intialise Fetch results controller
            allGarmentsFetchedResultsController = NSFetchedResultsController<Garment>(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            //Set delegate to self
            allGarmentsFetchedResultsController?.delegate = self
            
            //Perform Fetch request
            do{
                try allGarmentsFetchedResultsController?.performFetch()
            }catch{
                print("Fetch Request Failed: \(error)")
            }
            
        }
        
        if let garments = allGarmentsFetchedResultsController?.fetchedObjects {
            return garments
        }
        
        return [Garment]()
    }
    
    func fetchAllOutfits() -> [Outfit]{
        /**
         Fetches all Outfits in CoreData, using results controller. If there is no results controller, this is initialised
         */
        if allOutfitsFetchedResultsController == nil {
            //Create fetch request
            let request: NSFetchRequest<Outfit> = Outfit.fetchRequest()
            let nameSortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: true)
            request.sortDescriptors = [nameSortDescriptor]
            
            //Intialise Fetch results controller
            allOutfitsFetchedResultsController = NSFetchedResultsController<Outfit>(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            //Set delegate to self
            allOutfitsFetchedResultsController?.delegate = self
            
            //Perform Fetch request
            do{
                try allOutfitsFetchedResultsController?.performFetch()
            }catch{
                print("Fetch Request Failed: \(error)")
            }
            
        }
        
        if let outfit = allOutfitsFetchedResultsController?.fetchedObjects {
            return outfit
        }
        
        return [Outfit]()
    }
    
    func fetchGarmentFromCurrentOutfit() -> [Garment]{
        /**
         Fetches the garments in the stored currentOutfit, from CoreData
         */
        let fetchRequest: NSFetchRequest<Garment> = Garment.fetchRequest()
        let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        let outfitName = currentOutfit?.name
        
        let predicate = NSPredicate(format: "ANY outfits.name == %@", outfitName!)
        
        fetchRequest.sortDescriptors = [nameSortDescriptor]
        fetchRequest.predicate = predicate
        
        outfitGarmentsFetchedResultsController =
        NSFetchedResultsController<Garment>(fetchRequest: fetchRequest,
                                            managedObjectContext: persistentContainer.viewContext,
                                            sectionNameKeyPath: nil, cacheName: nil)
        
        outfitGarmentsFetchedResultsController?.delegate = self
        
        do {
            try outfitGarmentsFetchedResultsController?.performFetch()
        } catch {
            print("Fetch Request Failed: \(error)")
        }
        
        
        var garments = [Garment]()
        if outfitGarmentsFetchedResultsController?.fetchedObjects != nil {
            garments = (outfitGarmentsFetchedResultsController?.fetchedObjects)!
        }
        return garments
    }
    
    func incrementGarmentInSelectOutfit(outfit: Outfit) {
        /**
         Increment the wear of the garment in an Outfit
         */
        let fetchRequest: NSFetchRequest<Garment> = Garment.fetchRequest()
        let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        let outfitName = outfit.name
        
        let predicate = NSPredicate(format: "ANY outfits.name == %@", outfitName!)
        
        fetchRequest.sortDescriptors = [nameSortDescriptor]
        fetchRequest.predicate = predicate
        
        outfitGarmentsFetchedResultsController =
        NSFetchedResultsController<Garment>(fetchRequest: fetchRequest,
                                            managedObjectContext: persistentContainer.viewContext,
                                            sectionNameKeyPath: nil, cacheName: nil)
        
        outfitGarmentsFetchedResultsController?.delegate = self
        
        do {
            try outfitGarmentsFetchedResultsController?.performFetch()
        } catch {
            print("Fetch Request Failed: \(error)")
        }
        
        
        var garments = [Garment]()
        if outfitGarmentsFetchedResultsController?.fetchedObjects != nil {
            garments = (outfitGarmentsFetchedResultsController?.fetchedObjects)!
        }
        
        for garment in garments{
            garment.numberOfWears += 1
        }
        
        cleanup()
    }
    
    
    func fetchWearsFromCurrentOutfit() -> [WearInfo]{
        /**
         Fetches the array of WearInfo from an outift
         */
        let fetchRequest: NSFetchRequest<WearInfo> = WearInfo.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        
        let outfitName = currentOutfit?.name
        
        let predicate = NSPredicate(format: "ANY outfit.name == %@", outfitName!)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        
        outfitWearInfoFetchedResultsController =
        NSFetchedResultsController<WearInfo>(fetchRequest: fetchRequest,
                                             managedObjectContext: persistentContainer.viewContext,
                                             sectionNameKeyPath: nil, cacheName: nil)
        outfitWearInfoFetchedResultsController?.delegate = self
        
        do {
            try outfitWearInfoFetchedResultsController?.performFetch()
        }catch{
            print("Fetch Request Failed: \(error)")
            
        }
        
        var wears = [WearInfo]()
        if outfitWearInfoFetchedResultsController?.fetchedObjects != nil{
            wears = (outfitWearInfoFetchedResultsController?.fetchedObjects)!
        }
        
        return wears
    }
    
    func cleanup() {
        /**
         Clean up method checks if there are changes to CoreData then saves the changes made to CoreData
         */
        if persistentContainer.viewContext.hasChanges{
            do{
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save changes to Core Data with error: \(error)")
            }
        }
    }
    
    func addListener(listener: DatabaseListener) {
        /**
         addListener Method adds a listener to a list of listeners.
         */
        
        listeners.addDelegate(listener)
        
        if listener.listenerType == .garment || listener.listenerType == .all{
            listener.onGarmentChange(change: .update, garments: fetchAllGarments())
        }
        
        if listener.listenerType == .outfits{
            listener.onOutfitsChange(change: .update, outfits: fetchAllOutfits())
        }
        if listener.listenerType == .outfit || listener.listenerType == .all{
            listener.onOutfitGarmentsChange(change: .update, garments: fetchGarmentFromCurrentOutfit())
        }
        if listener.listenerType == .outfit || listener.listenerType == .wear || listener.listenerType == .all{
            listener.onWearOutfitChange(change: .update, wears: fetchWearsFromCurrentOutfit())
        }
        
    }
    
    func removeListener(listener: DatabaseListener) {
        /**
         Removes listener from saved listeners
         */
        listeners.removeDelegate(listener)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        /**
         Method called when there is a change in content
         */
        if controller == allGarmentsFetchedResultsController{
            listeners.invoke(){ listener in
                if listener.listenerType == .garment || listener.listenerType == .all {
                    listener.onGarmentChange(change: .update, garments: fetchAllGarments())
                }
                
            }
        }else if controller == outfitGarmentsFetchedResultsController{
            listeners.invoke(){ listener in
                
                if listener.listenerType == .outfit || listener.listenerType == .all{
                    listener.onOutfitGarmentsChange(change: .update, garments: fetchGarmentFromCurrentOutfit())
                }
            }
        }else if controller == allOutfitsFetchedResultsController{
            listeners.invoke(){ listener in
                if listener.listenerType == .outfits{
                    listener.onOutfitsChange(change: .update, outfits: fetchAllOutfits())
                }
            }
        }else if controller == outfitWearInfoFetchedResultsController{
            listeners.invoke(){ listener in
                if listener.listenerType == .wear || listener.listenerType == .all{
                    listener.onWearOutfitChange(change: .update, wears: fetchWearsFromCurrentOutfit())
                }
                
            }
        }
    }
}


