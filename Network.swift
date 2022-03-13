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
    
    func getParkings() {
        guard let url = URL(string: "https://parkstras.princelle.org/api/fetch_parkings.php") else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)

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
                        self.parkings = decodedParkings
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }

        dataTask.resume()
    }
}
