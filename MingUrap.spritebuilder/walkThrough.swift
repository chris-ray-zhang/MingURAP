//
//  walkThrough.swift
//  MingUrap
//
//  Created by Chris Zhang on 11/6/15.
//  Copyright © 2015 Apportable. All rights reserved.
//

import UIKit

class walkThrough: CCNode {
    static var numWalkThroughs = 0
    static var complete = false
    static var hasBoughtChicken = false
    static var curText = 0
    var text: Array<String> = []
    
    func didLoadFromCCB() {
        if (walkThrough.numWalkThroughs > 0) {
            self.removeFromParentAndCleanup(true)
            
        } else {
            text = ["Welcome!, Do you want a basic tutorial?", "Here you buy assets to make your farm less... barren.", "Go ahead, buy that ROOSTER by tapping 'Buy!'","Congratulations on your first purchase!", "Now you can complete QUESTS to earn more money!"]
            userInteractionEnabled = true
            if let buyRooster = getChildByName("buyRooster", recursively: false) as? CCButton {
                buyRooster.userInteractionEnabled = false
            }
            visible = true
            walkThrough.curText = 0
            setLabelText()
            if let leftArrow = getChildByName("leftArrow", recursively: false) as? CCSprite {
                leftArrow.visible = false
            }
            if let leftClick = getChildByName("leftClick", recursively: false) as? CCButton {
                leftClick.userInteractionEnabled = false
            }
            if let rightArrow = getChildByName("rightArrow", recursively: false) as? CCSprite {
                rightArrow.visible = false
            }
            if let rightClick = getChildByName("rightClick", recursively: false) as? CCButton {
                rightClick.userInteractionEnabled = false
            }
        }
        
        
    }
    
    private func setLabelText() {
        if let label = getChildByName("label", recursively: false) as? CCLabelTTF {
            label.string = text[walkThrough.curText]
        }
        
        
    }
    
    func yesTutorial() {
        walkThrough.curText++
        setLabelText()
        if let rightArrow = getChildByName("rightArrow", recursively: false) as? CCSprite {
            rightArrow.visible = true
        }
        if let rightClick = getChildByName("rightClick", recursively: false) as? CCButton {
            rightClick.userInteractionEnabled = true
        }
        
        if let noTutorial = getChildByName("noTutorial", recursively: false) as? CCButton {
            noTutorial.visible = false
        }
        if let yesTutorial = getChildByName("yesTutorial", recursively: false) as? CCButton {
            yesTutorial.visible = false
        }
    }
    
    func noTutorial() {
        self.removeFromParentAndCleanup(true)
        walkThrough.complete = true
        questWalkThrough.complete = true
        bargainWalkThrough.complete = true
        walkThrough.numWalkThroughs++
        questWalkThrough.numWalkThroughs++
        bargainWalkThrough.numWalkThroughs++
        
        
    }
    
    func buyRooster() {
        MainScene.totalAssets -= 200
        //walkThrough.curText++
        walkThrough.hasBoughtChicken = true
        if let buyRooster = getChildByName("buyRooster", recursively: false) as? CCButton {
            buyRooster.userInteractionEnabled = false
        }
        if let rightArrow = getChildByName("rightArrow", recursively: false) as? CCSprite {
                rightArrow.visible = true
        }
        if let rightClick = getChildByName("rightClick", recursively: false) as? CCButton {
            rightClick.userInteractionEnabled = true
        }
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
        if (walkThrough.curText == text.count - 1) {
            self.removeFromParentAndCleanup(true)
            walkThrough.numWalkThroughs++
            walkThrough.complete = true
        }
        if (walkThrough.curText < text.count - 1) {
            walkThrough.curText++
            self.setLabelText()
            if (walkThrough.curText == 2) {
                if let buyRooster = getChildByName("buyRooster", recursively: false) as? CCButton {
                    buyRooster.userInteractionEnabled = true
                }
                if let rightArrow = getChildByName("rightArrow", recursively: false) as? CCSprite {
                    rightArrow.visible = false
                }
                if let rightClick = getChildByName("rightClick", recursively: false) as? CCButton {
                    rightClick.userInteractionEnabled = false
                }
            }
            if (walkThrough.curText >= 1) {
                if let leftArrow = getChildByName("leftArrow", recursively: false) as? CCSprite {
                    leftArrow.visible = false
                }
                
                if let leftClick = getChildByName("leftClick", recursively: false) as? CCButton {
                    leftClick.userInteractionEnabled = false
                }
            }
            
        } else {
    
            self.removeFromParentAndCleanup(true)
        }
    }


}
