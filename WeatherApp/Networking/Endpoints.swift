//
//  Endpoints.swift
//  WeatherApp
//
//  Created by Elliott D'Alvarez on 08/12/2022.
//

import Foundation
import CoreLocation

/// Contains all endpoints related to the app, can be further split to handle different API's

// MARK: Enums
enum Endpoints {
    case getDaily(location: CLLocation)
    case getWeekly(location: CLLocation)
}

// MARK: Available methods
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

// MARK: Endpoint case handling
extension Endpoints {
    // Allow support for different http methods
    var httpMethod: HTTPMethod {
        switch self {
        case .getDaily,
            .getWeekly:
            return .get
        }
    }

    // Setup the paths per endpoint
    var path: String {
        switch self {
        case .getDaily(let location):
            return "weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(API.apiKey)"
        case .getWeekly(let location):
            return "forecast?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(API.apiKey)"
        }
    }

    // Allow custom headers
    var headers: [String: Any]? {
        switch self {
        case .getDaily,
            .getWeekly:
            return ["Content-Type": "application/json"]
        }
    }

    // Form the url
    var url: String {
        return API.baseUrl + path
    }
}
