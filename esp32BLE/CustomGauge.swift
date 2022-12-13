//
//  CustomGauge.swift
//  esp32BLE
//
//  Created by Oleksii Mykhalchuk on 12/13/22.
//

import SwiftUI

struct CustomGaugeStyle: GaugeStyle {
    private var purpleGradient = LinearGradient(
        gradient: Gradient(colors: [Color(red: 207/255, green: 150/255, blue: 207/255),
                                    Color(red: 107/255, green: 116/255, blue: 179/255)]),
        startPoint: .leading,
        endPoint: .trailing)

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .foregroundColor(Color(.lightGray))
            Circle()
                .trim(from: 0, to: 0.75 * configuration.value)
                .stroke(purpleGradient, lineWidth: 20)
                .rotationEffect(.degrees(135))
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(.black, style: StrokeStyle(lineWidth: 10, lineCap: .butt, lineJoin: .round, dash: [1,34], dashPhase: 0.0))
                .rotationEffect(.degrees(135))
            VStack {
                configuration.currentValueLabel
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundColor(.secondary)
                Text("TEMP")
                    .font(.system(.body, design: .rounded))
                    .bold()
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 300, height: 300)
    }
}

struct CustomGauge: View {

    @Binding var currentTemp: Float

    var body: some View {
        Gauge(value: currentTemp, in: 0...30) {
            Image(systemName:"gauge.medium")
                .font(.system(size: 50))
        } currentValueLabel: {
            Text("\(currentTemp.formatted(.number))")
        }
        .gaugeStyle(CustomGaugeStyle())
        .animation(.spring(), value: currentTemp)
    }
}

//struct CustomGaugel_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomGauge(currentTemp: 30)
//            .previewDisplayName("Gauge")
//    }
//}
