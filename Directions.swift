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
    
    func getDirectionsInfos(parking: Parking, sourcePosition: Position?, returnAddressIfFailure: Bool = true) {
        if (sourcePosition != nil) {
            let request = MKDirections.Request()
            
            // Default to Strasbourg center
            request.source = MKMapItem(
                placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: sourcePosition?.lat ?? 48.5734053, longitude: sourcePosition?.lng ?? 7.7521113)))
            
            request.destination = MKMapItem(
                placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: parking.position.lat, longitude: parking.position.lng)))
            
            //request.transportType = MKDirectionsTransportType.automobile
            //request.requestsAlternateRoutes = true
            
            let directions = MKDirections(request: request)
            
            directions.calculate { response, error in
                if let response = response, let route = response.routes.first {
                    
                    var distanceCar: Measurement<UnitLength>? = nil
                    var etaCar: String? = nil
                    
                    var distanceWalking: Measurement<UnitLength>? = nil
                    var etaWalking: String? = nil
                    
                    response.routes.forEach { item in
                        if item.transportType == .walking && item.distance < 3500 && distanceWalking == nil && etaWalking == nil {
                            //print("WALKING!")
                            distanceWalking = Measurement(value: route.distance, unit: UnitLength.meters)
                            etaWalking = "\(String(format: "%.0f", round(route.expectedTravelTime / 60))) min"
                        }
                        
                        if item.transportType == .automobile && distanceCar == nil && etaCar == nil {
                            //print("DRIVING!")
                            distanceCar = Measurement(value: route.distance, unit: UnitLength.meters)
                            etaCar = "\(String(format: "%.0f", round(route.expectedTravelTime / 60))) min"
                        }
                    }
                    
                    self.directionsInfos = self.formatDistancesAndEtas(distanceWalking: distanceWalking, etaWalking: etaWalking, distanceCar: distanceCar, etaCar: etaCar)
                    
                    if error != nil && returnAddressIfFailure {
                        self.directionsInfos = parking.getFormattedAddress()
                    }
                }
            }
        } else {
            if (returnAddressIfFailure) {
                directionsInfos = parking.getFormattedAddress()
            }
        }
    }
    
    func formatDistancesAndEtas(distanceWalking: Measurement<UnitLength>?, etaWalking: String?, distanceCar: Measurement<UnitLength>?, etaCar: String?) -> String {
        var walking: String? = nil
        if (distanceWalking != nil && etaWalking != nil) {
            walking = "🚶‍♂️ \(distanceWalking?.formatted() ?? "") • \(etaWalking!)"
        }
        
        var car: String? = nil
        if (distanceCar != nil && etaCar != nil) {
            car = "🚙 \(distanceCar?.formatted() ?? "") • \(etaCar!)"
        }
        
        if car != nil && walking != nil {
            return "\(car!)\n\(walking!)"
        }
        
        if car != nil && walking == nil {
            return "\(car!)"
        }
        
        if car == nil && walking != nil {
            return "\(walking!)"
        }
        
        return ""
    }
}
