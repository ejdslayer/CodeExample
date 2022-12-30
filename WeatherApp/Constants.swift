//
//  Constants.swift
//  WeatherApp
//
//  Created by Elliott D'Alvarez on 08/12/2022.
//

import Foundation

enum API {
    static let baseUrl = "https://api.openweathermap.org/data/2.5/"
    static let baseImageUrl = "https://openweathermap.org/img/wn/"

    static var apiKey: String {
        guard let filepath = Bundle.main.path(forResource: "Debug-keys", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filepath) else {
            fatalError("Cannot find keys plist")
        }
        guard let apiKey = plist["WEATHER_API_KEY"] as? String else {
            fatalError("Cannot find weather api key")
        }
        
        return apiKey
    }
}
