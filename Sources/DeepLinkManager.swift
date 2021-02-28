//
//  DeepLinkManager.swift
//  EMMAInAppPlugin-Prism
//
//  Created by Adrián Carrera on 26/02/2021.
//

import UIKit

class DeepLinkManager {
    
    class func isDeeplink(url: URL) -> Bool {
        return !Utils.isWebUrl(url: url)
    }
    
    class func open(url: URL) {
        DispatchQueue.main.async {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}



