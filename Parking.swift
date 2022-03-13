//
//  Parking.swift
//  ParkStras (iOS)
//
//  Created by Maxime Princelle on 13/03/2022.
//

import Foundation

// MARK: - Parking
struct Parking: Decodable, Identifiable {
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
        self.address = "TEST ADDRESS"
        self.description = "DESCRIPTION TEMPLATE"
        self.occupation = Occupation(available: 25, total: 250, occupied: 225, percentage: 90.00)
        self.position = Position(lat: 48.12345, lng: 7.12345)
        self.url = "https://google.com"
        self.etat = 1
    }
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
struct Position: Decodable {
    var lat, lng: Double
    
    init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
}

