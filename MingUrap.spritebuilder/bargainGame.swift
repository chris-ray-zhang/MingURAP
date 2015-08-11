//
//  bargainGame.swift
//  MingUrap
//
//  Created by Abdulrahman AlZanki on 5/6/15, modified by Chris Zhang.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit
import MediaPlayer
import CoreData


class bargainGame: CCNode {
    var percentSuccess = 50
    static var curGold = 0.0
    var reductionPerRound = 0.9
    // 1/(1+reductionPerRound) * 100 is default counteroffer percentage
    var aiCounterOffer = Int((1.0 / (1.0 + 0.9)) * 100)
    var gameOver = false
    var earnings = 0
    var numOffers = 1
    private weak var offerObjects : CCNode? = nil
    private weak var completeDeal : CCNode? = nil
    private weak var counterOfferObjects : CCNode? = nil
    private weak var slider : CCSlider? = nil
    private weak var homeButton : CCButton? = nil
    private var counterOfferObjectsVisible = false
    private var numExchanges = 0
    private var austinTime = 0
    private var hasRejected = false;
    private var austinTimer = NSTimer()
    var moviePlayer : MPMoviePlayerController?
    var player: OALSimpleAudio! = nil
    var myLabel: UILabel?
    var isMusicPlaying = applePicking.isMusicPlaying
    
    
    func didLoadFromCCB() {
        if (!isMusicPlaying) {
            if let mute = getChildByName("mute", recursively: false) as? CCButton {
                mute.title = "Unmute"
            }
        }
        player = OALSimpleAudio.sharedInstance()
        player.playEffect("farmGameBargainingMusic.mp3", volume: 0.25, pitch: 1.0, pan: 0.0, loop: true)
        self.userInteractionEnabled = true
        offerObjects = getChildByName("offerObjects", recursively: false)
        counterOfferObjects = getChildByName("counterOfferObjects", recursively: false)
        slider = offerObjects?.getChildByName("slider", recursively: false) as? CCSlider
        homeButton = getChildByName("homeButton", recursively: false) as? CCButton
        slider?.sliderValue = 0.5
        completeDeal = getChildByName("completeDeal", recursively: false)
        if let goldRemaining = getChildByName("goldRemaining", recursively: false) as? CCLabelTTF {
            goldRemaining.string = "Gold Remaining: " + Int(bargainGame.curGold).description
        }
        percentSuccess = Int((1.0 / (1.0 + reductionPerRound)) * 100) - 2
        showOffer()
    }
    
    //Replaces current scene with Dashboard and adds earnings from bargaining game to DashBoard
    func complete() {
        MainScene.totalAssets += earnings
        var mainScene = CCBReader.loadAsScene("MainScene")
        var crossFade:CCTransition = CCTransition(crossFadeWithDuration: 1.0)
        CCDirector.sharedDirector().replaceScene(mainScene, withTransition: crossFade)
        self.scheduleOnce(Selector("updateAssets"), delay: 2.0)
        
    }
    
    
    
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if (moviePlayer?.playbackState == MPMoviePlaybackState.Playing) {
            moviePlayer?.view.removeFromSuperview()
            moviePlayer?.stop()
            myLabel!.removeFromSuperview()
        }

    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if (moviePlayer?.playbackState == MPMoviePlaybackState.Playing) {
            completeDeal?.visible = true
            /*
            moviePlayer?.view.removeFromSuperview()
            moviePlayer?.stop()
            myLabel!.removeFromSuperview()
            */
        }
        
    }
    
    
    /* Credit to http://stackoverflow.com/questions/25348877/how-to-play-a-local-video-with-swift */
    private func playVideo(filename:String) {
        let path = NSBundle.mainBundle().pathForResource(filename, ofType:"mov")
        let url = NSURL(fileURLWithPath: path!)
        moviePlayer = MPMoviePlayerController(contentURL: url)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayerDidFinishPlaying:" , name: MPMoviePlayerPlaybackDidFinishNotification, object: moviePlayer)
        var winSize: CGSize = CCDirector.sharedDirector().viewSize()
        moviePlayer?.view.frame = CGRectMake(0,0, winSize.width, winSize.height)
        moviePlayer?.scalingMode = .AspectFill
        moviePlayer?.shouldAutoplay = false //* changed to false *//
        moviePlayer?.controlStyle = MPMovieControlStyle.None
        CCDirector.sharedDirector().view.addSubview(moviePlayer!.view)
        myLabel = UILabel(frame: CGRectMake((winSize.width / 2 ) - (80),0,260,50))
        myLabel!.textColor = UIColor.blackColor()
        myLabel!.font = UIFont (name: "MarkerFelt-Wide", size: 24)
        myLabel!.text = "Tap to Skip Video"
        CCDirector.sharedDirector().view.addSubview(myLabel!)
        moviePlayer?.prepareToPlay()
    }
    
    
    /* Credit to http://stackoverflow.com/questions/26650173/playing-a-movie-with-mpmovieplayercontroller-and-swift */
    func moviePlayerDidFinishPlaying(notification: NSNotification) {
        moviePlayer?.view.removeFromSuperview()
        myLabel!.removeFromSuperview()
    }
    
    
    
    private func acceptBid(num : Float) -> Bool {
        //num >= Float(percentSuccess
        if (num >= Float(percentSuccess)) {
            return true
        } else {
            return false
        }
    }
    
    func displayCoinStack() {
        let oldCoinStack = "coinStack" + numOffers.description
        numOffers++
        let newCoinStack = "coinStack" + numOffers.description
        if (numOffers < 7) {
            if let oldCS = getChildByName(oldCoinStack, recursively: false) as? CCSprite {
                let fadeOut: CCActionFadeOut = CCActionFadeOut.actionWithDuration(0.5) as! CCActionFadeOut
                oldCS.runAction(fadeOut)
            }
            if let newCS = getChildByName(newCoinStack, recursively: false) as? CCSprite {
                newCS.visible = true
                let fadeIn: CCActionFadeIn = CCActionFadeIn.actionWithDuration(0.5) as! CCActionFadeIn
                newCS.runAction(fadeIn)
            }
        }
        
    }
    
    func makeOfferTapped() {
        if !gameOver || bargainGame.curGold < 1 {
            if let slider = offerObjects?.getChildByName("slider", recursively: false) as? CCSlider {
                processBid(1 - slider.sliderValue, isCounter: false)
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
            if let title = getChildByName("title", recursively: false) as? CCLabelTTF {
                title.string = text
            }
        } else {
            player!.effectsPaused = true
            let audio = OALSimpleAudio.sharedInstance()
            audio.playEffect("coinNoises.aif", volume: 3.0, pitch: 1.0, pan: 0.0, loop: false)
            removeControls()
            gameOver = true
            earnings = Int(bargainGame.curGold) - Int(bid * Float(bargainGame.curGold))
            if let belowTitle = getChildByName("belowTitle", recursively: false) as? CCLabelTTF {
                belowTitle.string = "Split is \(Int(ceil(bid * 100))) / \(Int(floor((1 - bid) * 100)))"
            }
            if let title = getChildByName("title", recursively: false) as? CCLabelTTF {
                title.string = "A Deal was Struck!"
            }
            if let dealStruck = getChildByName("dealStruck", recursively: false) as? CCButton {
                dealStruck.visible = true
            }
            
        }
        
        
        
        if let goldRemaining = getChildByName("goldRemaining", recursively: false) as? CCLabelTTF {
            goldRemaining.string = goldRemainingText
        }
    }
    
    func dealStruck() {
        if let dealStruck = getChildByName("dealStruck", recursively: false) as? CCButton {
            dealStruck.visible = false
        }
        if let earningsLabel = completeDeal?.getChildByName("earningsLabel", recursively: false) as? CCLabelTTF {
            earningsLabel.string = "You Earned $" + earnings.description
        }
        completeDeal?.visible = true
        playVideo("pieStand")
        moviePlayer?.play()
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
        if let labelPerc1 = getChildByName("labelPerc1", recursively: false) as? CCLabelTTF {
            labelPerc1.visible = false
        }
        
        if let labelPerc2 = getChildByName("labelPerc2", recursively: false) as? CCLabelTTF {
            labelPerc2.visible = false
        }
        
        
        if let numCoinsYou = getChildByName("numCoinsYou", recursively: false) as? CCLabelTTF {
            numCoinsYou.visible = false
        }
        
        if let numCoinsAustin = getChildByName("numCoinsAustin", recursively: false) as? CCLabelTTF {
            numCoinsAustin.visible = false
        }
        if let mute = getChildByName("mute", recursively: false) as? CCButton {
            mute.visible = false
        }
        homeButton?.visible = true
    }
    
    /** Counteroffer as a percentage, given as +/- 2 **/
    //-> Int
    func counterOfferValue()  {
        aiCounterOffer = Int((1.0 / (1.0 + reductionPerRound)) * 100) + Int(arc4random_uniform(4)) - 2
        
        //return aiCounterOffer +
    }
    
    //Sets up Austin's timer to 3 seconds
    func setupAustinTimer() {
        austinTime = 3
        if let austinTimeLeft = getChildByName("title", recursively: false) as? CCLabelTTF {
            austinTimeLeft.string = "Austin's Thinking: \(austinTime)"
        }
        austinTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractAustinTime"), userInfo: nil, repeats: true)
    }
    
   
    
    func subtractAustinTime() {
        austinTime--
        if let austinTimeLeft = getChildByName("title", recursively: false) as? CCLabelTTF {
            austinTimeLeft.string = "Austin's Thinking: \(austinTime)"
        }
        if (hasRejected == false && austinTime < 2) {
            hasRejected = true
            austinTime = 1
            if let title = getChildByName("title", recursively: false) as? CCLabelTTF {
                title.string = "Apples have gone bad"
            }
        }
        if (austinTime == 0) {
            austinTimer.invalidate()
            counterOfferValue()
            
            if let belowTitle = getChildByName("belowTitle", recursively: false) as? CCLabelTTF {
                belowTitle.string = ""
            }
            if let title = getChildByName("title", recursively: false) as? CCLabelTTF {
                title.string = "He wants " + aiCounterOffer.description + "%."
            }
            
            if let labelPerc2 = getChildByName("labelPerc2", recursively: false) as? CCLabelTTF {
                labelPerc2.visible = true
                labelPerc2.string = Int(ceil(Double(aiCounterOffer)/100 * 100)).description + "%"
                
            }
            
            if let labelPerc1 = getChildByName("labelPerc1", recursively: false) as? CCLabelTTF {
                labelPerc1.visible = true
                labelPerc1.string = Int(floor((1 - Double(aiCounterOffer)/100) * 100)).description + "%"
            }
            
            if let numCoinsAustin = getChildByName("numCoinsAustin", recursively: false) as? CCLabelTTF {
                numCoinsAustin.visible = true
                numCoinsAustin.string = String(stringInterpolationSegment: Int(bargainGame.curGold) - Int(bargainGame.curGold * Double(aiCounterOffer)/100))
            }
            
            if let numCoinsYou = getChildByName("numCoinsYou", recursively: false) as? CCLabelTTF {
                numCoinsYou.visible = true
                numCoinsYou.string = String(stringInterpolationSegment: Int(bargainGame.curGold * Double(aiCounterOffer)/100))
            }
            showCounterOffer()
        }
    }
    
    func attemptCounterOffer() {
        if (!gameOver) {
            removeControls()
            if let title = getChildByName("title", recursively: false) as? CCLabelTTF {
                title.string = "Austin REJECTS"
            }
            let audio = OALSimpleAudio.sharedInstance()
            audio.playEffect("lossOfCoins.aif", volume: 3.0, pitch: 1.0, pan: 0.0, loop: false)
            self.scheduleOnce(Selector("displayCoinStack"), delay: 1.0)
            self.scheduleOnce(Selector("setupAustinTimer"), delay: 3.0)
            //setupAustinTimer()
        }
    }
    
    func changeScreen() {
        if let title = getChildByName("title", recursively: false) as? CCLabelTTF {
            title.string = "Make a bid"
        }
        if let belowTitle = getChildByName("belowTitle", recursively: false) as? CCLabelTTF {
            belowTitle.string = ""
        }
        bargainGame.curGold = bargainGame.curGold * reductionPerRound
        if let goldRemaining = getChildByName("goldRemaining", recursively: false) as? CCLabelTTF {
            goldRemaining.string = "Gold remaining: " + String(Int(bargainGame.curGold))
        }
        showOffer()
    }
    
    func rejectedCounterOffer() {
        let audio = OALSimpleAudio.sharedInstance()
        audio.playEffect("lossOfCoins.aif", volume: 3.0, pitch: 1.0, pan: 0.0, loop: false)
        if let slider = offerObjects?.getChildByName("slider", recursively: false) as? CCSlider {
            slider.sliderValue = 0.5
        }
        self.scheduleOnce(Selector("displayCoinStack"), delay: 1.0)
        self.scheduleOnce(Selector("changeScreen"), delay: 2.0)
    }
    
    func acceptedCounterOffer() {
        // THIS VALUE SHOULD BE CHANGED
        processBid(Float(aiCounterOffer)/100, isCounter: false) //* changed from 0.6 //*
        if (!gameOver) {
            showOffer()
        }
    }
    
    func mute() {
        if (isMusicPlaying) {
            if let mute = getChildByName("mute", recursively: false) as? CCButton {
                mute.title = "Unmute"
            }
            player.effectsMuted = true
        } else {
            if let mute = getChildByName("mute", recursively: false) as? CCButton {
                mute.title = "Mute"
            }
            player.effectsMuted = false
        }
        isMusicPlaying = !isMusicPlaying
        
    }
    
    //Credit to http://stackoverflow.com/questions/24393495/playing-a-sound-with-avaudioplayer-swift
    func prepareSound(filename:String) {
        /*
        let path = NSBundle.mainBundle().pathForResource(filename, ofType:"aif")
        let fileURL = NSURL(fileURLWithPath: path!)
        player = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
        player.volume = 1.5
        player.prepareToPlay()
        player.play()
        */
        
        let audio = OALSimpleAudio.sharedInstance()
        audio.playEffect("\(filename).aif", volume: 1.5, pitch: 1.0, pan: 0.0, loop: false)
        
        
    }
    
    override func update(delta: CCTime) {
        if (!gameOver && !counterOfferObjectsVisible ) {
            if let labelPerc2 = getChildByName("labelPerc2", recursively: false) as? CCLabelTTF {
                labelPerc2.string = Int(ceil(slider!.sliderValue * 100)).description + "%"
            }
            
            if let labelPerc1 = getChildByName("labelPerc1", recursively: false) as? CCLabelTTF {
                labelPerc1.string = Int(floor((1 - slider!.sliderValue) * 100)).description + "%"
            }
            
            
            if let numCoinsAustin = getChildByName("numCoinsAustin", recursively: false) as? CCLabelTTF {
                numCoinsAustin.string = String(stringInterpolationSegment: Int(bargainGame.curGold) - Int(Float(bargainGame.curGold) * slider!.sliderValue))
            }
            
            if let numCoinsYou = getChildByName("numCoinsYou", recursively: false) as? CCLabelTTF {
                numCoinsYou.string = String(stringInterpolationSegment: Int(Float(bargainGame.curGold) * slider!.sliderValue))
            }
            
        }
        
        
    }

   
}
