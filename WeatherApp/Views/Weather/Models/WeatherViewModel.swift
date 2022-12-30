//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Elliott D'Alvarez on 08/12/2022.
//

import Foundation
import CoreLocation

// MARK: Defining protocols for available functions
protocol WeatherViewModelProtocol: ObservableObject {
    func fetchTodaysForecast(location: CLLocation?) async
    func fetchWeeklyForecast(location: CLLocation?) async
}

// MARK: Main view model
@MainActor
class WeatherViewModel: WeatherViewModelProtocol {
    @Published var dailyForecast: DailyForecast?
    @Published var weeklyForecast: WeeklyForecast?
    private let service: WeatherService

    init(service: WeatherService) {
        self.service = service
//        // MARK: Remove this for non-mocked
//        self.dailyForecast = DailyForecast.mock()
//        self.weeklyForecast = WeeklyForecast.mock()
    }

    func fetchTodaysForecast(location: CLLocation?) async {
        guard let location = location else {
            // TODO: Handle no location retry
            return
        }
        
        do {
            self.dailyForecast = try await service.getTodaysForecast(location: location)
        } catch {
            // TODO: Handle network errors
            print(error)
        }
    }
    
    func fetchWeeklyForecast(location: CLLocation?) async {
        guard let location = location else {
            // TODO: Handle no location retry
            return
        }
        
        do {
            self.weeklyForecast = try await service.getWeeklyForecast(location: location)
        } catch {
            // TODO: Handle network errors
            print(error)
        }
    }
}
