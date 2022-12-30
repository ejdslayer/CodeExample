//
//  LocationViewModel.swift
//  WeatherApp
//
//  Created by Elliott D'Alvarez on 08/12/2022.
//

import Foundation
import CoreLocation
import UIKit

protocol LocationViewModelProtocol: ObservableObject {
    func requestPermission()
    func getLocation() -> CLLocation?
    func navigateToSettings()
}

class LocationViewModel: NSObject, LocationViewModelProtocol, CLLocationManagerDelegate {
    @Published var showLocationAuthView = true
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var showSettingsButton = false
    @Published var lastLocation: CLLocation? = nil

    private var locationManager: CLLocationManager? = nil {
        didSet {
            locationManager?.delegate = self
            locationManager?.requestWhenInUseAuthorization()
        }
    }

    public init(locationManager: CLLocationManager) {
        super.init()
        defer {
            self.locationManager = locationManager
        }
    }

    func checkIfLocationPermissionsAvailable() {
        DispatchQueue.global(qos: .userInteractive).async {
            CLLocationManager.locationServicesEnabled()
        }
    }

    func checkLocationAuthorization() {
        switch locationManager?.authorizationStatus {
        case .notDetermined:
            requestPermission()
            showSettingsButton = false
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager?.startUpdatingLocation()
            authorizationStatus = .authorizedWhenInUse
            showLocationAuthView = false
            showSettingsButton = false
        default:
            authorizationStatus = locationManager?.authorizationStatus ?? .notDetermined
            showLocationAuthView = true
            showSettingsButton = true
        }
    }

    func requestPermission() {
        locationManager?.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last
    }

    func getLocation() -> CLLocation? {
        return locationManager?.location
    }

    func navigateToSettings() {
        guard let settingsUrl: URL = URL(string:UIApplication.openSettingsURLString) else {
            print("Couldn't find application settings url")
            return
        }
        UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
    }
}
