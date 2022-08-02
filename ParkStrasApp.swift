//
//  ParkStrasApp.swift
//  Shared
//
//  Created by Maxime Princelle on 12/03/2022.
//

import SwiftUI

@main
struct ParkStrasApp: App {
    var network = Network()
    
    @StateObject var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView(locationManager: locationManager).environmentObject(network).onAppear {
                locationManager.setNetwork(network: network)
                locationManager.updateLocationAndParkings()
                // network.getParkings()
                network.getAllParkings()
            }
        }
    }
}
