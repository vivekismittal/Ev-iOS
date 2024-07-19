//
//  ProgressRingView.swift
//  EVApp
//
//  Created by VM on 03/07/24.
//

import SwiftUI

class ProgressRingObservableData: ObservableObject{
    @Published var percentage: Float
    @Published  var label: String
    
    init(percentage: Float, label: String) {
        self.percentage = percentage
        self.label = label
    }
    
    func updateData(percentage: Float? = nil ,label: String? = nil){
        withAnimation(.easeInOut(duration: 1)) {
            if let percentage{
                self.percentage = percentage
            }
            if let label{
                self.label = label
            }
        }
    }
}

struct ProgressRingView: View {
    
    @ObservedObject var progressRingData: ProgressRingObservableData

    private let trackColor: Color
    private let progressColor: Color
    private let iconImage: String
    private let lineWidth: CGFloat
    private let progressLineWidth: CGFloat
    
    init(trackColor: Color, progressColor: UIColor, iconImage: String, progressRingData: ProgressRingObservableData, lineWidth: CGFloat = 8, progressLineWidth: CGFloat = 14) {
        self.trackColor = trackColor
        self.progressColor = Color(progressColor)
        self.iconImage = iconImage
        self.progressRingData = progressRingData
        self.lineWidth = lineWidth
        self.progressLineWidth = progressLineWidth
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(trackColor, lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(progressRingData.percentage))
                .stroke(progressColor, style: StrokeStyle(lineWidth: progressLineWidth, lineCap: .round))
                .rotationEffect(Angle(radians: -CGFloat.pi / 2))
            
            VStack{
                Text(progressRingData.label)
                    .font(.system(size: (24),weight: .bold))
                Image(iconImage).resizable().frame(width: 30,height: 30)
            }
        }
    }
}




