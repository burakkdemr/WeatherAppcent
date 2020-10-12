//
//  WeatherStatusCollectionViewCell.swift
//  WeatherAppcent
//
//  Created by burak on 8.10.2020.
//

import UIKit
import Kingfisher


class WeatherStatusCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblVisibility: UILabel!
    @IBOutlet weak var lblPressure: UILabel!
    @IBOutlet weak var lblPredictability: UILabel!
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configureConsilatedDetail(detail:ConsolidatedResponse){
        
        let imgUrl = "https://www.metaweather.com/static/img/weather/png/\(detail.weather_state_abbr).png"
        self.imgWeather.kf.indicatorType = .activity
        self.imgWeather.kf.setImage(with: URL(string: imgUrl), placeholder: nil, options: [.transition(.fade(0.2))], progressBlock: nil)
        
       
        self.lblDate.text = "\(detail.applicable_date)"
        self.maxTemp.text = "\(String(format: "%.1f", detail.max_temp))℃"
        self.minTemp.text = "\(String(format: "%.1f", detail.min_temp))℃"
        self.windSpeed.text = "\(detail.wind_direction_compass) \(String(format: "%.f", detail.wind_speed))mph"
        self.lblHumidity.text = "\(String(format: "%.f", detail.humidity))%"
        self.lblVisibility.text = "\(String(format: "%.1f", detail.visibility)) miles"
        self.lblPressure.text = "\(String(format: "%.f", detail.air_pressure))mb"
        self.lblPredictability.text = "\(detail.predictability)%"

    }
}
