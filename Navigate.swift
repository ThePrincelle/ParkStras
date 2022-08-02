//
//  Navigate.swift
//  ParkStras
//
//  Created by Maxime Princelle on 02/08/2022.
//

import Foundation
import SwiftUI

class Navigate: ObservableObject {
    @Published var selectedParking: Parking? = nil
    @Published var showNavigationOptions: Bool = false
    @Published var showInvalidAddress: Bool = false
    
    func navigateToParking(parking: Parking) {
        print("Navigate to Parking")
        print(parking.address)
        selectedParking = parking
        showNavigationOptions = true
    }
    
    func buildUrl(scheme: String, host: String, path: String = "/", query: String) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [URLQueryItem(name: "q", value: query)]
        return urlComponents
    }
    
    func goToAppleMaps() {
        print("Go to Apple Maps")
        let url = buildUrl(scheme: "https", host: "maps.apple.com", query: ((selectedParking?.name ?? "") + " " + (selectedParking?.address ?? ""))).url
        if url != nil {
            UIApplication.shared.open(url!)
        } else {
            showInvalidAddress = true
        }
    }
    
    func hasGoogleMaps() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://?q=cupertino")!)
    }
    
    func goToGoogleMaps() {
        print("Go to Google Maps")
        let url = buildUrl(scheme: "comgooglemaps", host: "", path: "", query: ((selectedParking?.name ?? "") + " " + (selectedParking?.address ?? ""))).url
        if url != nil {
            UIApplication.shared.open(url!)
        } else {
            showInvalidAddress = true
        }
    }
    
    func hasWaze() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "waze://")!)
    }
    
    func goToWaze() {
        print("Go to Waze")
        let url = buildUrl(scheme: "waze", host: "", path: "", query: ((selectedParking?.name ?? "") + " " + (selectedParking?.address ?? ""))).url
        if url != nil {
            UIApplication.shared.open(url!)
        } else {
            showInvalidAddress = true
        }
    }
}
