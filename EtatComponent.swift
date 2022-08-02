//
//  EtatComponent.swift
//  ParkStras
//
//  Created by Maxime Princelle on 01/08/2022.
//

import SwiftUI

struct EtatComponent: View {
    var etat: Etat
    var withText: Bool
    
    var body: some View {
        switch (etat) {
            case Etat.OPEN:
                LazyHStack(spacing: 5) {
                    Image(systemName: "parkingsign.circle.fill").foregroundColor(.green)
                    if withText {
                        Text("Ouvert")
                    }
                }
            case Etat.CLOSED:
                LazyHStack(spacing: 5) {
                    Image(systemName: "lock.circle").foregroundColor(Color.red)
                    if withText {
                        Text("Fermé")
                    }
                }
            case Etat.FULL:
                LazyHStack(spacing: 5) {
                    Image(systemName: "parkingsign.circle.fill").foregroundColor(Color.red)
                    if withText {
                        Text("Plein")
                    }
                }
            case Etat.UNKNOWN:
                LazyHStack(spacing: 5) {
                    Image(systemName: "questionmark.app.fill").foregroundColor(Color.orange)
                    if withText {
                        Text("Inconnu")
                    }
                }
        }
    }
}

struct EtatComponent_Previews: PreviewProvider {
    static var previews: some View {
        LazyHStack(spacing: 10) {
            EtatComponent(etat: Etat.OPEN, withText: true)
            EtatComponent(etat: Etat.CLOSED, withText: true)
            EtatComponent(etat: Etat.FULL, withText: true)
            EtatComponent(etat: Etat.UNKNOWN, withText: true)
        }
       
        LazyHStack(spacing: 10) {
            EtatComponent(etat: Etat.OPEN, withText: false)
            EtatComponent(etat: Etat.CLOSED, withText: false)
            EtatComponent(etat: Etat.FULL, withText: false)
            EtatComponent(etat: Etat.UNKNOWN, withText: false)
        }
    }
}
