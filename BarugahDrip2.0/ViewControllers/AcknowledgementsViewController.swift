//
//  AcknowledgementsViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 9/6/2023.
//

import UIKit

class AcknowledgementsViewController: UIViewController {

    @IBOutlet weak var textOutlet: UITextField! // text outlet of user
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.\
        
        textOutlet.text = "Powered by WeatherAPI.com" // set text
    }
}
