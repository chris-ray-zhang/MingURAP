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
        if (applePicking.applesPicked < 5) {
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
        else if let title = getChildByName("title", recursively: false) as? CCLabelTTF {
            title.string = "\(applePicking.applesPicked) Juicy Apples Picked!"
        }
    }
    
    
    override func onExit() {
        /*
        CCDirector.sharedDirector().purgeCachedData()
        */
    }
    
    
    //Re-starts apple-picking game
    func pickAgain() {
        var applePicking = CCBReader.loadAsScene("applePicking")
        CCDirector.sharedDirector().replaceScene(applePicking)
        applePicking = nil
    }
    
    //Replaces current scene with bargaining game
    func goToBargainGame() {
        
        var currentScene = CCDirector.sharedDirector().runningScene
        var bargainGame = CCBReader.loadAsScene("bargainGame")
        CCDirector.sharedDirector().replaceScene(bargainGame)
        bargainGame = nil
        currentScene = nil
        /*
        
        removeAllChildrenWithCleanup(true)
        
        */
    }
   
}
