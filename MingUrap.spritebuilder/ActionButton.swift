//
//  ActionButton.swift
//  MingUrap
//
//  Created by Abdulrahman AlZanki on 4/15/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class ActionButton : CCButton {
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if let p = self.parent!.parent as? bargainGame {
            switch name {
                case "actionButton":
                    p.makeOfferTapped()
                case "rejectButton":
                    p.rejectedCounterOffer()
                case "acceptButton":
                    p.acceptedCounterOffer()
                default:
                   print("button not found")
            }
        }
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
    }
}