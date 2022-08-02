//
//  Directions.swift
//  ParkStras
//
//  Created by Maxime Princelle on 02/08/2022.
//

import Foundation
import MapKit

class Directions: ObservableObject {
    @Published var directionsInfos: String = ""
    
    func getDirectionsInfos(parking: Parking, lastUserPosition: Position?) {
        if (lastUserPosition != nil) {
            directionsInfos = "🚙 Calcul en cours..."
            let request = MKDirections.Request()
            
            // Default to Strasbourg center
            request.source = MKMapItem(
                placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lastUserPosition?.lat ?? 48.5734053, longitude: lastUserPosition?.lng ?? 7.7521113)))
            
            request.destination = MKMapItem(
                placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: parking.position.lat, longitude: parking.position.lng)))
            
            request.transportType = MKDirectionsTransportType.automobile
            request.requestsAlternateRoutes = false
            
            let directions = MKDirections(request: request)
            var res = ""
            directions.calculate { response, error in
                if let route = response?.routes.first {
                    let distance = Measurement(value: route.distance, unit: UnitLength.meters).formatted()
                    let eta = Measurement(value: route.expectedTravelTime, unit: UnitDuration.seconds).formatted()
                    res = "\(distance)\n🚙 \(eta)"
                } else {
                    res = "Unable to calculate ETA"
                }
            }
            if (res != "") {
                directionsInfos = res
            }
        }
        
        directionsInfos = parking.getFormattedAddress()
    }
}
