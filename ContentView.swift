//
//  ContentView.swift
//  Shared
//
//  Created by Maxime Princelle on 12/03/2022.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @EnvironmentObject var network: Network
    
    var body: some View {
        TabView {
            ParkingList(parkings: network.parkings)
            .onAppear {
                network.getParkings()
            }
            .tabItem {
                Image(systemName: "list.bullet.circle")
                Text("Liste")
            }
            
            MapView(parkings: network.parkings)
            .onAppear {
                network.getParkings()
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
