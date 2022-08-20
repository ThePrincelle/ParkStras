//
//  ProgressBar.swift
//  ParkStras (iOS)
//
//  Created by Maxime Princelle on 13/03/2022.
//

import SwiftUI

struct ProgressBar: View {
    var progress: Double
    var showText: Bool = false
    var parking: Parking
    
    let preferences = UserDefaults.standard
    let displayOccupationKey = "occupation_display"
    func getValueDisplayOccupation() -> DISPLAY_OCCUPATION {
        if preferences.object(forKey: displayOccupationKey) != nil {
            return DISPLAY_OCCUPATION(rawValue: preferences.integer(forKey: displayOccupationKey)) ?? Constants.DEFAULT_DISPLAY_OCCUPATION
        } else {
            preferences.set(Constants.DEFAULT_DISPLAY_OCCUPATION.rawValue, forKey: displayOccupationKey)
            return Constants.DEFAULT_DISPLAY_OCCUPATION
        }
    }
    
    var body: some View {
        if (showText) {
            ZStack {
                Circle()
                    .stroke(lineWidth: 8.0)
                    .opacity(0.3)
                    .foregroundColor(getColor(progress: progress))
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 8.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(getColor(progress: progress))
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(/*@START_MENU_TOKEN@*/.linear/*@END_MENU_TOKEN@*/, value: 1)
                
                if (self.progress == 1) {
                    Text("Plein")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                } else {
                    if (getValueDisplayOccupation() == DISPLAY_OCCUPATION.PERCENTAGE) {
                        Text(String(format: "%.0f%%", min(self.progress, 1.0)*100.0))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    if (getValueDisplayOccupation() == DISPLAY_OCCUPATION.NB_FREE_PLACES) {
                        Text(String(parking.occupation?.available ?? 0))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        } else {
            VStack(spacing: 0) {
                ZStack {
                    Circle().foregroundColor(.white).shadow(radius: 5)
                    Image(systemName: "mappin.circle.fill")
                        .font(.title)
                        .scaledToFit()
                        .foregroundColor(getColor(progress: progress))
                }
                
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.caption)
                    .foregroundColor(getColor(progress: progress))
                    .offset(x: 0, y: -5)
            }
        }
    }
}

func getColor(progress: Double) -> Color {
    if (progress >= 0.9) {
        return Color.red
    }
    
    if (progress >= 0.75) {
        return Color.orange
    }
    
    if (progress >= 0.65) {
        return Color.yellow
    }
    
    return Color.green
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 90) {
            ProgressBar(progress: 0.7543, showText: true, parking: Parking())
                .frame(width: 40.0, height: 40.0)
            
            ProgressBar(progress: 1, showText: true, parking: Parking())
                .frame(width: 40.0, height: 40.0)
            
            VStack {
                ProgressBar(progress: 0.7543, parking: Parking())
                    .frame(width: 40.0, height: 40.0)
            }.background(.gray)
        }
    }
}
