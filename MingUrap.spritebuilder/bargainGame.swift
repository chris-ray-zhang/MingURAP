//
//  bargainGame.swift
//  MingUrap
//
//  Created by Abdulrahman AlZanki on 5/6/15, modified by Chris Zhang.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit
import MediaPlayer

class bargainGame: CCNode {
    var percentSuccess = 50
    static var curGold = 0.0
    var reductionPerRound = 0.9
    var gameOver = false
    var earnings = 0
    private var offerObjects : CCNode? = nil
    private var completeDeal : CCNode? = nil
    private var counterOfferObjects : CCNode? = nil
    private var slider : CCSlider? = nil
    private var homeButton : CCButton? = nil
    private var counterOfferObjectsVisible = false
    var moviePlayer : MPMoviePlayerController?
    var touchEnabled = true
    
    func complete() {
        
        let mainScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().presentScene(mainScene)

        /*
        CCDirector.sharedDirector().popToRootScene()
        MainScene.totalAssets += earnings
        */
    }
    
    

    
    /* Credit to http://stackoverflow.com/questions/25348877/how-to-play-a-local-video-with-swift */
    private func playVideo() {
        let path = NSBundle.mainBundle().pathForResource("pieStand", ofType:"mov")
        let url = NSURL(fileURLWithPath: path!)
        let moviePlayer = MPMoviePlayerController(contentURL: url)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayerDidFinishPlaying:" , name: MPMoviePlayerPlaybackDidFinishNotification, object: moviePlayer)
        var winSize: CGSize = CCDirector.sharedDirector().viewSize()
        moviePlayer.view.frame = CGRectMake(0,0, winSize.width, winSize.height)
        self.moviePlayer = moviePlayer
        moviePlayer.scalingMode = .AspectFill
        CCDirector.sharedDirector().view.addSubview(moviePlayer.view)
        moviePlayer.shouldAutoplay = true
        moviePlayer.prepareToPlay()
        moviePlayer.play()

    }
    
    /* Credit to http://stackoverflow.com/questions/26650173/playing-a-movie-with-mpmovieplayercontroller-and-swift */
    func moviePlayerDidFinishPlaying(notification: NSNotification) {
        moviePlayer?.view.removeFromSuperview()
  
    }
    
    func didLoadFromCCB() {
        offerObjects = getChildByName("offerObjects", recursively: false)
        counterOfferObjects = getChildByName("counterOfferObjects", recursively: false)
        slider = offerObjects?.getChildByName("slider", recursively: false) as? CCSlider
        homeButton = getChildByName("homeButton", recursively: false) as? CCButton
        slider?.sliderValue = 0.5
        completeDeal = getChildByName("completeDeal", recursively: false)
        if let goldRemaining = getChildByName("goldRemaining", recursively: false) as? CCLabelTTF {
            goldRemaining.string = "Gold Remaining: " + Int(bargainGame.curGold).description
        }
        showOffer()
    }
    
    private func acceptBid(num : Float) -> Bool {
        if (num > Float(percentSuccess)) {
            return true
        } else {
            return false
        }
    }
    
    func makeOfferTapped() {
        if !gameOver || bargainGame.curGold < 1 {
            if let slider = offerObjects?.getChildByName("slider", recursively: false) as? CCSlider {
                processBid(slider.sliderValue, isCounter: false)
            }
            attemptCounterOffer()
        }
    }
    
    private func processBid(bid : Float, isCounter : Bool) {
        var text = "Bid Accepted"
        var goldRemainingText = "You earned \(Int(bargainGame.curGold) - Int(bid * Float(bargainGame.curGold))) gold." /* changed from 2000 */
        if (!isCounter && !acceptBid(bid * 100)) {
            text = "Bid Denied"
            bargainGame.curGold = bargainGame.curGold * reductionPerRound
            goldRemainingText = "Gold remaining: " + String(Int(bargainGame.curGold))
        } else {
            gameOver = true
            earnings = Int(bargainGame.curGold) - Int(bid * Float(bargainGame.curGold))
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setInteger(earnings, forKey: "bargainGameEarnings")
            if let earningsLabel = completeDeal?.getChildByName("earningsLabel", recursively: false) as? CCLabelTTF {
                earningsLabel.string = "You Earned $" + earnings.description
            }
            completeDeal?.visible = true
            
            playVideo()
            
            
            
            
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
        counterOfferObjectsVisible = false
    }
    
    func showCounterOffer() {
        offerObjects?.visible = false
        counterOfferObjects?.visible = true
        counterOfferObjectsVisible = true
    }
    
    func removeControls() {
        offerObjects?.visible = false
        counterOfferObjects?.visible = false
        counterOfferObjectsVisible = false
        homeButton?.visible = true
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
                numCoinsYou.string = String(stringInterpolationSegment: Int(bargainGame.curGold) - Int(bargainGame.curGold * Double(counterOfferValue())/100))
            }
            
            if let numCoinsAustin = getChildByName("numCoinsAustin", recursively: false) as? CCLabelTTF {
                numCoinsAustin.string = String(stringInterpolationSegment: Int(bargainGame.curGold * Double(counterOfferValue())/100))
            }
            
            
            showCounterOffer()
        }
    }
    
    func rejectedCounterOffer() {
        if let title = getChildByName("title", recursively: false) as? CCLabelTTF {
            title.string = "Make a bid"
        }
        
        bargainGame.curGold = bargainGame.curGold * reductionPerRound
        if let goldRemaining = getChildByName("goldRemaining", recursively: false) as? CCLabelTTF {
            goldRemaining.string = "Gold remaining: " + String(Int(bargainGame.curGold))
        }
        showOffer()
    }
    
    func acceptedCounterOffer() {
        // THIS VALUE SHOULD BE CHANGED
        processBid(0.6, isCounter: false) //* changed from 0.6 //*
        if (!gameOver) {
            showOffer()
        }
    }
    
    override func update(delta: CCTime) {
        /*!counterOfferObjects!.visible */
        if (!gameOver && !counterOfferObjectsVisible ) {
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
                numCoinsYou.string = String(stringInterpolationSegment: Int(bargainGame.curGold) - Int(Float(bargainGame.curGold) * slider!.sliderValue))
            }
            
            if let numCoinsAustin = getChildByName("numCoinsAustin", recursively: false) as? CCLabelTTF {
                numCoinsAustin.string = String(stringInterpolationSegment: Int(Float(bargainGame.curGold) * slider!.sliderValue))
            }
            
        }
        
        
    }

   
}
