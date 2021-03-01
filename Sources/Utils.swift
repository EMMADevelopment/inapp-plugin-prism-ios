//
//  Utils.swift
//  EMMAInAppPlugin-Prism
//
//  Created by Adrian Carrera on 28/2/21.
//

import UIKit

class Utils {

    class func isWebUrl(url: URL) -> Bool {
        return url.absoluteString.contains("https://") || url.absoluteString.contains("http://")
    }
    
    class func openUrl(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            DispatchQueue.main.async {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}
