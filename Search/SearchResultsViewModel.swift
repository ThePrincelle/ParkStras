//
//  SearchResultsViewModel.swift
//  ParkStras
//
//  Created by Maxime Princelle on 02/08/2022.
//

import Foundation
import MapKit
import Combine

@MainActor
class SearchResultsViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    var cancellable: AnyCancellable?
    
    init() {
        cancellable = $searchText.debounce(for: .seconds(0.25), scheduler: DispatchQueue.main)
            .sink { value in
                if !value.isEmpty && value.count > 3 {
                    self.search(text: value, region: Constants.REGIONS["strasbourg"]!)
                } else {
                    self.places = []
                }
            }
    }
    
    @Published var places = [PlaceViewModel]()
    
    func search(text: String, region: MKCoordinateRegion) {
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        searchRequest.region = region
        
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.places = response.mapItems.map(PlaceViewModel.init)
        }
    }
}

struct PlaceViewModel: Identifiable {
    
    let id = UUID()
    private var mapItem: MKMapItem
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
    }
    
    var position: Position {
        Position.init(lat: mapItem.placemark.coordinate.latitude, lng: mapItem.placemark.coordinate.longitude)
    }
    
    var address: String {
        mapItem.placemark.thoroughfare ?? ""
    }
    
    var city: String {
        mapItem.placemark.locality ?? ""
    }
    
    var name: String {
        mapItem.name ?? ""
    }
    
    var displayName: String {
        (mapItem.name ?? "") + " (" + (mapItem.placemark.thoroughfare ?? "") + ")"
    }
}
