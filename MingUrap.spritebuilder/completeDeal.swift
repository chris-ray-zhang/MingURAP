//
//  completeDeal.swift
//  MingUrap
//
//  Created by Chris Zhang on 6/10/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit


class completeDeal: CCNode {
   
    
    func complete() {
        /*
        let mainScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(mainScene)
        */
        println("completing")
        CCDirector.sharedDirector().popScene()
    }
    
    
    
}

