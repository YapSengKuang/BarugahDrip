//
//  MainMenuViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 10/5/2023.
//

import Foundation
import UIKit
import CoreLocation

class MainMenuViewController: UIViewController, CLLocationManagerDelegate{
    var manager: CLLocationManager = CLLocationManager()
    
    var indicator = UIActivityIndicatorView()
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var textLabel: UILabel!
    
    var weatherData: WeatherAPIData?
    
    var longitude: String?
    
    var latitude: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a loading indicator view
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo:
                                                view.safeAreaLayoutGuide.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo:
                                                view.safeAreaLayoutGuide.centerYAnchor)
        ])
        // Do any additional setup after loading the view.

        //print(weatherData?.text)
    }
    
    func setWeatherData(){
        /**
         Method used to set the labels to the values in weatherData
         */
        
        if let text = weatherData?.text{
            textLabel.text = text
        }
        
        if let temp = weatherData?.temp_c{
            tempLabel.text = String(temp) + " C"
        }
        
        
        
        if let iconLink = weatherData?.icon {
            
            // Split the string by "/"
            let components = iconLink.components(separatedBy: "/")

            // Find the component that contains the number
            if let numberComponent = components.last, numberComponent.hasSuffix(".png") {
                let iconName = String(numberComponent.dropLast(4))
                print(iconName)
                
                weatherIcon.image = UIImage(named: iconName)
            }

        }
        
        
        
    }
    
    func requestWeather() async {
        /**
         Requests for weather information from a location
         */
        
        // Get Longitude and Latitude
        

        
        if let longitude = Double(longitude!), let latitude = Double(latitude!){
            let longitudeFormatted = String(format: "%.1f", longitude)
            let latitudeFormateed = String(format: "%.1f", latitude)
            
            let headers = [
                "X-RapidAPI-Key": "b2a635592emshaa0ae2ed3541cf9p198bdajsn43765fefaae5",
                "X-RapidAPI-Host": "weatherapi-com.p.rapidapi.com"
            ]
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://weatherapi-com.p.rapidapi.com/current.json?q=\(latitudeFormateed)%2C\(longitudeFormatted)")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
            }
            
            do{
                let (data, response) = try await URLSession.shared.data(for: request as URLRequest)
                print(response)
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                }
                
                do{
                    let decoder = JSONDecoder()
                    let weatherDataOutput = try decoder.decode(WeatherAPIData.self, from: data)
                    weatherData = weatherDataOutput
                    
                }catch let error{
                    print(error)
                }
            }catch let error{
                print(error)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else{
            return
        }
        
        longitude = String(first.coordinate.longitude)
        print("Longitude = " + longitude!)
        latitude = String(first.coordinate.latitude)
        print("Latitude = " + latitude!)
        
        Task{
            await requestWeather()
            //setWeatherData()
        }
    }
}
