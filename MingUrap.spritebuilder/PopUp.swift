//
//  PopUp.swift
//  MingUrap
//
//  Created by Abdulrahman AlZanki on 5/6/15, modified by Chris Zhang.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class PopUp: CCNode {
    var curText = 0
    let text = ["Let’s first collect flour from your mill.", "Your neighbor, Austin, has apples in his orchard. We’ll need some to make apple pies.", "Austin: \"Hi there! I have 200 apples, so we can make 200 pies and sell for 2000 gold.\"", "Austin: \"Not so fast though. Let’s decide how we’ll split the 2000 gold first.\"", "Make an offer to Austin. Each offer takes time, causing some apples and 10% of the total earnings to spoil! Initial Amount: 2000"]
    

    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        
        visible = true
        
        setLabelText()
    }

    
    private func setLabelText() {
        if let label = getChildByName("label", recursively: false) as? CCLabelTTF {
            label.string = text[curText]
        }
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if curText < text.count {
            setLabelText()
        } else {
            self.removeFromParentAndCleanup(true)
        }
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        curText++
    }
}