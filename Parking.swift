//
//  Parking.swift
//  ParkStras (iOS)
//
//  Created by Maxime Princelle on 13/03/2022.
//

import Foundation
import MapKit

// MARK: - Parking
struct Parking: Decodable, Identifiable, Equatable {
    var id, name, address: String
    var position: Position
    var description: String?
    var url: String
    var occupation: Occupation?
    var etat: Int?
    var updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, address, position, description
        case url, occupation, etat
        case updatedAt = "updated_at"
    }
    
    init(name: String, address: String, description: String, position: Position) {
        self.id = UUID().uuidString
        self.name = name
        self.address = address
        self.description = description
        self.position = position
        self.url = ""
        self.etat = 1
    }
    
    init() {
        self.id = UUID().uuidString
        self.name = "Parking TEST"
        self.address = "10 Rue de Dornach 67100 Strasbourg France"
        self.description = "DESCRIPTION TEMPLATE"
        self.occupation = Occupation(available: 25, total: 250, occupied: 225, percentage: 90.00)
        self.position = Position(lat: 48.5734053, lng: 7.7521113)
        self.url = "https://google.com"
        self.etat = 1
    }
    
    init(etat: Int) {
        self.id = UUID().uuidString
        self.name = "Parking TEST"
        self.address = "10 Rue de Dornach 67100 Strasbourg France"
        self.description = "DESCRIPTION TEMPLATE"
        self.occupation = Occupation(available: 25, total: 250, occupied: 225, percentage: 90.00)
        self.position = Position(lat: 48.5734053, lng: 7.7521113)
        self.url = "https://google.com"
        self.etat = etat
    }
    
    func getEtat() -> Etat {
        /*
         0 : fréquentation temps réel indisponible
         1 : ouvert
         2 : fermé
         3 : complet
         */
        
        switch (self.etat) {
        case 0:
            if (self.occupation?.available == 0) {
                return Etat.FULL
            }
            return Etat.UNKNOWN
        case 1:
            return Etat.OPEN
        case 2:
            return Etat.CLOSED
        case 3:
            return Etat.FULL
        default:
            return Etat.UNKNOWN
        }
    }
    
    static func == (lhs: Parking, rhs: Parking) -> Bool {
        return lhs.id == rhs.id && lhs.position == rhs.position && lhs.name == lhs.name
    }
    
    func getFormattedAddress() -> String {
        return self.address.components(separatedBy: "67").joined(separator: "\n67")
    }
}

enum Etat {
    case UNKNOWN
    case OPEN
    case CLOSED
    case FULL
}

// MARK: - Occupation
struct Occupation: Decodable {
    var available, total, occupied: Int
    var percentage: Double
    
    init(available: Int, total: Int, occupied: Int, percentage: Double) {
        self.available = available
        self.total = total
        self.occupied = occupied
        self.percentage = percentage
    }
}

// MARK: - Position
struct Position: Decodable, Equatable {
    var lat, lng: Double
    var adresse: String?
    
    init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
    
    func getCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng);
    }
    
    func getRegion() -> MKCoordinateRegion {
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: self.lat,
                longitude: self.lng
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 0.0035,
                longitudeDelta: 0.0035
            )
        )
    }
    
    static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.lat == rhs.lat && lhs.lng == rhs.lng
    }
}

