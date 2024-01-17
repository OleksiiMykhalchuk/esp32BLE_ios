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

    @FocusState private var isFocused

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
                VStack {
                    GaugeView(value: $viewModel.temperature, isShown: $viewModel.connected)
                    
                    textButton
                        .opacity(viewModel.connected ? 1 : 0)
                }

            }
            .navigationTitle (viewModel.title)
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

    private var textButton: some View {
        VStack {
            TextField("Setpoint", text: $viewModel.setpoint)
                .disableAutocorrection(true)
                .padding(.leading, 60)
                .padding(.trailing, 60)
                .cornerRadius(6)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.decimalPad)
                .focused($isFocused)
                .onChange(of: isFocused) { isFocused in
                    viewModel.isFocusted = isFocused
                }
            Button {
                viewModel.writeData(value: UInt8(Int(viewModel.setpoint) ?? Int(Float(viewModel.setpoint)!)))
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            } label: {
                Text("Send")
            }
            .padding()
            .frame(width: 200, height: 60)
            .background(.blue)
            .foregroundColor(.black)
            .cornerRadius(10)
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
