//
//  questList.swift
//  MingUrap
//
//  Created by Chris Zhang on 6/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class questList: CCNode {
    
    
    func didLoadFromCCB() {
        if (questWalkThrough.numWalkThroughs == 0) {
            nullifyButtons()
        }
    }
    
    func nullifyButtons() {
        if let back = getChildByName("back", recursively: false) as? CCButton {
            back.userInteractionEnabled = false
        }
        if let deliciousApplePie = getChildByName("deliciousApplePie", recursively: false) as? CCButton {
            deliciousApplePie.userInteractionEnabled = false
        }
        if let farmerDale = getChildByName("farmerDale", recursively: false) as? CCButton {
            farmerDale.userInteractionEnabled = false
        }
        if let greatHarvest = getChildByName("greatHarvest", recursively: false) as? CCButton {
            greatHarvest.userInteractionEnabled = false
        }
    }
    
    func establishButtons() {
        if let deliciousApplePie = getChildByName("deliciousApplePie", recursively: false) as? CCButton {
            deliciousApplePie.userInteractionEnabled = true
        }
    }
    
    
    
    
    //Replaces current scene with apple-picking game
    func applePie() {
        let applePicking = CCBReader.loadAsScene("applePicking")
        let crossFade:CCTransition = CCTransition(crossFadeWithDuration: 1.0)
        CCDirector.sharedDirector().replaceScene(applePicking, withTransition: crossFade)
        
        
    }
    
    //Replaces current scene with DashBoard
    func returnToDashboard() {
        let mainScene = CCBReader.loadAsScene("MainScene")
        let crossFade:CCTransition = CCTransition(crossFadeWithDuration: 1.0)
        CCDirector.sharedDirector().replaceScene(mainScene, withTransition: crossFade)
    }
    
    //Shortcut for testing
    func secret() {
        applePicking.applesPicked = 50
        let applePickingSummary = CCBReader.loadAsScene("applePickingSummary")
        let crossFade:CCTransition = CCTransition(crossFadeWithDuration: 1.0)
        CCDirector.sharedDirector().replaceScene(applePickingSummary, withTransition: crossFade)

    }
    
    override func update(delta: CCTime) {
        if (questWalkThrough.complete) {
            establishButtons()
            questWalkThrough.complete = false
            
        }
        
        
    }

    
    
    
    
   
}
