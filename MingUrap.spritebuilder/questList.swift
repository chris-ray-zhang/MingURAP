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
        var crossFade:CCTransition = CCTransition(crossFadeWithDuration: 1.0)
        CCDirector.sharedDirector().replaceScene(applePicking, withTransition: crossFade)
        
        
    }
    
    //Replaces current scene with DashBoard
    func returnToDashboard() {
        let mainScene = CCBReader.loadAsScene("MainScene")
        var crossFade:CCTransition = CCTransition(crossFadeWithDuration: 1.0)
        CCDirector.sharedDirector().replaceScene(mainScene, withTransition: crossFade)
    }
    
    //Shortcut for testing
    func secret() {
        applePicking.applesPicked = 50
        let applePickingSummary = CCBReader.loadAsScene("applePickingSummary")
        var crossFade:CCTransition = CCTransition(crossFadeWithDuration: 1.0)
        CCDirector.sharedDirector().replaceScene(applePickingSummary, withTransition: crossFade)

    }
    
    
   
}
