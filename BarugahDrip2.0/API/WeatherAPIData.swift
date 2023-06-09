//
//  WeatherAPIData.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 6/6/2023.
//

import UIKit

class WeatherAPIData: NSObject, Decodable {
    /**
     Getting Weather Information using WeatherAPI.com
     */
    var name: String? // location name
    var temp_c: Int? // temp in celcius
    var text: String? // description of weather
    var code: Int? // code for weather
    var icon: String? // image path
    var long: Double? // longitude
    var lat: Double? // latitude
    
    private enum RootKeys: String, CodingKey{
        /**
         Root keys for API JSON
         */
        case current
        case location
    }
    
    private enum WeatherAPIKeys: String, CodingKey{
        /**
         Keys for WeatherAPI JSON
         */
        case name
        case temp_c
        case text
        case condition
        case lon
        case lat
    }
    
    private enum ConditionKeys: String, CodingKey{
        /**
         Keys for Condition
         */
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
        
        lat = try locationContainer.decode(Double.self, forKey: .lat)
        
        long = try locationContainer.decode(Double.self, forKey: .lon)
    }
    
}
