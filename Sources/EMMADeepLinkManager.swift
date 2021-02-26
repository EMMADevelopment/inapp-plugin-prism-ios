//
//  EMMADeepLinkManager.swift
//  EMMAInAppPlugin-Prism
//
//  Created by Adrián Carrera on 26/02/2021.
//

import UIKit

class EMMADeepLinkManager {
    
    class func isDeeplink(url: URL) -> Bool {
        return url.absoluteString.contains("https://") && url.absoluteString.contains("http://")
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



