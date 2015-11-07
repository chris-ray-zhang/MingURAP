//
//  walkThrough.swift
//  MingUrap
//
//  Created by Chris Zhang on 11/6/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

class walkThrough: CCNode {
    static var curText = 0
    var text: Array<String> = []
    
    func didLoadFromCCB() {
        text = ["Here you buy assets to make your farm less... barren.", "Go ahead, buy that ROOSTER by tapping 'Buy!'"]
        userInteractionEnabled = true
        
        visible = true
        walkThrough.curText = 0
        setLabelText()
        if let leftArrow = getChildByName("leftArrow", recursively: false) as? CCSprite {
            leftArrow.visible = false
        }
        if let leftClick = getChildByName("leftClick", recursively: false) as? CCButton {
            leftClick.userInteractionEnabled = false
        }
        
    }
    
    private func setLabelText() {
        
        if let label = getChildByName("label", recursively: false) as? CCLabelTTF {
            label.string = text[walkThrough.curText]
        }
        
        
    }
    
    func buyRooster() {
        self.removeFromParentAndCleanup(true)
        walkThrough.curText++
    }
    
    func leftClick() {
        walkThrough.curText--
        self.setLabelText()
        if let rightArrow = getChildByName("rightArrow", recursively: false) as? CCSprite {
            rightArrow.visible = true
        }
        if let leftArrow = getChildByName("leftArrow", recursively: false) as? CCSprite {
            leftArrow.visible = false
        }
        if let rightClick = getChildByName("rightClick", recursively: false) as? CCButton {
            rightClick.userInteractionEnabled = true
        }
        if let leftClick = getChildByName("leftClick", recursively: false) as? CCButton {
            leftClick.userInteractionEnabled = false
        }
        if let buyRooster = getChildByName("buyRooster", recursively: false) as? CCButton {
            buyRooster.userInteractionEnabled = false
        }

    }
    
    func rightClick() {
        if (walkThrough.curText < 2) {
            walkThrough.curText++
            self.setLabelText()
            if let rightArrow = getChildByName("rightArrow", recursively: false) as? CCSprite {
                rightArrow.visible = false
            }
            if let leftArrow = getChildByName("leftArrow", recursively: false) as? CCSprite {
                leftArrow.visible = true
            }
            if let rightClick = getChildByName("rightClick", recursively: false) as? CCButton {
                rightClick.userInteractionEnabled = false
            }
            if let leftClick = getChildByName("leftClick", recursively: false) as? CCButton {
                leftClick.userInteractionEnabled = true
            }
            if let buyRooster = getChildByName("buyRooster", recursively: false) as? CCButton {
                buyRooster.userInteractionEnabled = true
            }
        } else {
    
            self.removeFromParentAndCleanup(true)
        }
    }


}
