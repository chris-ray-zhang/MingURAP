//
//  bargainGame.swift
//  MingUrap
//
//  Created by Chris Zhang on 6/3/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class bargainGame: CCNode {
    var percentSuccess = 50
    var curGold = 2000.0
    var reductionPerRound = 0.9
    var gameOver = false
    private var offerObjects : CCNode? = nil
    private var counterOfferObjects : CCNode? = nil
    private var slider : CCSlider? = nil
    var touchEnabled = true
    
    func didLoadFromCCB() {
        offerObjects = getChildByName("offerObjects", recursively: false)
        counterOfferObjects = getChildByName("counterOfferObjects", recursively: false)
        slider = offerObjects?.getChildByName("slider", recursively: false) as? CCSlider
        slider?.sliderValue = 0.5
        
        
        
        showOffer()
    }
    
    private func acceptBid(num : Float) -> Bool {
        println(num)
        if (num > Float(percentSuccess)) {
            return true
        } else {
            return false
        }
    }
    
    func makeOfferTapped() {
        if !gameOver || curGold < 1 {
            if let slider = offerObjects?.getChildByName("slider", recursively: false) as? CCSlider {
                processBid(slider.sliderValue, isCounter: false)
            }
            attemptCounterOffer()
        }
    }
    
    private func processBid(bid : Float, isCounter : Bool) {
        var text = "Bid Accepted"
        var goldRemainingText = "You earned \(Int(curGold) - Int(bid * Float(curGold))) gold." /* changed from 2000 */
        if (!isCounter && !acceptBid(bid * 100)) {
            text = "Bid Denied"
            curGold = curGold * reductionPerRound
            goldRemainingText = "Gold remaining: " + String(Int(curGold))
        } else {
            removeControls()
            gameOver = true
            
        }
        
        if let title = getChildByName("title", recursively: false) as? CCLabelTTF {
            title.string = text
        }
        
        if let goldRemaining = getChildByName("goldRemaining", recursively: false) as? CCLabelTTF {
            goldRemaining.string = goldRemainingText
        }
    }
    
    func showOffer() {
        offerObjects?.visible = true
        counterOfferObjects?.visible = false
    }
    
    func showCounterOffer() {
        offerObjects?.visible = false
        counterOfferObjects?.visible = true
    }
    
    func removeControls() {
        offerObjects?.visible = false
        counterOfferObjects?.visible = false
    }
    
    /* counterOffer in percentage */
    func counterOfferValue() -> Int {
        return 60
    }
    
    func attemptCounterOffer() {
        if (!gameOver) {
            if let title = getChildByName("title", recursively: false) as? CCLabelTTF {
                title.string = "Austin wants " + counterOfferValue().description + "%."
            }
            
            if let labelPerc1 = getChildByName("labelPerc1", recursively: false) as? CCLabelTTF {
                labelPerc1.string = Int(ceil(Double(counterOfferValue())/100 * 100)).description + "%"
            }
            
            if let labelPerc2 = getChildByName("labelPerc2", recursively: false) as? CCLabelTTF {
                labelPerc2.string = Int(floor((1 - Double(counterOfferValue())/100) * 100)).description + "%"
            }
            
            if let coinsAustin1 = getChildByName("coinsAustin", recursively: false) as? CCSprite {
                coinsAustin1.scaleY = Float(Double(counterOfferValue())/100)/3
            }
            
            if let coinsYou1 = getChildByName("coinsYou", recursively: false) as? CCSprite {
                coinsYou1.scaleY = Float(1 - (Double(counterOfferValue())/100))/3
            }
            
            if let numCoinsYou = getChildByName("numCoinsYou", recursively: false) as? CCLabelTTF {
                numCoinsYou.string = String(stringInterpolationSegment: Int(curGold) - Int(curGold * Double(counterOfferValue())/100))
            }
            
            if let numCoinsAustin = getChildByName("numCoinsAustin", recursively: false) as? CCLabelTTF {
                numCoinsAustin.string = String(stringInterpolationSegment: Int(curGold * Double(counterOfferValue())/100))
            }
            
            showCounterOffer()
        }
    }
    
    func rejectedCounterOffer() {
        if let title = getChildByName("title", recursively: false) as? CCLabelTTF {
            title.string = "Make a bid"
        }
        
        curGold = curGold * reductionPerRound
        if let goldRemaining = getChildByName("goldRemaining", recursively: false) as? CCLabelTTF {
            goldRemaining.string = "Gold remaining: " + String(Int(curGold))
        }
        showOffer()
    }
    
    func acceptedCounterOffer() {
        // THIS VALUE SHOULD BE CHANGED
        processBid(0.6, isCounter: false)
        if (!gameOver) {
            showOffer()
        }
    }
    
    override func update(delta: CCTime) {
        if (!counterOfferObjects!.visible && !gameOver) {
            if let labelPerc1 = getChildByName("labelPerc1", recursively: false) as? CCLabelTTF {
                labelPerc1.string = Int(ceil(slider!.sliderValue * 100)).description + "%"
            }
            
            if let labelPerc2 = getChildByName("labelPerc2", recursively: false) as? CCLabelTTF {
                labelPerc2.string = Int(floor((1 - slider!.sliderValue) * 100)).description + "%"
            }
            
            if let coinsAustin = getChildByName("coinsAustin", recursively: false) as? CCSprite {
                coinsAustin.scaleY = Float(slider!.sliderValue/3)
            }
            
            if let coinsYou = getChildByName("coinsYou", recursively: false) as? CCSprite {
                coinsYou.scaleY = Float((1 - slider!.sliderValue)/3)
            }
            
            if let numCoinsYou = getChildByName("numCoinsYou", recursively: false) as? CCLabelTTF {
                numCoinsYou.string = String(stringInterpolationSegment: Int(curGold) - Int(Float(curGold) * slider!.sliderValue))
            }
            
            if let numCoinsAustin = getChildByName("numCoinsAustin", recursively: false) as? CCLabelTTF {
                numCoinsAustin.string = String(stringInterpolationSegment: Int(Float(curGold) * slider!.sliderValue))
            }
            
        }
        
        
    }

   
}
