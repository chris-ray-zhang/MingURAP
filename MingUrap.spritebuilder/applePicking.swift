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
    private var tempTimer = 0
    static var initialNumApples = 0
    static var applesLeft = 0
    static var applesPicked = 0
    private weak var applesOnTree : CCPhysicsNode? = nil
    

    
     func didLoadFromCCB() {
        userInteractionEnabled = true
        applesOnTree = getChildByName("applesOnTree", recursively:false) as? CCPhysicsNode
        
        applePicking.applesLeft = applesOnTree!.children.count - 1
        applePicking.initialNumApples = applesOnTree!.children.count - 1
        if let tapApples = getChildByName("tapApples", recursively: false) as? CCLabelTTF {
            tapApples.visible = true
        }
        applePicking.applesPicked = 0
        setupAppleTimer()
        
    }
    //Sets up apple-picking timer to 30 seconds
    func setupAppleTimer() {
        tempTimer = 30
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

            if let summaryReport = getChildByName("summaryReport", recursively: false) {
                summaryReport.visible = true
            }
            
            let applePickingSummary = CCBReader.loadAsScene("applePickingSummary")
            CCDirector.sharedDirector().replaceScene(applePickingSummary)
            
        }
    }
    
    override func onExit() {
        
        CCDirector.sharedDirector().purgeCachedData()

        removeAllChildrenWithCleanup(true)
    }
    

    
    
    /**
        Function that draws a new apple at a random location.
        To-add: apples that are added do not overlap
    */
    func partialResetImages() {
        var xcord = (CGFloat) (randomInt(60, max: 200))
        var ycord = (CGFloat) (randomInt(275, max: 385))
        drawApple(xcord, y: ycord)
    }
    
    /**
        Function that generates a random number between min and max.
        Found code from:
        http://stackoverflow.com/questions/24007129/how-does-one-generate-a-random-number-in-apples-swift-language
    */
    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
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
        if (applePicking.applesPicked > 0) {
            if let tapApples = getChildByName("tapApples", recursively: false) as? CCLabelTTF {
                tapApples.visible = false
            }
        }
//        if (applePicking.applesLeft <= 5) {
//            partialResetImages()
//        }
//        if (applePicking.applesLeft <= 0) {
//            resetImages()
//        }
        // Every time a new apple is spawned, tempTimer is set to current appleTime so that a new apple
        // spawns at most every half sectond.
        if ((tempTimer - appleTime) * 2 >= 1) {
            if (applePicking.applesLeft <= 5) {
                partialResetImages()
                tempTimer = appleTime
            }
        }
    }
    
    
   
}
