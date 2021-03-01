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
        Utils.openUrl(url: url)
    }
}



