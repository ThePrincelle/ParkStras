//
//  ParkingList.swift
//  ParkStras (iOS)
//
//  Created by Maxime Princelle on 13/03/2022.
//

import SwiftUI

struct ParkingList: View {
    var parkings: [Parking]
    
    var body: some View {
        NavigationView {
            List(parkings) { parking in
                NavigationLink {
                    ParkingView(parking: parking)
                } label: {
                    ParkingRow(parking: parking)
                }
            }
            .navigationBarTitle("ParkStras")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ParkingList_Previews: PreviewProvider {
    static var previews: some View {
        ParkingList(parkings: [Parking(), Parking(), Parking()])
    }
}
