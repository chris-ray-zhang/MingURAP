//
//  questWalkThrough.swift
//  MingUrap
//
//  Created by Chris Zhang on 11/26/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

class questWalkThrough: CCNode {
    private var curText = 0
    var text: Array<String> = []
    static var numWalkThroughs = 0
    static var complete = false
    
    func didLoadFromCCB() {
        if (questWalkThrough.numWalkThroughs > 0) {
            self.removeFromParentAndCleanup(true)
            
        } else {
            text = ["Here you can complete quests to earn money!", "Go ahead, click on DELICIOUS APPLE PIES"]
            userInteractionEnabled = true
            visible = true
            curText = 0
            setLabelText()
            if let leftArrow = getChildByName("leftArrow", recursively: false) as? CCSprite {
                leftArrow.visible = false
            }
            if let leftClick = getChildByName("leftClick", recursively: false) as? CCButton {
                leftClick.userInteractionEnabled = false
            }
        }
        
        
    }
    
    private func setLabelText() {
        if let label = getChildByName("label", recursively: false) as? CCLabelTTF {
            label.string = text[curText]
        }
    }
    
    func rightClick() {
        if (curText < text.count - 1) {
            curText++
            if (curText == text.count - 1) {
                questWalkThrough.numWalkThroughs++
                if let rightArrow = getChildByName("rightArrow", recursively: false) as? CCSprite {
                    rightArrow.visible = false
                }
                if let rightClick = getChildByName("rightClick", recursively: false) as? CCButton {
                    rightClick.userInteractionEnabled = false
                }
                questWalkThrough.complete = true
            }
            setLabelText()
        }
    }
    
    func leftClick() {
        if (curText > 0) {
            curText--
            setLabelText()
        }
        
    }


}
