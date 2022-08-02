//
//  ParkingRow.swift
//  ParkStras (iOS)
//
//  Created by Maxime Princelle on 13/03/2022.
//

import SwiftUI

struct ParkingRow: View {
    var parking: Parking
    var locationManager: LocationManager?
    
    @StateObject var directions: Directions = Directions()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("**\(parking.name)**")
                    .font(.headline)
                    .padding(.bottom, 0.1)
                
                if (locationManager != nil && locationManager?.lastUserPosition != nil) {
                    Text(directions.directionsInfos != "" ? directions.directionsInfos : parking.getFormattedAddress())
                        .font(.subheadline).onAppear {
                            directions.getDirectionsInfos(parking: parking, lastUserPosition: locationManager?.lastUserPosition)
                        }
                } else {
                    Text("\(parking.getFormattedAddress())")
                        .font(.subheadline)
                }
            }
            
            Spacer()
            
            switch (parking.getEtat()) {
                case Etat.OPEN:
                    if parking.occupation != nil {
                        ProgressBar(progress: (parking.occupation?.percentage ?? 0) / 100, showText: true).frame(width: 40.0, height: 40.0).padding(.trailing, 5.0)
                    } else {
                        EtatComponent(etat: Etat.OPEN, withText: false).font(.largeTitle).padding(.trailing, 6.0)
                    }
                case Etat.CLOSED:
                    EtatComponent(etat: Etat.CLOSED, withText: false).font(.largeTitle).padding(.trailing, 6.0)
                case Etat.FULL:
                    if parking.occupation != nil {
                        ProgressBar(progress: (parking.occupation?.percentage ?? 0) / 100, showText: true).frame(width: 40.0, height: 40.0).padding(.trailing, 5.0)
                    } else {
                        EtatComponent(etat: Etat.FULL, withText: false).font(.largeTitle).padding(.trailing, 6.0)
                    }
                case Etat.UNKNOWN:
                    EtatComponent(etat: Etat.UNKNOWN, withText: false).font(.largeTitle).padding(.trailing, 6.0)
            }
        }
        .accentColor(Color.primary)
        .padding(.vertical, 3.0)
    }
}

struct ParkingRow_Previews: PreviewProvider {
    static var previews: some View {
        ParkingRow(parking: Parking.init(etat: 0))
        ParkingRow(parking: Parking.init(etat: 1))
        ParkingRow(parking: Parking.init(etat: 2))
        ParkingRow(parking: Parking.init(etat: 3))
    }
}
