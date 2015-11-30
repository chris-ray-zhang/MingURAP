//
//  PopUp.swift
//  MingUrap
//
//  Created by Abdulrahman AlZanki on 5/6/15, modified by Chris Zhang.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class bargainWalkThrough: CCNode {
    private var curText = 0
    var pricePerApple = 30
    static var complete = false
    static var numWalkThroughs = 0
    var totalAmount = 0
    var text: Array<String> = []
    
    func didLoadFromCCB() {
//        if (bargainWalkThrough.numWalkThroughs > 0) {
//            self.removeFromParentAndCleanup(true)
//        } else {
//            totalAmount = decideNumApples() * pricePerApple
//            bargainGame.curGold = Double(totalAmount)
//            text = ["Great job! You picked \(applePicking.applesPicked) apples.", "Your neighbor, Austin, has flour from his mill. We’ll need some to make apple pies.", "Austin: \"Hi there! I have bags of flour, so using your apples, we can make \(decideNumApples()) pies and sell them for \(totalAmount) gold.\"", "Austin: \"Not so fast though. Let’s decide how we’ll split the \(totalAmount) gold first.\"", "Make an offer to Austin. Each offer takes time, causing some apples and 10% of the total earnings to spoil!"]
//            userInteractionEnabled = true
//            
//            visible = true
//            curText = 0
//            setLabelText()
//        }
        totalAmount = decideNumApples() * pricePerApple
        bargainGame.curGold = Double(totalAmount)
        text = ["Great job! You picked \(applePicking.applesPicked) apples.", "Your neighbor, Austin, has flour from his mill. We’ll need some to make apple pies.", "Austin: \"Hi there! I have bags of flour, so using your apples, we can make \(decideNumApples()) pies and sell them for \(totalAmount) gold.\"", "Austin: \"Not so fast though. Let’s decide how we’ll split the \(totalAmount) gold first.\"", "Make an offer to Austin. Each offer takes time, causing some apples and 10% of the total earnings to spoil!"]
        userInteractionEnabled = true
        
        visible = true
        curText = 0
        setLabelText()
    }
    /* Returns the initial amount of pies that can be baked, which is dependent on the number of apples picked */
    func decideNumApples() -> Int {
        return Int(applePicking.applesPicked)
    }
    

    
    private func setLabelText() {
        if let label = getChildByName("label", recursively: false) as? CCLabelTTF {
            label.string = text[curText]
        }
    }
    
    func rightClick() {
        if (curText < text.count) {
            curText++
            if (curText == text.count) {
                bargainWalkThrough.numWalkThroughs++
                if let rightArrow = getChildByName("rightArrow", recursively: false) as? CCSprite {
                    rightArrow.visible = false
                }
                if let rightClick = getChildByName("rightClick", recursively: false) as? CCButton {
                    rightClick.userInteractionEnabled = false
                }
                self.removeFromParentAndCleanup(true)
                bargainWalkThrough.complete = true
                
            } else {
                setLabelText()
            }
            
        }
    }
    
    
    
}