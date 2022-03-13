//
//  ParkingView.swift
//  ParkStras (iOS)
//
//  Created by Maxime Princelle on 13/03/2022.
//

import SwiftUI

struct ParkingView: View {
    var parking: Parking
    
    var body: some View {
        Text(parking.name)
    }
}
