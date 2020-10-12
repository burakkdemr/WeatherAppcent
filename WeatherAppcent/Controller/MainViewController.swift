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
    
    @IBOutlet weak var nearestTableView: UITableView!
    
    
    var locationModel: [LocationModel] = [LocationModel]()
    var locationManager = CLLocationManager()
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatasorucesAndDelegates()
        
    }
    
    
    func setupDatasorucesAndDelegates(){
        
        self.nearestTableView.dataSource = self
        self.nearestTableView.delegate = self
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
    }
    
}





extension MainViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationModel.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = nearestTableView.dequeueReusableCell(withIdentifier: "NearestCitiesTableViewCell", for: indexPath) as! NearestCitiesTableViewCell
        
        let nearCity = self.locationModel[indexPath.row]
        cell.configureCityListCell(near: nearCity)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.row
    
        if let weatherDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "WeatherDetailViewController") as? WeatherDetailViewController{
            weatherDetailVC.woeid = locationModel[selectedIndex].woeid
            self.navigationController?.pushViewController(weatherDetailVC, animated: true)
            self.show(weatherDetailVC, sender: nil) // Cozulecek burasi
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
                        self.locationModel = try JSONDecoder().decode([LocationModel].self, from: result!)
                        
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        
                        DispatchQueue.main.async {
                            self.nearestTableView.reloadData()
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
