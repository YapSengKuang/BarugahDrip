//
//  MainMenuViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 10/5/2023.
//

import Foundation
import UIKit

class MainMenuViewController: UIViewController {
    var indicator = UIActivityIndicatorView()
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var textLabel: UILabel!
    
    var weatherData: WeatherAPIData?
    
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
        Task{
            //await requestWeather()
            setWeatherData()
        }
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
            tempLabel.text = String(temp)
        }
        
        if let code = weatherData?.code {
            
        }
        
    }
    
    func requestWeather() async {
        /**
         Requests for weather information from a location
         */
        
        let headers = [
            "X-RapidAPI-Key": "b2a635592emshaa0ae2ed3541cf9p198bdajsn43765fefaae5",
            "X-RapidAPI-Host": "weatherapi-com.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://weatherapi-com.p.rapidapi.com/current.json?q=53.1%2C-0.13")! as URL,
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
        

//        let session = URLSession.shared
//        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { [self] (data, response, error) -> Void in
//            if (error != nil) {
//                print(error as Any)
//            } else {
//
//                do{
//                    let decoder = JSONDecoder()
//                    let weatherDataOutput = try decoder.decode(WeatherAPIData.self, from: data!)
//                    setWeatherData(data: weatherDataOutput)
//                    print(weatherDataOutput)
//
//
//
//
//                }catch let error{
//                    print(error)
//                }
//
//                //let httpResponse = response as? HTTPURLResponse
//                //print(httpResponse)
//            }
//        })
//
//        dataTask.resume()
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
