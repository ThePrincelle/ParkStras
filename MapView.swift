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
    var position: Position?
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 48.5734053,
            longitude: 7.7521113
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.090,
            longitudeDelta: 0.090
        )
    )

    var body: some View {
        NavigationView {
            Map(
                coordinateRegion: $region,
                showsUserLocation: true,
                annotationItems: parkings,
                annotationContent: { parking in
                    MapAnnotation(
                        coordinate: parking.position.getCLLocationCoordinate2D(),
                        anchorPoint: CGPoint(x: 0.5, y: 0.7)
                    ) {
                        NavigationLink(destination: ParkingView(parking: parking)) {
                            if parking.occupation != nil {
                                ProgressBar(progress: (parking.occupation?.percentage ?? 0) / 100, showText: false).frame(width: 25, height: 25).padding(.trailing, 5.0)
                            } else {
                                VStack(spacing: 0) {
                                    ZStack {
                                        Circle().foregroundColor(.white).shadow(radius: 5)
                                        Image(systemName: "mappin.circle.fill")
                                            .font(.title)
                                            .scaledToFit()
                                            .foregroundColor(.teal)
                                    }
                                    
                                    Image(systemName: "arrowtriangle.down.fill")
                                        .font(.caption)
                                        .foregroundColor(.teal)
                                        .offset(x: 0, y: -5)
                                }
                            }
                        }
                    }
                }
            )
            .edgesIgnoringSafeArea(.top)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(parkings: [Parking.init()])
    }
}
