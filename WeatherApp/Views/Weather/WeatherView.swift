//
//  ContentView.swift
//  WeatherApp
//
//  Created by Elliott D'Alvarez on 08/12/2022.
//

import SwiftUI
import CoreLocation

/// Our main weather view
struct WeatherView: View {
    // MARK: State objects
    @StateObject private var weatherViewModel = WeatherViewModel(service: WeatherService())
    @StateObject var locationViewModel: LocationViewModel = LocationViewModel(locationManager: CLLocationManager())
    
    // MARK: Constants
    enum Constants {
        static let scrollViewPadding: CGFloat = 10
        static let atmosphericSpacing: CGFloat = 5
        static let dailyWeatherViewSize: CGSize = .init(width: 120, height: 160)
        static let weeklyWeatherViewSize: CGSize = .init(width: 60, height: 80)
    }
    
    // MARK: Main body
    var body: some View {
        ScrollView {
            if locationViewModel.showLocationAuthView {
                LocationView(locationViewModel: locationViewModel)
            } else {
                weatherView()
            }
        }
        .background(.clear)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding([.leading, .trailing], Constants.scrollViewPadding)
        .onAppear {
            locationViewModel.checkIfLocationPermissionsAvailable()
        }
        .task {
            await weatherViewModel.fetchTodaysForecast(location: locationViewModel.getLocation())
        }.task {
            await weatherViewModel.fetchWeeklyForecast(location: locationViewModel.getLocation())
        }
    }
    
    // MARK: Subviews
    @ViewBuilder func weatherView() -> some View {
        if let daily = weatherViewModel.dailyForecast {
            dailyForecastView(dailyForecast: daily)
        }
        if let weekly = weatherViewModel.weeklyForecast {
            weeklyForecastView(forecast: weekly)
        }
        if let atmospherics = weatherViewModel.dailyForecast?.atmospherics {
            atmosphericsView(atmospherics: atmospherics)
        }
    }

    @ViewBuilder func dailyForecastView(dailyForecast: DailyForecast) -> some View {
        HStack {
            if let weather = dailyForecast.weather.first {
                Spacer()
                weatherView(weather: weather)
                    .frame(width: Constants.dailyWeatherViewSize.width,
                           height: Constants.dailyWeatherViewSize.height)
                Spacer()
            }
        }
    }
    
    @ViewBuilder func weatherView(weather: Weather, large: Bool = true) -> some View {
        VStack(alignment: .center, spacing: large ? 10 : 4) {
            Image(systemName: weather.icon)
                .renderingMode(.template)
                .foregroundColor(.white)
            
            Text(weather.main)
                .font(large ? .title : .system(size: 10, weight: .bold))
                .foregroundColor(.white)
            
            Text(weather.description).multilineTextAlignment(.center)
                .font(large ? .body : .system(size: 10, weight: .light))
                .lineLimit(large ? 0 : 2)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(large ? .clear : Color.appColors.darkBlue)
        .cornerRadius(5)
    }
    
    @ViewBuilder func weeklyForecastView(forecast: WeeklyForecast) -> some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(forecast.list) { dailyForecast in
                    if let weather = dailyForecast.weather.first {
                        weatherView(weather: weather, large: false)
                            .frame(width: Constants.weeklyWeatherViewSize.width,
                                   height: Constants.weeklyWeatherViewSize.height)
                    }
                }
            }
        }
    }
    
    @ViewBuilder func atmosphericsView(atmospherics: Atmospherics) -> some View {
        VStack(alignment: .leading, spacing: Constants.atmosphericSpacing) {
            Spacer().frame(height: Constants.atmosphericSpacing)
            atmosphericsCell(title: "Temperature", text: "\(atmospherics.temp)")
            atmosphericsCell(title: "Feels like", text: "\(atmospherics.feels_like)")
            atmosphericsCell(title: "Minimum temperature", text: "\(atmospherics.temp_min)")
            atmosphericsCell(title: "Maximum temperature", text: "\(atmospherics.temp_max)")
            atmosphericsCell(title: "Pressure", text: "\(atmospherics.pressure)")
            atmosphericsCell(title: "Humidity", text: "\(atmospherics.humidity)")
            Spacer().frame(height: Constants.atmosphericSpacing)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appColors.darkBlue)
        .cornerRadius(5)
    }
    
    @ViewBuilder func atmosphericsCell(title: String, text: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
            Spacer()
            Text(text)
                .font(.system(size: 12, weight: .light))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding([.horizontal], 10)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
