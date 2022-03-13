//
//  MapView.swift
//  ParkStras (iOS)
//
//  Created by Maxime Princelle on 13/03/2022.
//

import SwiftUI
import MapKit

struct MapView: View {
    var parkings: [Parking] = []
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 48.5734053,
            longitude: 7.7521113
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.095,
            longitudeDelta: 0.095
        )
    )

    var body: some View {
        Map(
            coordinateRegion: $region,
            annotationItems: parkings,
            annotationContent: { parking in
                MapMarker(
                    coordinate: CLLocationCoordinate2D(
                        latitude: parking.position.lat, longitude: parking.position.lng
                    ), tint: .blue)
            }
        )
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.top/*@END_MENU_TOKEN@*/)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(parkings: [Parking()])
    }
}
