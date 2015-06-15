//
//  applePicking.swift
//  MingUrap
//
//  Created by Chris Zhang on 6/15/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class applePicking: CCNode {
    var appleTime = 0
    var appleTimer = NSTimer()
    static var applesPicked = 0

    func didLoadFromCCB() {
        setupAppleTimer()
    }

    func setupAppleTimer() {
        appleTime = 30
        if let appleTimeLeft = getChildByName("appleTimeLeft", recursively: false) as? CCLabelTTF {
            appleTimeLeft.string = "Time Left: \(appleTime)"
        }
        appleTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractAppleTime"), userInfo: nil, repeats: true)
    }
    
    func subtractAppleTime() {
        appleTime--
        if let appleTimeLeft = getChildByName("appleTimeLeft", recursively: false) as? CCLabelTTF {
            appleTimeLeft.string = "Time Left: \(appleTime)"
        }
        if (appleTime == 0) {
            appleTimer.invalidate()
            let bargainGame = CCBReader.loadAsScene("bargainGame")
            CCDirector.sharedDirector().pushScene(bargainGame)
        }
    }
    
    func pickApple() {
        applePicking.applesPicked++
        if let applePickedLabel = getChildByName("applePickedLabel", recursively: false) as? CCLabelTTF {
            applePickedLabel.string = "Apples Picked: \(applePicking.applesPicked)"
        }
    }
    
   
}
