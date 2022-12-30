//
//  NetworkErrors.swift
//  WeatherApp
//
//  Created by Elliott D'Alvarez on 08/12/2022.
//

import Foundation

/// All network error cases
public enum NetworkErrors: Error {
    case invalidData
    case invalidUrl
}
