//
//  WeatherDetailModel.swift
//  WeatherAppcent
//
//  Created by burak on 8.10.2020.
//

import Foundation


struct WeatherDetailModel: Codable {
    var consolidated_weather: [ConsolidatedResponse]
    var time: String
    var sun_rise: String
    var sun_set: String
    var timezone_name:String
    var parent: ParentResponse
    var title: String
    var location_type: String
    var woeid: Int
    var latt_long: String
    var timezone: String
}

 



