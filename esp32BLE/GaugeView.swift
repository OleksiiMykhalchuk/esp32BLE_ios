//
//  GaugeView.swift
//  esp32BLE
//
//  Created by Oleksii Mykhalchuk on 11/24/22.
//

import SwiftUI

struct GaugeView: View {
    @Binding var value: Float
    @Binding var isShown: Bool
    var body: some View {
        CustomGauge(currentTemp: $value)
            .opacity(isShown ? 1 : 0)
            .animation(.spring(), value: isShown)
    }
}

//struct GaugeView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        GaugeView()
//    }
//}
