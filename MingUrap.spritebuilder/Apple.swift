//
//  Apple.swift
//  MingUrap
//
//  Created by Chris Zhang on 6/16/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Apple: CCNode, CCPhysicsCollisionDelegate {
    var hasBeenCollected:Bool = false
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        /*
        physicsBody.affectedByGravity = false
        */
        physicsBody.collisionType = "apple"
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if (!hasBeenCollected) {
            /*
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            */
            physicsBody.type = CCPhysicsBodyType.Dynamic
            physicsBody.affectedByGravity = true
            applePicking.applesPicked++
            applePicking.applesLeft--
            hasBeenCollected = true
        }
        
    }
    /*
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair, apple: CCNode, wildcard: CCNode) -> Bool {
        println("Hello")
        return true
    }
    */
}
