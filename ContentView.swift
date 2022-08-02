//
//  ContentView.swift
//  Shared
//
//  Created by Maxime Princelle on 12/03/2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var network: Network
    var locationManager: LocationManager

    var body: some View {
        TabView {
            ParkingList(parkings: network.parkings, network: network, locationManager: locationManager, loading: network.loading)
                .tabItem {
                    Image(systemName: "list.bullet.circle")
                    Text("Liste")
                }
            
            MapView(parkings: network.allParkings, position: locationManager.lastUserPosition)
                .tabItem {
                    Image(systemName: "map.circle")
                    Text("Carte")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Préférences")
                }
        }
    }
    
}

