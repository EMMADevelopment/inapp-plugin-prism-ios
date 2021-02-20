//
//  ContentView.swift
//  PluginPrismDemo
//
//  Created by Adrián Carrera on 19/02/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Button(action: {}) {
                Text("Show Prism")
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.red)
            .navigationBarTitle("PluginPrismDemo")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
