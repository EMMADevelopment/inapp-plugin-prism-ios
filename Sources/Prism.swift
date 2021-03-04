//
//  Prism.swift
//  
//
//  Created by Adrián Carrera on 23/02/2021.
//

import Foundation
import EMMA_iOS

class Prism {
    var campaign: EMMACampaign
    var openInApp: Bool
    var canClose: Bool
    var sides: [PrismSide]
    
    init(campaign: EMMACampaign, openInApp: Bool, canClose: Bool, sides: [PrismSide]) {
        self.campaign = campaign
        self.openInApp = openInApp
        self.canClose = canClose
        self.sides = sides
        
        addCyclicSidesIfNeeded()
    }
    
    private func addCyclicSidesIfNeeded() {
        if sides.count > 1, let firstSide = sides.first, let lastSide = sides.last  {
            sides.insert(lastSide, at: 0)
            sides.append(firstSide)
        }
    }
}
