//
//  WeatherDetailViewController.swift
//  WeatherAppcent
//
//  Created by burak on 8.10.2020.
//

import UIKit
import Alamofire
import SkeletonView


class WeatherDetailViewController: UIViewController {
    
    
    
    @IBOutlet weak var weatherStatusVC: UICollectionView!
    
    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblSunrise: UILabel!
    @IBOutlet weak var lblSunset: UILabel!
    @IBOutlet weak var lblTheTemp: UILabel!
    @IBOutlet weak var lblWeatherStateName: UILabel!
    
    
    
    var weatherDetailModel : WeatherDetailModel?
    var consolidatedResponse = [ConsolidatedResponse]()
    var parentResponse = [ParentResponse]()
    
    var woeid:Int?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradient = SkeletonGradient(baseColor: UIColor.clouds)
        self.view.showGradientSkeleton(usingGradient: gradient)
        
        getDatasourcesAndDelegates()
        getWeatherAndTimeDetail()
        
    }
    
    
    
    func getDatasourcesAndDelegates(){
        
        self.weatherStatusVC.dataSource = self
        self.weatherStatusVC.delegate = self
        
    }
    
    
    func getWeatherAndTimeDetail(){
        let url = "https://www.metaweather.com/api/location/\(woeid ?? -1)"
        
        
        AF.request(url).responseJSON { [self] (response) in
            let result = response.data
            do{
                let decoder = JSONDecoder()
                self.weatherDetailModel = try decoder.decode(WeatherDetailModel.self, from: result!)
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                self.weatherStatusVC.reloadData()
                
            }
            catch{
                print(error)
            }
            
            
            
            guard let jsonResult = self.weatherDetailModel else {return}
            
            let consolidatedResult = jsonResult.consolidated_weather
            self.consolidatedResponse = consolidatedResult
            
            
            let parentResult = jsonResult.parent
            self.parentResponse = [parentResult]
            
            
            //Country and City
            self.lblCountryName.text = jsonResult.parent.title
            self.lblCityName.text = jsonResult.title
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let currentDay = Date()
           
            //CUrrent Weather Temp and Weather State Name
            if dateFormatter.string(from: currentDay) == consolidatedResult.first?.applicable_date{
                self.lblWeatherStateName.text = consolidatedResult.first?.weather_state_name
                self.lblTheTemp.text = "\(String(format: "%.1f", consolidatedResult.first?.the_temp as! CVarArg))℃"
            }else{
                self.lblWeatherStateName.text = "unknown"
                self.lblTheTemp.text = "unknown"
            }
            
            
            //Date Format for time sunrise and sunset
            let formatted = DateFormatter()
            formatted.locale = Locale(identifier: "en_US_POSIX")
            formatted.timeZone = TimeZone(identifier: jsonResult.timezone)
            formatted.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSz"
            
            func getFormattedTime(inputTime inputStr: String) -> String {
                
                var formattedTime:String?
                
                if let time = formatted.date(from: inputStr) {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "h:mm a"
                    formattedTime =  formatter.string(from: time)
                }
                return formattedTime ?? "unknown"
            }
            
            let lblTime = getFormattedTime(inputTime: jsonResult.time)
            self.lblTime.text = lblTime
            
            let lblSunrise = getFormattedTime(inputTime: jsonResult.sun_rise)
            self.lblSunrise.text = lblSunrise
            
            let lblSunset = getFormattedTime(inputTime: jsonResult.sun_set)
            self.lblSunset.text = lblSunset
            
            self.view.hideSkeleton()
            
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
