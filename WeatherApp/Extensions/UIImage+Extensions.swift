//
//  UIImage+Extensions.swift
//  WeatherApp
//
//  Created by Elliott D'Alvarez on 30/12/2022.
//

import UIKit

extension UIImage {
    static func getWeatherIcon(name: String, completion: @escaping (UIImage?) -> Void) {
        let endpoint = Endpoints.getIcon(name: name)
        guard let url = endpoint.url else {
            return completion(nil)
        }

        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            guard let data = data else {
                return completion(nil)
            }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }
        })
    }
}
