//
//  applePicking.swift
//  MingUrap
//
//  Created by Chris Zhang on 6/15/15.
//  Code for generating apples at appropriate locations by Michael Zhang
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit
import Darwin

struct Distance : Hashable {
    var x : CGFloat
    var y : CGFloat
    
    var hashValue: Int {
        return (Int) (x + y)
    }
    
    init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
    
    func calcDistance(other: Distance) -> Double {
        return sqrt(pow((Double)(x - other.x),2) + pow((Double)(y - other.y),2))
    }
    
    func validLocation(other: Distance) -> Bool {
        return calcDistance(other) >= 30
    }
}
func ==(lhs: Distance, rhs: Distance) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

class applePicking: CCNode {
    
    private var appleTime = 0
    private weak var appleTimer = NSTimer()
    private var tempTimer = 0
    static var initialNumApples = 0
    static var applesLeft = 0
    static var applesPicked = 0
    static var locations = Set<Distance>()
    private weak var applesOnTree : CCPhysicsNode? = nil
    private var firstAppleTapped = false
    
    
     func didLoadFromCCB() {
        userInteractionEnabled = true
        applesOnTree = getChildByName("applesOnTree", recursively:false) as? CCPhysicsNode
        
        applePicking.applesLeft = applesOnTree!.children.count - 1
        applePicking.initialNumApples = applesOnTree!.children.count - 1
        if let tapApples = getChildByName("tapApples", recursively: false) as? CCLabelTTF {
            tapApples.visible = true
        }
        applePicking.applesPicked = 0
        
        
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
            
            appleTimer!.invalidate()

            if let summaryReport = getChildByName("summaryReport", recursively: false) {
                summaryReport.visible = true
            }
            
            var applePickingSummary = CCBReader.loadAsScene("applePickingSummary")
            CCDirector.sharedDirector().replaceScene(applePickingSummary)
            applePickingSummary = nil

            
        }
    }
    
    

    /**
        Function that draws a new apple at a random location.
        To-add: apples that are added do not overlap
    */
    func partialResetImages() {
        valid = true
        var xcord = (CGFloat) (randomInt(55, max: 270))
        var ycord = (CGFloat) (randomInt(270, max: 390))
        var potential = Distance(x: xcord, y: ycord)
        for distance in applePicking.locations {
            if (!distance.validLocation(potential)) {
                valid = false
            }
        }
        if valid {
            applePicking.locations.insert(potential)
            drawApple(xcord, y: ycord)
        }
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
        let newApple:CCNode = CCBReader.load("apple")
        newApple.scaleX = 0.5
        newApple.scaleY = 0.5
        newApple.position = ccp(x,y)
        applesOnTree!.addChild(newApple)
        applePicking.applesLeft++
    }
    
    private var regenerating = false
    
    private var valid = false

    override func update(delta: CCTime) {
        
        if (!firstAppleTapped && applePicking.applesPicked > 0) {
            setupAppleTimer()
            firstAppleTapped = true
        }
        if let applePickedLabel = getChildByName("applePickedLabel", recursively: false) as? CCLabelTTF {
            applePickedLabel.string = "Apples Picked: \(applePicking.applesPicked)"
        }
        if (applePicking.applesPicked > 0) {
            if let tapApples = getChildByName("tapApples", recursively: false) as? CCLabelTTF {
                tapApples.visible = false
            }
        }
        if (applePicking.applesLeft <= 5) {
            partialResetImages()
        }
                
        
    }
    
    
   
}
