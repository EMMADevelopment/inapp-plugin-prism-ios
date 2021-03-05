//
//  ContentView.swift
//  PluginPrismDemo
//
//  Created by Adrián Carrera on 19/02/2021.
//

import SwiftUI
import EMMA_iOS
import EMMAInAppPlugin_Prism

struct ContentView: View {

    func getFakeNative() -> EMMANativeAd {
        let nativeAd = EMMANativeAd()
        nativeAd.idPromo = 123456789
        nativeAd.openInSafari = false
        nativeAd.canClose = true
        nativeAd.nativeAdContent = ["container":[
                ["Main picture": "https://i.picsum.photos/id/586/300/700.jpg?hmac=TKBELClTbUvaXq5NHUpCVnnhssZ3tYTSLTYBi6rPo5Q", "CTA": "emmaio://tab/?d=1"
                ],
                ["Main picture": "https://i.picsum.photos/id/666/300/700.jpg?hmac=mXEaSU1_1gEAtK3z-beAT7GyWGt8oYsa34QOXLBx-qY","CTA": "https://emma.io"
                ]
            ]
          ]
        return nativeAd
    }

    var body: some View {
        NavigationView {
            Button(action: {
                let inAppPlugin = EMMAInAppPluginPrism()
                inAppPlugin.show(getFakeNative())
            }) {
                Text("Show Prism")
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.init(red: 0, green: 162/255, blue: 99/255))
            .navigationBarTitle("PluginPrismDemo")
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
