//
//  applePickingSummary.swift
//  MingUrap
//
//  Created by Chris Zhang on 6/23/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class applePickingSummary: CCNode {
    
    func didLoadFromCCB() {
        if (applePicking.applesPicked == 0) {
            if let continueButton = getChildByName("continueButton", recursively: false) as? CCButton {
                continueButton.visible = false
            }
            if let title = getChildByName("title", recursively: false) as? CCLabelTTF {
                title.string = "T'was a Bad Picking"
            }
            if let tryAgain = getChildByName("tryAgain", recursively: false) as? CCLabelTTF {
                tryAgain.string = "Please Pick Again"
            }
            
        }
    }
    
    
    override func onExit() {
        CCDirector.sharedDirector().purgeCachedData()
    }
    
    
    //Re-starts apple-picking game
    func pickAgain() {
        let applePicking = CCBReader.loadAsScene("applePicking")
        CCDirector.sharedDirector().replaceScene(applePicking)
    }
    
    //Replaces current scene with bargaining game
    func goToBargainGame() {
        let bargainGame = CCBReader.loadAsScene("bargainGame")
        CCDirector.sharedDirector().replaceScene(bargainGame)
        removeAllChildrenWithCleanup(true)
    }
   
}
