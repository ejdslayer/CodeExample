//
//  WeatherModels.swift
//  WeatherApp
//
//  Created by Elliott D'Alvarez on 08/12/2022.
//

import Foundation

/// - Contains the models for all server weather mapping

// MARK: Daily
struct DailyForecast: Decodable, Identifiable {
    var id: UUID = UUID()
    var weather: [Weather]
    var atmospherics: Atmospherics

    // Custom keys as 'main' seems like a weird naming convention
    enum CodingKeys: String, CodingKey {
        case weather
        case atmospherics = "main"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.weather = try container.decode([Weather].self, forKey: .weather)
        self.atmospherics = try container.decode(Atmospherics.self, forKey: .atmospherics)
    }
}

// MARK: Weekly
struct WeeklyForecast: Decodable {
    var list: [DailyForecast]
}

// MARK: Weather
struct Weather: Identifiable, Decodable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

// MARK: Atmospherics
struct Atmospherics: Decodable {
    var temp: Double
    var feels_like: Double
    var temp_min: Double
    var temp_max: Double
    var pressure: Int
    var humidity: Int
}

// MARK: Mocks
extension DailyForecast {
    static func mock() -> DailyForecast {
        return DailyForecast()
    }
    
    private init() {
        weather = [Weather(id: 1, main: "Sun", description: "It's sunny", icon: "location")]
        atmospherics = Atmospherics(temp: 1, feels_like: 2, temp_min: 0, temp_max: 3, pressure: 10, humidity: 100)
    }
}

extension WeeklyForecast {
    static func mock() -> WeeklyForecast {
        return WeeklyForecast()
    }
    
    private init() {
        list = [DailyForecast.mock(), DailyForecast.mock(), DailyForecast.mock(), DailyForecast.mock(), DailyForecast.mock()]
    }
}
