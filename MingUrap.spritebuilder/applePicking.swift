//
//  applePicking.swift
//  MingUrap
//
//  Created by Michael Zhang on 6/9/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class applePicking: CCNode {
    var applesPicked = 0
    
    func updateApplesPicked(amount: Int) {
        applesPicked += amount
        if let applesPickedLabel = getChildByName("applesPickedLabel", recursively: false) as? CCLabelTTF {
            applesPickedLabel.string = "Apples: " + applesPicked.description
        }
    }
    
    func pickApple() {
        updateApplesPicked(1)
    }
    
}