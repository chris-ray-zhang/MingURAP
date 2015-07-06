//
//  questList.swift
//  MingUrap
//
//  Created by Chris Zhang on 6/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class questList: CCNode {
    
    //Replaces current scene with apple-picking game
    func applePie() {
        let applePicking = CCBReader.loadAsScene("applePicking")
        CCDirector.sharedDirector().replaceScene(applePicking)
    }
    
    //Replaces current scene with DashBoard
    func returnToDashboard() {
        let mainScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(mainScene)
    }
    
    //Shortcut for testing
    func secret() {
        applePicking.applesPicked = 1000
        let bargainGame = CCBReader.loadAsScene("applePickingSummary")
        CCDirector.sharedDirector().replaceScene(bargainGame)

    }
    
    override func onExit() {
        
        removeAllChildrenWithCleanup(true)
    }
    
   
}
