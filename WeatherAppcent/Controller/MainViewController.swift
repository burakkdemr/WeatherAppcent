//
//  ViewController.swift
//  WeatherAppcent
//
//  Created by burak on 7.10.2020.
//

import UIKit
import Alamofire
import CoreLocation

class MainViewController: UIViewController {
    
    @IBOutlet weak var picker: UIPickerView!
    
    
    var locationModel: [LocationModel] = [LocationModel]()
    var locationManager = CLLocationManager()
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatasorucesAndDelegates()
    }
    

    
    func setupDatasorucesAndDelegates(){
        
        self.picker.dataSource = self
        self.picker.delegate = self
        
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
}



extension MainViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
        return locationModel.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return locationModel[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedIndex = row
        
        if let weatherDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "WeatherDetailViewController") as? WeatherDetailViewController{
            weatherDetailVC.woeid = locationModel[selectedIndex].woeid
            self.navigationController?.pushViewController(weatherDetailVC.self, animated: true)
        }
    }
}


extension MainViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            if location.horizontalAccuracy > 0 {
                locationManager.stopUpdatingLocation()
                
                let longitude = location.coordinate.longitude
                let latitude = location.coordinate.latitude
                
                
                
                let url = "https://www.metaweather.com/api/location/search/?lattlong=\(latitude),\(longitude)"
                
                AF.request(url).responseJSON { (response) in
                    let result = response.data
                    do{
                        let decoder = JSONDecoder()
                        self.locationModel = try decoder.decode([LocationModel].self, from: result!)
                        
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        
                        DispatchQueue.main.async {
                            self.picker.reloadAllComponents()
                        }
                    }
                    catch{
                        print(error)
                    }
                }
            }
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed, \(error)")
    }
}
