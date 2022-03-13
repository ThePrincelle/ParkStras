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
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(network)
        }
    }
}
