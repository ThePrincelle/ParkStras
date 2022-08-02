//
//  Network.swift
//  ParkStras (iOS)
//
//  Created by Maxime Princelle on 13/03/2022.
//

import Foundation
import SwiftUI

class Network: ObservableObject {
    @Published var parkings: [Parking] = []
    @Published var allParkings: [Parking] = []
    @Published var loading = false
    
    let preferences = UserDefaults.standard
    let searchRadiusKey = "radius"
    
    func getRadius() -> Double {
        if preferences.object(forKey: searchRadiusKey) != nil {
            return preferences.double(forKey: searchRadiusKey)
        } else {
            return Constants.DEFAULT_RADIUS
        }
    }
    
    func buildUrl(scheme: String, host: String, path: String = "/", lat: Double? = nil, lng: Double? = nil, withRadius: Bool = false) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = []
    
        if withRadius {
            urlComponents.queryItems?.append(URLQueryItem(name: "radius", value: getRadius().description))
        }
        
        if lat != nil && lng != nil {
            urlComponents.queryItems?.append(URLQueryItem(name: "lat", value: lat?.description))
            urlComponents.queryItems?.append(URLQueryItem(name: "lng", value: lng?.description))
        }
        
        return urlComponents
    }
    
    func getParkings(position: Position? = nil) {
        loading = true
        var urlComponent = buildUrl(scheme: "https", host: "parkstras.princelle.org", path: "/api/fetch_parkings.php")
        if position != nil {
            urlComponent = buildUrl(scheme: "https", host: "parkstras.princelle.org", path: "/api/fetch_parkings.php", lat: position?.lat, lng: position?.lng, withRadius: true)
        }
        
        fetchApi(url: urlComponent, updateAllParkings: false)
    }
    
    func getAllParkings() {
        let urlComponent = buildUrl(scheme: "https", host: "parkstras.princelle.org", path: "/api/fetch_all_parkings.php")
        fetchApi(url: urlComponent, updateAllParkings: true)
    }
    
    func fetchApi(url: URLComponents, updateAllParkings: Bool = false) {
        let urlRequest = URLRequest(url: url.url!)
        

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedParkings = try JSONDecoder().decode([Parking].self, from: data)
                        
                        if (updateAllParkings) {
                            self.allParkings = decodedParkings
                        } else {
                            self.parkings = decodedParkings
                        }
                        
                        self.loading = false
                        
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }

        dataTask.resume()
    }
}
