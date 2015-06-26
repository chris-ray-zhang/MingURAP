//
//  applePickingSummary.swift
//  MingUrap
//
//  Created by Chris Zhang on 6/23/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class applePickingSummary: CCNode {
    
    
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
