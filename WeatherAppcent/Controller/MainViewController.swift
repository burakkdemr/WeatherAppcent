//
//  ViewController.swift
//  WeatherAppcent
//
//  Created by burak on 7.10.2020.
//

import UIKit
import Alamofire
import CoreLocation


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
    
    @IBOutlet weak var nearestTableView: UITableView!
    
    
    var locationModel = [LocationModel]()
    var locationManager = CLLocationManager()
    
    
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                if location.horizontalAccuracy > 0 {
                    locationManager.stopUpdatingLocation()
                    
                    let longitude = location.coordinate.longitude
                    let latitude = location.coordinate.latitude
                    
                    print("longitude = \(longitude), latitude = \(latitude)")
                    
                    
                    let url = "https://www.metaweather.com/api/location/search/?lattlong=\(latitude),\(longitude)"
                    
                    AF.request(url).responseJSON { (response) in
                        let result = response.data
                        do{
                            self.locationModel = try JSONDecoder().decode([LocationModel].self, from: result!)
                            
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationModel.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = nearestTableView.dequeueReusableCell(withIdentifier: "NearestCitiesTableViewCell", for: indexPath) as! NearestCitiesTableViewCell
        
        cell.lblNearCity?.text = self.locationModel[indexPath.row].title
        return cell
    }
    
}

