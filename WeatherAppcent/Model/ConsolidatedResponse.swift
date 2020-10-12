//
//  ConsolidatedResponse.swift
//  WeatherAppcent
//
//  Created by burak on 8.10.2020.
//

import Foundation

struct ConsolidatedResponse: Codable {
    var id: Int
    var applicable_date: String
    var weather_state_name: String
    var weather_state_abbr: String
    var wind_speed: Float
    var wind_direction: Float
    var wind_direction_compass: String
    var min_temp : Float
    var max_temp: Float
    var the_temp: Float
    var air_pressure: Float
    var humidity: Float
    var visibility: Float
    var predictability: Int
    
}



