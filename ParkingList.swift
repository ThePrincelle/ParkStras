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
    
    @State var showNavigationOptions: Bool = false
    @State var showInvalidAddress: Bool = false
    @State var selectedParking: Parking? = nil
    
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
    
    func goToAppleMaps(parking: Parking?) {
        print("Go to Apple Maps")
        let url = buildUrl(scheme: "https", host: "maps.apple.com", query: ((parking?.name ?? "") + " " + (parking?.address ?? ""))).url
        if url != nil {
            UIApplication.shared.open(url!)
        } else {
            selectedParking = parking
            showInvalidAddress = true
        }
    }
    
    func hasGoogleMaps() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://?q=cupertino")!)
    }
    
    func goToGoogleMaps(parking: Parking?) {
        print("Go to Google Maps")
        let url = buildUrl(scheme: "comgooglemaps", host: "", path: "", query: ((parking?.name ?? "") + " " + (parking?.address ?? ""))).url
        if url != nil {
            UIApplication.shared.open(url!)
        } else {
            selectedParking = parking
            showInvalidAddress = true
        }
    }
    
    var body: some View {
        NavigationView {
            if (loading) {
                VStack(alignment: .center, spacing: 0) {
                    Text("👀").padding(.bottom, 1.8).font(.largeTitle)
                    Text("Chargement en cours....").font(Font.caption).fontWeight(.bold).multilineTextAlignment(.center).padding(.bottom, 0.3)
                    Text("Nous cherchons les parkings autour de votre position.").font(Font.caption2).padding(.horizontal, 5.0).frame(maxWidth: 365, alignment: .center).multilineTextAlignment(.center)
                }
            } else {
                VStack {
                    List(parkings) {parking in
                        NavigationLink {
                            ParkingView(parking: parking)
                        } label: {
                            ParkingRow(parking: parking)
                        }.swipeActions(allowsFullSwipe: false) {
                            Button {
                                navigateToParking(parking: parking)
                            } label: {
                                Label("Naviguer", systemImage: "arrow.triangle.turn.up.right.circle.fill")
                            }
                            .tint(.blue)
                        }.confirmationDialog("Naviguer vers : \(selectedParking?.name ?? "") ?", isPresented: $showNavigationOptions, titleVisibility: .visible) {
                            Button("Utiliser Apple Maps") {
                                goToAppleMaps(parking: selectedParking)
                            }
                            if (hasGoogleMaps()) {
                                Button("Utiliser Google Maps") {
                                    goToGoogleMaps(parking: selectedParking)
                                }
                            }
                        }.alert("L'adresse : \(selectedParking?.address ?? "") est invalide.", isPresented: $showInvalidAddress) {
                            Button("OK", role: .cancel) { }
                        }
                    }
                    .navigationBarTitle("ParkStras")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                locationManager?.updateLocationAndParkings()
                                //network?.getParkings()
                            }) {
                                HStack(alignment: .center, spacing: 4) {
                                    Image(systemName: "arrow.clockwise.circle.fill").font(.title3)
                                    Text("Rafraîchir")
                                }
                            }
                        }
                    }
                    
                    .refreshable {
                        locationManager?.updateLocationAndParkings()
                        //network?.getParkings()
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
                }.transition(.opacity)
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
