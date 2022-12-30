//
//  LocationView.swift
//  WeatherApp
//
//  Created by Elliott D'Alvarez on 08/12/2022.
//

import SwiftUI
import CoreLocation

// MARK: Helper view for all things location handling
struct LocationView: View {
    // Takes a passed in location view model so this can be centralised
    var locationViewModel: LocationViewModel

    var body: some View {
        if locationViewModel.showSettingsButton {
            VStack(spacing: 10) {
                Text("Please enable location in your settings to use this application")
                    .multilineTextAlignment(.center)
                    .padding()
                Button("Settings") {
                    locationViewModel.navigateToSettings()
                }
            }
        } else {
            Button("Refresh location status") {
                locationViewModel.checkLocationAuthorization()
            }
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(locationViewModel: LocationViewModel(locationManager: CLLocationManager()))
    }
}
