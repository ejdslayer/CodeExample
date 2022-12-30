//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Elliott D'Alvarez on 08/12/2022.
//

import Foundation
import CoreLocation

protocol WeatherServiceProtocol {
    func getTodaysForecast(location: CLLocation) async throws -> DailyForecast?
    func getWeeklyForecast(location: CLLocation) async throws -> WeeklyForecast?
}

final class WeatherService: WeatherServiceProtocol {
    func getTodaysForecast(location: CLLocation) async throws -> DailyForecast? {
        let endpoint = Endpoints.getDaily(location: location)
        guard let url = URL(string: endpoint.url) else {
            throw NetworkErrors.invalidUrl
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let forecast = try JSONDecoder().decode(DailyForecast.self, from: data)
        return forecast
    }
    
    func getWeeklyForecast(location: CLLocation) async throws -> WeeklyForecast? {
        let endpoint = Endpoints.getWeekly(location: location)
        guard let url = URL(string: endpoint.url) else {
            throw NetworkErrors.invalidUrl
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let forecast = try JSONDecoder().decode(WeeklyForecast.self, from: data)
        return forecast
    }
}
