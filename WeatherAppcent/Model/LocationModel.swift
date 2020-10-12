//
//  LocationModel.swift
//  WeatherAppcent
//
//  Created by burak on 7.10.2020.
//

import Foundation

struct LocationModel: Decodable {
    var title: String
    var location_type: String
    var latt_long: String
    var woeid: Int
    var distance: Int
}
