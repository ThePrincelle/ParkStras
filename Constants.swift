//
//  Constants.swift
//  ParkStras
//
//  Created by Maxime Princelle on 01/08/2022.
//

import Foundation
import MapKit

struct Constants {
    static let DEFAULT_RADIUS: Double = 5000 // meters
    static let RADIUS_SLIDER: RadiusSliderConf = RadiusSliderConf(range: 500...40000, step: 150)
    static let REGIONS: [String: MKCoordinateRegion] = [
        "strasbourg": MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 48.5734053,
                longitude: 7.7521113
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 0.090,
                longitudeDelta: 0.090
            )
        )
    ]
}

struct RadiusSliderConf {
    var RANGE: ClosedRange<Double>
    var STEP: Double
    
    init(range: ClosedRange<Double>, step: Double) {
        self.RANGE = range
        self.STEP = step
    }
}
