//
//  ParkingList.swift
//  ParkStras (iOS)
//
//  Created by Maxime Princelle on 13/03/2022.
//

import SwiftUI

struct ParkingList: View {
    var parkings: [Parking]
    var network: Network?
    var position: Position?
    var locationManager: LocationManager?
    var loading: Bool = false
    
    @State var manualPosition: Position? = nil
    @State var manualPlaceName: String = ""
    
    @StateObject private var navigate: Navigate = Navigate()
    
    @StateObject private var vm = SearchResultsViewModel()
    
    var body: some View {
        NavigationView {
            if (loading || (parkings.isEmpty && vm.searchText == "")) {
                VStack(alignment: .center, spacing: 0) {
                    Text("👀").padding(.bottom, 1.8).font(.largeTitle)
                    Text("Chargement en cours...").font(Font.caption).fontWeight(.bold).multilineTextAlignment(.center).padding(.bottom, 0.3)
                    Text("Nous cherchons les parkings autour de \(vm.searchText == "" ? "votre position" : "l'emplacement que vous avez sélectionné").").font(Font.caption2).padding(.horizontal, 5.0).frame(maxWidth: 365, alignment: .center).multilineTextAlignment(.center)
                }
            } else {
                VStack {
                    if (vm.places.count > 0) {
                        List(vm.places) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("**\(item.name)**").font(.caption)
                                    Text("\(item.address), \(item.city)").font(.caption2)
                                }
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                manualPosition = item.position
                                manualPlaceName = item.displayName
                                network?.getParkings(position: manualPosition)
                                vm.places = []
                            }
                        }
                    } else {
                        List(parkings) {parking in
                            NavigationLink {
                                ParkingView(parking: parking)
                            } label: {
                                ParkingRow(parking: parking, locationManager: locationManager)
                            }.swipeActions(allowsFullSwipe: false) {
                                Button {
                                    navigate.navigateToParking(parking: parking)
                                } label: {
                                    Label("Naviguer", systemImage: "arrow.triangle.turn.up.right.circle.fill")
                                }
                                .tint(.blue)
                            }.confirmationDialog("Naviguer vers : \(navigate.selectedParking?.name ?? "") ?", isPresented: $navigate.showNavigationOptions, titleVisibility: .visible) {
                                Button("Utiliser Apple Maps") {
                                    navigate.goToAppleMaps()
                                }
                                if (navigate.hasGoogleMaps()) {
                                    Button("Utiliser Google Maps") {
                                        navigate.goToGoogleMaps()
                                    }
                                }
                                if (navigate.hasWaze()) {
                                    Button("Utiliser Waze") {
                                        navigate.goToWaze()
                                    }
                                }
                            }.alert("L'adresse : \(navigate.selectedParking?.address ?? "") est invalide.", isPresented: $navigate.showInvalidAddress) {
                                Button("OK", role: .cancel) { }
                            }
                        }
                        .navigationBarTitle(manualPlaceName == "" ? "ParkStras" : "Recherche pour : \(manualPlaceName)")
                        .navigationBarTitleDisplayMode(manualPlaceName == "" ? .large : .inline)
                        .toolbar {
                            ToolbarItemGroup(placement: .navigationBarTrailing) {
                                Button(action: {
                                    if (manualPosition != nil) {
                                        network?.getParkings(position: manualPosition)
                                    } else {
                                        locationManager?.updateLocationAndParkings()
                                        manualPosition = nil
                                        manualPlaceName = ""
                                        vm.searchText = ""
                                    }
                                }) {
                                    Image(systemName: "arrow.clockwise.circle.fill").font(.title3)
                                }
                                
                                if (manualPosition != nil) {
                                    Button(action: {
                                        locationManager?.updateLocationAndParkings()
                                        manualPosition = nil
                                        manualPlaceName = ""
                                        vm.searchText = ""
                                    }) {
                                        Image(systemName: "location.circle.fill").font(.title3)
                                    }
                                }
                            }
                        }
                        .refreshable {
                            if (manualPosition != nil) {
                                network?.getParkings(position: manualPosition)
                            } else {
                                locationManager?.updateLocationAndParkings()
                                manualPosition = nil
                                manualPlaceName = ""
                                vm.searchText = ""
                            }
                        }
                        
                        if parkings.count <= 4 {
                            VStack(alignment: .center, spacing: 0) {
                                if parkings.count <= 4 && parkings.count > 0 {
                                    Text("🤔").padding(.bottom, 1.8).font(.largeTitle)
                                    Text("Peu de parkings sont référencés autour de vous...").font(Font.caption).fontWeight(.bold).multilineTextAlignment(.center).padding(.bottom, 0.3)
                                    Text("Essayez d'élargir votre périmètre de recherche dans les préférences de l'application.").font(Font.caption2).padding(.horizontal, 5.0).frame(maxWidth: 365, alignment: .center).multilineTextAlignment(.center)
                                }
                                
                                if (parkings.count == 0) {
                                    Text("🧐").padding(.bottom, 1.8).font(.largeTitle)
                                    Text("Aucun parking n'est référencé autour de vous....").font(Font.caption).fontWeight(.bold).multilineTextAlignment(.center).padding(.bottom, 0.3)
                                    Text("Essayez d'élargir votre périmètre de recherche dans les préférences de l'application.").font(Font.caption2).padding(.horizontal, 5.0).frame(maxWidth: 365, alignment: .center).multilineTextAlignment(.center)
                                }
                            }.padding(.bottom, 24.0)
                        }
                    }
                }
                .transition(.opacity)
                .searchable(text: $vm.searchText, prompt: "Rechercher autour d'un lieu")
            }
        }
    }
}

struct ParkingList_Previews: PreviewProvider {
    static var previews: some View {
        // Lots of parkings
        ParkingList(parkings: [Parking.init(etat: 0), Parking(), Parking(), Parking.init(etat: 0), Parking(), Parking()])
        
        // Not a lot of parkings
        ParkingList(parkings: [Parking.init(etat: 0), Parking(), Parking()])
        
        // No parkings
        ParkingList(parkings: [])
    }
}
