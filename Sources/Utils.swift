//
//  Utils.swift
//  EMMAInAppPlugin-Prism
//
//  Created by Adrian Carrera on 28/2/21.
//

import Foundation

class Utils {

    class func isWebUrl(url: URL) -> Bool {
        return url.absoluteString.contains("https://") || url.absoluteString.contains("http://")
    }
}
