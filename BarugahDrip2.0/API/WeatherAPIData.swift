//
//  WeatherAPIData.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 6/6/2023.
//

import UIKit

class WeatherAPIData: NSObject, Decodable {
    var name: String?
    var temp_c: Int?
    var text: String?
    var code: Int?
    var icon: String?
    
    private enum RootKeys: String, CodingKey{
        case current
        case location
    }
    
    private enum WeatherAPIKeys: String, CodingKey{
        case name
        case temp_c
        case text
        case condition
    }
    
    private enum ConditionKeys: String, CodingKey{
        case text
        case code
        case icon
    }
    
    required init(from decoder: Decoder) throws{
        // Get the root container
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        
        // Get the current container
        let currentContainer = try rootContainer.nestedContainer(keyedBy: WeatherAPIKeys.self, forKey: .current)
        
        // Get the location container
        let locationContainer = try rootContainer.nestedContainer(keyedBy: WeatherAPIKeys.self, forKey: .location)
        
        let conditionContainer = try currentContainer.nestedContainer(keyedBy: ConditionKeys.self, forKey: .condition)
        
        // Get info
        temp_c = try currentContainer.decode(Int.self, forKey: .temp_c)
        
        name = try locationContainer.decode(String.self, forKey: .name)
        
        text = try conditionContainer.decode(String.self, forKey: .text)
        
        code = try conditionContainer.decode(Int.self, forKey: .code)
        
        icon = try conditionContainer.decode(String.self, forKey: .icon)
        
    }
    
}
