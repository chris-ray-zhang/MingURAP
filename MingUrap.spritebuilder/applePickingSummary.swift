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
    
    
    //Re-starts apple-picking game
    func pickAgain() {
        let applePicking = CCBReader.loadAsScene("applePicking")
        var directionalSceneTransition = CCTransition(pushWithDirection: CCTransitionDirection.Left, duration: 0.5)
        CCDirector.sharedDirector().replaceScene(applePicking, withTransition: directionalSceneTransition)
    }
    
    //Replaces current scene with bargaining game
    func goToBargainGame() {
        var bargainGame = CCBReader.loadAsScene("bargainGame")
        var revealTransition = CCTransition(revealWithDirection: CCTransitionDirection.Up, duration: 1.0)
        CCDirector.sharedDirector().replaceScene(bargainGame, withTransition: revealTransition)
        
    }
   
}
