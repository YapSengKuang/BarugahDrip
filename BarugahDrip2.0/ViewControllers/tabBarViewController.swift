//
//  tabBarViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 10/5/2023.
//

import UIKit

class TabBarController: UITabBarController {

    @IBInspectable var initialIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = initialIndex
    }

}
