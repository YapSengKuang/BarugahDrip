//
//  AcknowledgementsViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 9/6/2023.
//

import UIKit

class AcknowledgementsViewController: UIViewController {
    
    /*
     Tutorial's followed
     https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
     https://rapidapi.com/weatherapi/api/weatherapi-com
     https://www.youtube.com/watch?v=FIXU6d370K8
     https://www.hackingwithswift.com/example-code/uikit/how-to-hide-the-tab-bar-when-a-view-controller-is-shown
     https://www.youtube.com/watch?v=P7NzSWVIlWI
     https://www.youtube.com/watch?v=Cu2QvjRt4zM
     https://stackoverflow.com/questions/36178999/how-to-show-check-tick-mark-in-collection-view-images
     https://stackoverflow.com/questions/60482518/how-to-programmatically-change-the-default-icon-used-by-a-tab-bar-item
     https://stackoverflow.com/questions/53003494/call-collectionview-layoutsizeforitemat-in-swift-4
     https://www.hackingwithswift.com/books/ios-swiftui/scheduling-local-notifications
     https://iostutorialjunction.com/2019/09/create-local-notification-in-ios-using-swift-5.html
     https://stackoverflow.com/questions/29356574/how-to-load-specific-image-from-assets-with-swift
     
     LAB 2, 3, 4, 5, 6, 8, 9
     */

    @IBOutlet weak var multicastDelegatFile: UILabel!
    @IBOutlet weak var textOutlet: UILabel! // text outlet of user
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.\
        
        textOutlet.text = "Powered by WeatherAPI.com" // set text
        multicastDelegatFile.text = """
            This app utilises the follow third-party code, Use of which is hereby acknowledged.\
            
            
            1) MulticastDelegate.swift (Michael Wybrow, 23/3/19)
            
            Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
            
            """
        
    }
}
