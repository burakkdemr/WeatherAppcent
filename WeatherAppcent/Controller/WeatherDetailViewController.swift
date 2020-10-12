//
//  WeatherDetailViewController.swift
//  WeatherAppcent
//
//  Created by burak on 8.10.2020.
//

import UIKit
import Alamofire

class WeatherDetailViewController: UIViewController {
    
    
    
    @IBOutlet weak var weatherStatusVC: UICollectionView!
    
    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblSunrise: UILabel!
    @IBOutlet weak var lblSunset: UILabel!
    
    
    var weatherDetailModel : WeatherDetailModel?
    var consolidatedResponse = [ConsolidatedResponse]()
    var parentResponse = [ParentResponse]()
    
    var woeid:Int?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDatasourcesAndDelegates()
        getWeatherDetail()
        
    }
    
    
    
    func getDatasourcesAndDelegates(){
        
        DispatchQueue.main.async {
            
        }
        self.weatherStatusVC.dataSource = self
        self.weatherStatusVC.delegate = self
        
    }
    
    
    func getWeatherDetail(){
        let url = "https://www.metaweather.com/api/location/\(woeid ?? -1)"
        
        AF.request(url).responseJSON { (response) in
            let result = response.data
            do{
                let decoder = JSONDecoder()
                self.weatherDetailModel = try decoder.decode(WeatherDetailModel.self, from: result!)
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                
                DispatchQueue.main.async {
                    self.weatherStatusVC.reloadData()
                }
                
            }
            catch{
                print(error)
            }
            
            
            
            guard let jsonResult = self.weatherDetailModel else {return}
            
            let consolidatedResult = jsonResult.consolidated_weather
            self.consolidatedResponse = consolidatedResult
            
            
            let parentResult = jsonResult.parent
            self.parentResponse = [parentResult]
            
            self.lblCountryName.text = jsonResult.parent.title
            self.lblCityName.text = jsonResult.title
            
            
            
            
            var timeCounter = 0
            
            while timeCounter < 3 {
                
                let formatted = DateFormatter()
                formatted.locale = Locale(identifier: "en_US_POSIX")
                formatted.timeZone = TimeZone(abbreviation: jsonResult.timezone_name)
                formatted.timeZone = .autoupdatingCurrent
                formatted.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
                
                switch timeCounter {
                case 0:
                    let inputTime = jsonResult.time
                    if let time = formatted.date(from: inputTime) {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "h:mm a"
                        self.lblTime.text = formatter.string(from: time)
                        
                    }
                case 2:
                    let inputSunset = jsonResult.sun_set
                    if let time = formatted.date(from: inputSunset) {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "h:mm a"
                        self.lblSunset.text = formatter.string(from: time)
                        
                    }
                case 1:
                    let inputSunRise = jsonResult.sun_rise
                    if let time = formatted.date(from: inputSunRise) {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "h:mm a"
                        self.lblSunrise.text = formatter.string(from: time)
                        
                    }
                    
                default:
                    print("error")
                }
                
                
                timeCounter += 1
            }
            
            
        }
    }
    
    
}





extension WeatherDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return consolidatedResponse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = weatherStatusVC.dequeueReusableCell(withReuseIdentifier: "WeatherStatusCollectionViewCell", for: indexPath) as! WeatherStatusCollectionViewCell
        
        let img = consolidatedResponse[indexPath.row]
        cell.configureConsilatedDetail(detail: img)
        
        let maxTemp = consolidatedResponse[indexPath.row]
        cell.configureConsilatedDetail(detail: maxTemp )
        
        let minTemp = consolidatedResponse[indexPath.row]
        cell.configureConsilatedDetail(detail: minTemp)
        
        
        let date = consolidatedResponse[indexPath.row]
        cell.configureConsilatedDetail(detail: date)
        
        
        let windDetail = consolidatedResponse[indexPath.row]
        cell.configureConsilatedDetail(detail: windDetail)
        
        let humudity = consolidatedResponse[indexPath.row]
        cell.configureConsilatedDetail(detail: humudity)
        
        
        let visibility = consolidatedResponse[indexPath.row]
        cell.configureConsilatedDetail(detail: visibility)
        
        let pressure = consolidatedResponse[indexPath.row]
        cell.configureConsilatedDetail(detail: pressure)
        
        
        let confidence = consolidatedResponse[indexPath.row]
        cell.configureConsilatedDetail(detail: confidence)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected \(indexPath.row+1)")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        return CGSize(width: bounds.width/3.5, height: bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
