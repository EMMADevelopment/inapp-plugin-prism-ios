//
//  Prism.swift
//  
//
//  Created by Adrián Carrera on 23/02/2021.
//

import Foundation

class Prism {
    var campaignId: Int
    var openInApp: Bool
    var canClose: Bool
    var sides: [PrismSide]
    
    init(campaignId: Int, openInApp: Bool, canClose: Bool, sides: [PrismSide]) {
        self.campaignId = campaignId
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
