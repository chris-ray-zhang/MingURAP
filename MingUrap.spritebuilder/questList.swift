//
//  questList.swift
//  MingUrap
//
//  Created by Chris Zhang on 6/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class questList: CCNode {
    
    func applePie() {
        let applePicking = CCBReader.loadAsScene("applePicking")
        CCDirector.sharedDirector().pushScene(applePicking)
    }
    
   
}
