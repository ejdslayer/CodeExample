//
//  WeatherApp.swift
//  WeatherApp
//
//  Created by Elliott D'Alvarez on 08/12/2022.
//

import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherView()
                .background(Color.appColors.lightBlue)
        }
    }
}
