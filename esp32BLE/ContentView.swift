//
//  ContentView.swift
//  esp32BLE
//
//  Created by Oleksii Mykhalchuk on 11/23/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel = ViewModel()

    var body: some View {
        ZStack {
            VStack {
                Text("Temperature: \(viewModel.temperature)")
                    .padding()
                Button {
                    !viewModel.connected ? viewModel.connect() : viewModel.disconnect()
                } label: {
                    Text(viewModel.output)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(.white, lineWidth: 1))
                }
                .background(.yellow)
                .cornerRadius(10)

            }

        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
