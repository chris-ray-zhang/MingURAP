//
//  applePicking.swift
//  MingUrap
//
//  Created by Chris Zhang on 6/15/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class applePicking: CCNode {
    private var appleTime = 0
    private var appleTimer = NSTimer()
    static var initialNumApples = 0
    static var applesLeft = 0
    static var applesPicked = 0
    private var applesOnTree : CCPhysicsNode? = nil
    

    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        applesOnTree = getChildByName("applesOnTree", recursively:false) as? CCPhysicsNode
        
        applePicking.applesLeft = applesOnTree!.children.count - 1
        applePicking.initialNumApples = applesOnTree!.children.count - 1
        
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
            /*
            appleTimer.invalidate()
            */
            let bargainGame = CCBReader.loadAsScene("bargainGame")
            CCDirector.sharedDirector().replaceScene(bargainGame)

        }
    }
    
    func resetImages() {
        drawApple(200,y: 300)
        drawApple(110,y: 300)
        drawApple(75,y: 275)
        drawApple(175,y: 350)
        
        drawApple(130, y: 335)
        drawApple(250,y: 358)
        
        drawApple(204,y: 275)
        drawApple(94,y: 350)
        
        drawApple(107,y: 385)
        drawApple(64,y: 360)

    }
    
    func drawApple(x: CGFloat, y: CGFloat) {
        let newApple:CCNode = CCBReader.load("Apple")
        newApple.scaleX = 0.5
        newApple.scaleY = 0.5
        newApple.position = ccp(x,y)
        applesOnTree!.addChild(newApple)
        applePicking.applesLeft++
    }
    
    
    override func update(delta: CCTime) {
        if let applePickedLabel = getChildByName("applePickedLabel", recursively: false) as? CCLabelTTF {
            applePickedLabel.string = "Apples Picked: \(applePicking.applesPicked)"
        }
        if (applePicking.applesLeft <= 0) {
            resetImages()
        }
    }
    
    
   
}
