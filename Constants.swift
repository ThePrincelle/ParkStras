//
//  Constants.swift
//  ParkStras
//
//  Created by Maxime Princelle on 01/08/2022.
//

import Foundation

struct Constants {
    static let DEFAULT_RADIUS: Double = 500 // meters
    static let RADIUS_SLIDER: RadiusSliderConf = RadiusSliderConf(range: 500...40000, step: 150)
}

struct RadiusSliderConf {
    var RANGE: ClosedRange<Double>
    var STEP: Double
    
    init(range: ClosedRange<Double>, step: Double) {
        self.RANGE = range
        self.STEP = step
    }
}
