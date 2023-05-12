//
//  signUpPageViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 10/5/2023.
//

import UIKit

class signUpPageViewController: UIViewController, DatabaseListener {
    var listenerType: ListenerType = .all
    
    weak var databaseController: DatabaseProtocol?
    @IBOutlet weak var nameLabel: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        if databaseController?.currentUser != nil{
            performSegue(withIdentifier: "signup", sender: self)
        }
        
    }
    
    @IBAction func continueButton(_ sender: Any) {
        
        guard let name = nameLabel.text, name != "" else {
            return
        }
        
        databaseController?.addUser(name: name)
        performSegue(withIdentifier: "signup", sender: self)
        databaseController?.cleanup()
    }
    
    func onGarmentChange(change: DatabaseChange, garments: [Garment]) {
        //Nothing
    }
    
    func onOutfitsChange(change: DatabaseChange, outfits: [Outfit]) {
        //Nothing
    }
    
    func onOutfitGarmentsChange(change: DatabaseChange, garments: [Garment]) {
        //Nothing
    }
}
