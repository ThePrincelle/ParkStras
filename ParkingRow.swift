//
//  ParkingRow.swift
//  ParkStras (iOS)
//
//  Created by Maxime Princelle on 13/03/2022.
//

import SwiftUI

struct ParkingRow: View {
    var parking: Parking;
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(parking.name)")
                    .font(.headline)
                    .fontWeight(.medium)
                Text("\(parking.address)")
                    .font(.subheadline)
                    .fontWeight(.light)
                
            }
            
            Spacer()
            
            ProgressBar(progress: (parking.occupation?.percentage ?? 0) / 100).frame(width: 40.0, height: 40.0).padding(.trailing, 5.0)
        }
        .accentColor(Color.primary)
        .padding(.vertical, 3.0)
    }
}

struct ParkingRow_Previews: PreviewProvider {
    static var previews: some View {
        ParkingRow(parking: Parking())
    }
}
