//
//  ContentView.swift
//  esp32BLE
//
//  Created by Oleksii Mykhalchuk on 11/23/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    @State var hide: Bool = true

    var body: some View {
        NavigationStack {
            ZStack {
                TableView(isHidden: $viewModel.connected) {
                    List(viewModel.peripherals, id: \.identifier) { peripheral in
                        Button {
                            viewModel.connect(perepheral: peripheral)
                            viewModel.title = peripheral.name ?? "Unnamed"
                        } label: {
                            Text(peripheral.name ?? "Unnamed")
                        }
                    }
                    .listStyle(.plain)
                }
                GaugeView(value: $viewModel.temperature, isShown: $viewModel.connected)
            }
            .navigationTitle(viewModel.title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        switch viewModel.state {
                        case .Scan:
                            viewModel.start()
                        case .StopScanning:
                            viewModel.stop()
                        case .Disconnect:
                            viewModel.disconnect()
                        case .Connect:
                            print("")
                        }
                    } label: {
                        Text(viewModel.state.rawValue)
                    }

                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel())
    }
}

struct TableView<Content: View>: View {

    @Binding var isHidden: Bool
    var content: () -> Content

    var body: some View {
        VStack(content: content)
            .opacity(isHidden ? 0 : 1)
            .animation(.spring(), value: isHidden)
    }
}
