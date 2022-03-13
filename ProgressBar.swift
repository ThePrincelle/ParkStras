//
//  ProgressBar.swift
//  ParkStras (iOS)
//
//  Created by Maxime Princelle on 13/03/2022.
//

import SwiftUI

struct ProgressBar: View {
    var progress: Double
    
    var body: some View {
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

            Text(String(format: "%.0f%%", min(self.progress, 1.0)*100.0))
                .font(.caption)
        }
    }
}

func getColor(progress: Double) -> Color {
    if (progress >= 0.9) {
        return Color.red
    }
    
    if (progress >= 0.7) {
        return Color.orange
    }
    
    if (progress >= 0.6) {
        return Color.yellow
    }
    
    return Color.green
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(progress: 0.7543)
            .frame(width: 40.0, height: 40.0)
    }
}
