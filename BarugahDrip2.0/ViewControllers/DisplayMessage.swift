//
//  DisplayMessage.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 17/5/2023.
//

import Foundation

extension UIViewController{
    func displayMessage(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
