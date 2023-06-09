//
//  tabBarViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 10/5/2023.
//

import UIKit

class TabBarController: UITabBarController {

    @IBInspectable var initialIndex: Int = 1
    override func viewDidLoad() {
        // set the default page to home page
        super.viewDidLoad()
        selectedIndex = initialIndex
    }

}
