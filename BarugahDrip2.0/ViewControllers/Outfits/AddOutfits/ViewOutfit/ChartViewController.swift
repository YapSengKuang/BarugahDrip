//
//  ChartViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 26/5/2023.
//

import UIKit
import SwiftUI

class ChartViewController: UIViewController {
    
    var dataset: [WearInfo]?

    override func viewDidLoad() {
        super.viewDidLoad()

        let controller = UIHostingController(rootView: ChartUIView())
        
        guard let chartView = controller.view else {
            return
        }
        
        controller.rootView.data = getArrayOfDates()
        
        view.addSubview(chartView)
        addChild(controller)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                    constant: 12.0),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                    constant: -12.0),
            chartView.topAnchor.constraint(equalTo:
                    view.safeAreaLayoutGuide.topAnchor, constant: 12.0),
            chartView.widthAnchor.constraint(equalTo: chartView.heightAnchor)
        ])
    }
    
    func getArrayOfDates() -> [WearCountStruc] {
        /**
         Function gets the array of wears per month from an array of WearInfo class
         */
        
        let dateFormatter = DateFormatter()
        let shortenedMonths = dateFormatter.shortStandaloneMonthSymbols
        
        var wearArray: [WearCountStruc] = []
        
        for month in shortenedMonths!{
            wearArray.append(WearCountStruc(month: month, wears: 0))
        }

        for wearInfo in self.dataset!{
            
            let date = wearInfo.date // Replace with your specific date

            let calendar = Calendar.current
            let components = calendar.dateComponents([.month], from: date!)

            if let month = components.month {
                let monthIndex = month - 1
                wearArray[monthIndex].wears += 1
            } else {
                print("Failed to extract month from the date.")
            }
        }
        
        return wearArray
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
