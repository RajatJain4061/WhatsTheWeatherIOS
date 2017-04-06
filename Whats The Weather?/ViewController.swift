//
//  ViewController.swift
//  Whats The Weather?
//
//  Created by user on 05/04/17.
//  Copyright © 2017 arya. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var textFieldCity: UITextField!

    @IBAction func fetchWeather(_ sender: Any) {
        
        if let url = URL(string:"http://www.weather-forecast.com/locations/" + textFieldCity.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") {
            
            let request = NSMutableURLRequest(url: url);
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                
                var message = ""
                
                if(error != nil){
                    
                    print(error)
                    
                } else {
                    
                    if let unwrappedData = data {
                        
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        
                        //print(dataString)
                        
                        let stringSeperator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">";
                        
                        if let contentArray = dataString?.components(separatedBy: stringSeperator) {
                            
                            if contentArray.count > 1 {
                                
                            let stringSeperator = "</span>";
                            
                            let newContentArray = contentArray[1].components(separatedBy: stringSeperator)
                            
                            if newContentArray.count > 1 {
                                
                                message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                
                                print(message)
                                
                            }
                                
                            }
                            
                        }
                        
                    }
                }
                
                if message == "" {
                    message = "The weather there couldn't be found. Please try again;"
                }
                DispatchQueue.main.sync(execute: {
                    
                    self.weatherResult.text = message
                    
                    
                })
            }
            
            task.resume()
        } else {
            weatherResult.text = "The weather there couldn't be found. Please try again;"
        }

    }

    @IBOutlet weak var weatherResult: UILabel!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

