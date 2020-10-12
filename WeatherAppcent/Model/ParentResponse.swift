//
//  ParentResponse.swift
//  WeatherAppcent
//
//  Created by burak on 8.10.2020.
//

import Foundation


struct ParentResponse: Codable{
    var title: String
    var location_type: String
    var woeid: Int
    var latt_long: String
}
