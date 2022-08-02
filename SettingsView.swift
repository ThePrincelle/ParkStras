//
//  SettingsView.swift
//  ParkStras (iOS)
//
//  Created by Maxime Princelle on 13/03/2022.
//

import SwiftUI

struct Credit: Identifiable {
    var id: UUID
    var name, whatfor, link: String;
    
    init(name: String, whatfor: String, link: String) {
        self.id = UUID()
        self.name = name
        self.whatfor = whatfor
        self.link = link
    }
}

struct SettingsView: View {
    @Environment(\.openURL) var openURL
    @State private var radiusSliderValue: Double = Constants.DEFAULT_RADIUS
    
    var credits: [Credit] = [
        Credit(name: "Maxime Princelle", whatfor: "Développeur de l'application", link: "https://princelle.org"),
        Credit(name: "Ville et Eurométropole de Strasbourg", whatfor: "Mise à disposition des données sur les parkings\net leur occupation", link: "https://data.strasbourg.eu"),
        Credit(name: "API Wrapper « ParkStras » (Licence MIT)", whatfor: "Interface entre la plateforme d'OpenData de Strasbourg et l'application", link: "https://github.com/ThePrincelle/ParkStrasAPI")
    ]
    
    let preferences = UserDefaults.standard
    let searchRadiusKey = "radius"

    //  Save to disk
    func setValue(to newValue: Double) {
        preferences.set(newValue, forKey: searchRadiusKey)
        preferences.synchronize()
    }
    
    func getValue() -> Double {
        if preferences.object(forKey: searchRadiusKey) != nil {
            return preferences.double(forKey: searchRadiusKey)
        } else {
            setValue(to: Constants.DEFAULT_RADIUS)
            return Constants.DEFAULT_RADIUS
        }
    }
    
    func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version) (\(build))"
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(
                    header: Text("Rayon de recherche").padding(.top, 9),
                    footer: Text("Réglez le périmètre de recherche en fonction de votre position.")
                ) {
                    Slider(
                        value: $radiusSliderValue,
                        in: Constants.RADIUS_SLIDER.RANGE,
                        step: Constants.RADIUS_SLIDER.STEP
                    ) {
                        Text("Rayon de recherche")
                    } minimumValueLabel: {
                        Text("")
                    } maximumValueLabel: {
                        Text(Measurement(value: getValue(), unit: UnitLength.meters).formatted())
                    }.onChange(of: radiusSliderValue, perform: setValue)
                }
                
                Section(
                    header: Text("Vie privée").padding(.top, 15)
                ) {
                    HStack(spacing: 10) {
                        Image(systemName: "hand.raised.circle").font(.title)
                        Text("Cette application et les APIs utilisées par cette dernière ne collectent aucune de vos données personnelles, votre position géographique est envoyée de manière anonyme.").font(.caption2)
                    }
                }
                
                Section(
                    header: Text("A propos")
                ) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(version())
                    }
                    Text("Copyright © \(Calendar.current.component(.year, from: Date()).description) • Maxime Princelle")
                    HStack {
                        VStack(alignment: .leading) {
                            Text("**Code source de l'application**").font(.caption)
                            Text("Licence MIT").font(.caption2)
                        }
                        Spacer()
                        Link(destination: URL(string: "https://github.com/ThePrincelle/ParkStras")!) {
                            Image(systemName: "link")
                        }
                    }.onTapGesture {
                        openURL(URL(string: "https://github.com/ThePrincelle/ParkStras")!)
                    }
                }
                
                Section(
                    header: Text("Crédits")
                ) {
                    List(credits) {credit in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("**\(credit.name)**").font(.caption)
                                Text(credit.whatfor).font(.caption2)
                            }
                            Spacer()
                            Link(destination: URL(string: "\(credit.link)")!) {
                                Image(systemName: "link")
                            }
                        }.onTapGesture {
                            openURL(URL(string: "\(credit.link)")!)
                        }
                    }
                }
            }.navigationTitle("Paramètres").navigationBarTitleDisplayMode(.large)
        }.onAppear {
            radiusSliderValue = getValue()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
