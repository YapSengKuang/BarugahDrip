//
//  LodgeOutfitViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 26/5/2023.
//

import UIKit

class LodgeOutfitViewController: UIViewController {

    @IBOutlet weak var occasionOutlet: UITextField!
    @IBOutlet weak var tempOutlet: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    weak var databaseController: DatabaseProtocol?
    var outfitToLodge: Outfit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
    }
    
    @IBAction func nextButton(_ sender: Any) {
        guard let temp = Int(tempOutlet.text!) else {
            return
        }
        guard let occasion = occasionOutlet.text, occasion != "" else {
            return
        }
        
        let wearInfo = (databaseController?.addWear(date: datePicker.date, tempCelcuis: temp, event: occasion))!
        
        let _ = databaseController?.addWearToOutfit(outfit: outfitToLodge!, wearInfo: wearInfo)
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
