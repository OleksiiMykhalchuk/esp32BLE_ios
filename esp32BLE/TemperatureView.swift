//
//  TemperatureView.swift
//  esp32BLE
//
//  Created by Oleksii Mykhalchuk on 11/24/22.
//

import SwiftUI

struct TemperatureView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        text
    }

    var text: some View {
        VStack {
            Text("Temperature: ")
            Text("")
        }
    }
}

struct TemperatureView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureView(viewModel: ViewModel())
    }
}
