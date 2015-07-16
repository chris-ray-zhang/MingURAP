//
//  PopUp.swift
//  MingUrap
//
//  Created by Abdulrahman AlZanki on 5/6/15, modified by Chris Zhang.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class PopUp: CCNode {
    static var curText = 0
    var pricePerApple = 30
    var totalAmount = 0
    var text: Array<String> = []
    
    func didLoadFromCCB() {
        totalAmount = decideNumApples() * pricePerApple
        bargainGame.curGold = Double(totalAmount)
        text = ["Great job! You picked \(applePicking.applesPicked) apples.", "Your neighbor, Austin, has flour from his mill. We’ll need some to make apple pies.", "Austin: \"Hi there! I have bags of flour, so using your apples, we can make \(decideNumApples()) pies and sell them for \(totalAmount) gold.\"", "Austin: \"Not so fast though. Let’s decide how we’ll split the \(totalAmount) gold first.\"", "Make an offer to Austin. Each offer takes time, causing some apples and 10% of the total earnings to spoil! Initial Amount: \(totalAmount)"]
        userInteractionEnabled = true
        
        visible = true
        
        setLabelText()

    }
    /* Returns the initial amount of pies that can be baked, which is dependent on the number of apples picked */
    func decideNumApples() -> Int {
        return Int(applePicking.applesPicked)
    }
    

    
    private func setLabelText() {
        if (PopUp.curText < 5) {
            if let label = getChildByName("label", recursively: false) as? CCLabelTTF {
                label.string = text[PopUp.curText]
                
            }
        }
        PopUp.curText++

        
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if PopUp.curText > 5 {
            self.visible = false
            if let label = getChildByName("label", recursively: false) as? CCLabelTTF {
                label.string = "There are now \(Int(bargainGame.curGold)) gold coins"
            }
            
        } else {
            setLabelText()
            /*
            self.removeFromParentAndCleanup(true)
            */
        }
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
    }
    
    override func update(delta: CCTime) {
        if PopUp.curText > 5 {
            if let label = getChildByName("label", recursively: false) as? CCLabelTTF {
                label.string = "There are now \(Int(bargainGame.curGold)) gold coins"
            }
            
        }
    }
    
    
}