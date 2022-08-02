//
//  ContentView.swift
//  Shared
//
//  Created by Maxime Princelle on 12/03/2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var network: Network
    
    @StateObject var locationManager = LocationManager()

    var body: some View {
        TabView {
            ParkingList(parkings: network.parkings, network: network, locationManager: locationManager, loading: network.loading)
                //.padding(.top, 5)
                .onAppear {
                    locationManager.setNetwork(network: network)
                    locationManager.updateLocationAndParkings()
                    // network.getParkings()
                    network.getAllParkings()
                }
                .tabItem {
                    Image(systemName: "list.bullet.circle")
                    Text("Liste")
                }
            
            MapView(parkings: network.allParkings, position: locationManager.lastUserPosition)
                .onAppear {
                    network.getAllParkings()
                }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Network())
    }
}
