//
//  ParkingView.swift
//  ParkStras (iOS)
//
//  Created by Maxime Princelle on 13/03/2022.
//

import SwiftUI
import MapKit

struct ParkingView: View {
    var parking: Parking
    
    @StateObject private var navigate: Navigate = Navigate()
    
    @State private var region: MKCoordinateRegion = Constants.REGIONS["strasbourg"]!
    
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//
//    var backButton : some View { Button(action: {
//        self.presentationMode.wrappedValue.dismiss()
//        }) {
//            Image(systemName: "chevron.backward.circle")
//                .aspectRatio(contentMode: .fit)
//                .foregroundColor(.accentColor)
//        }
//    }
    
    var body: some View {
        ScrollView {
            // Etat
            GroupBox(label: Text("Etat")) {
                EtatComponent(etat: parking.getEtat(), withText: true).frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Parking Occupation (with ProgressBar)
            if (parking.occupation != nil) {
                GroupBox(label: Text("Occupation")) {
                    HStack {
                        VStack(alignment: .leading) {
                            if (parking.occupation?.available ?? 0 == 1) {
                                Text(String(format: "%d place libre", parking.occupation?.available ?? 0))
                             } else {
                                Text(String(format: "%d places libres", parking.occupation?.available ?? 0))
                            }
                            
                            if (parking.occupation?.occupied ?? 0 == 1) {
                                Text(String(format: "%d place occupée", parking.occupation?.occupied ?? 0))
                             } else {
                                Text(String(format: "%d places occupées", parking.occupation?.occupied ?? 0))
                            }
                            
                            Text(String(format: "Capacité: %d places", parking.occupation?.total ?? 0))
                        }
                        Spacer()
                        ProgressBar(progress: (parking.occupation?.percentage ?? 0) / 100, showText: true).frame(width: 55.0, height: 55.0)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            GroupBox(label: Text("Adresse")) {
                HStack {
                    let text = parking.address.components(separatedBy: "67").joined(separator: "\n67")
                    
                    Text(text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.subheadline)
                        
                    Button(action: {navigate.navigateToParking(parking: parking)}) {
                        Label(
                            title: {
                                Text("Naviguer")
                                    .font(.headline)
                            },
                            icon: {
                                Image(systemName: "arrow.triangle.turn.up.right.circle.fill")
                                    .font(.headline)
                            }
                        )
                        .padding()
                        .frame(height: 40)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }.confirmationDialog("Naviguer vers : \(parking.name) ?", isPresented: $navigate.showNavigationOptions, titleVisibility: .visible) {
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
                    }.alert("L'adresse : \(parking.address) est invalide.", isPresented: $navigate.showInvalidAddress) {
                        Button("OK", role: .cancel) { }
                    }
                }
                
                Map(
                    coordinateRegion: $region,
                    showsUserLocation: true,
                    annotationItems: [parking],
                    annotationContent: { item in
                        MapAnnotation(
                            coordinate: item.position.getCLLocationCoordinate2D(),
                            anchorPoint: CGPoint(x: 0.5, y: 0.8)
                        ) {
                            if item.occupation != nil {
                                ProgressBar(progress: (item.occupation?.percentage ?? 0) / 100, showText: false).frame(width: 25, height: 25).padding(.trailing, 5.0)
                            } else {
                                VStack(spacing: 0) {
                                    ZStack {
                                        Circle().foregroundColor(.white).shadow(radius: 5)
                                        Image(systemName: "mappin.circle.fill")
                                            .font(.title)
                                            .scaledToFit()
                                            .foregroundColor(.teal)
                                            .frame(width: 25, height: 25)
                                            .padding(.trailing, 5.0)
                                    }
                                    
                                    Image(systemName: "arrowtriangle.down.fill")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                        .offset(x: 0, y: -5)
                                }
                            }
                        }
                    }
                )
                .frame(width: .infinity, height: 150)
                .cornerRadius(15)
            }
            
            
        }
        .padding(.horizontal)
        .navigationBarTitle(parking.name, displayMode: .inline)
        //.navigationBarBackButtonHidden(true)
        //.navigationBarItems(leading: backButton)
        .onAppear {
            print(parking.position.getRegion())
            self.region = parking.position.getRegion()
        }
    }
}

struct ParkingView_Previews: PreviewProvider {
    static var previews: some View {
        ParkingView(parking: Parking.init())
    }
}

