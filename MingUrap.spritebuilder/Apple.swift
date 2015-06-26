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
    var player: AVAudioPlayer! = nil
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        physicsBody.collisionType = "apple"
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
    }
    
    
    //Credit to http://stackoverflow.com/questions/24393495/playing-a-sound-with-avaudioplayer-swift
    func prepareSound() {
        let path = NSBundle.mainBundle().pathForResource("appleGrab", ofType:"aif")
        let fileURL = NSURL(fileURLWithPath: path!)
        player = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
        player.currentTime = 0.5
        player.prepareToPlay()
        player.play()
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if (!hasBeenCollected) {
            /*
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            */
            prepareSound()
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
