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
            Button(action: {
             //let inAppPlugin = EMMAInAppPluginPrism()
             //   inAppPlugin.show()
            }) {
                Text("Show Prism")
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.init(red: 0, green: 162/255, blue: 99/255))
            .navigationBarTitle("PluginPrismDemo")
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        Color.green
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
