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
    private var austinTimer = NSTimer()
    var moviePlayer : MPMoviePlayerController?
    var player: AVAudioPlayer! = nil
    var touchEnabled = true
    var myLabel: UILabel?
    
    
    override func onExit() {
        CCDirector.sharedDirector().purgeCachedData()
        removeAllChildrenWithCleanup(true)
    }
    
    //Replaces current scene with Dashboard and adds earnings from bargaining game to DashBoard
    func complete() {
        /*
        CCDirector.sharedDirector().purgeCachedData()
        
        

        */
        var currentScene = CCDirector.sharedDirector().runningScene
        var mainScene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(mainScene)
        mainScene = nil
        currentScene = nil
        MainScene.totalAssets += earnings
    }
    
    func applicationDidReceiveMemoryWarning(application: UIApplication) {
        
    }
    
    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if (moviePlayer?.playbackState == MPMoviePlaybackState.Playing) {
            completeDeal?.visible = true
            moviePlayer?.view.removeFromSuperview()
            moviePlayer!.stop()
            myLabel!.removeFromSuperview()
        }
        
    }
    
    /* Credit to http://stackoverflow.com/questions/25348877/how-to-play-a-local-video-with-swift */
    private func playVideo(filename:String) {
        let path = NSBundle.mainBundle().pathForResource(filename, ofType:"mov")
        let url = NSURL(fileURLWithPath: path!)
        /*
        let moviePlayer = MPMoviePlayerController(contentURL: url)
        */
        moviePlayer = MPMoviePlayerController(contentURL: url)
        moviePlayer!.prepareToPlay()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "moviePlayerDidFinishPlaying:" , name: MPMoviePlayerPlaybackDidFinishNotification, object: moviePlayer)
        var winSize: CGSize = CCDirector.sharedDirector().viewSize()
        moviePlayer!.view.frame = CGRectMake(0,0, winSize.width, winSize.height)
        /*
        self.moviePlayer = moviePlayer
        */
        moviePlayer!.scalingMode = .AspectFill
        moviePlayer!.shouldAutoplay = true
        moviePlayer!.controlStyle = MPMovieControlStyle.None
        CCDirector.sharedDirector().view.addSubview(moviePlayer!.view)
        myLabel = UILabel(frame: CGRectMake((winSize.width / 2 ) - (80),0,260,50))
        myLabel!.textColor = UIColor.blackColor()
        myLabel!.font = UIFont (name: "MarkerFelt-Wide", size: 24)
        myLabel!.text = "Tap to Skip Video"
        CCDirector.sharedDirector().view.addSubview(myLabel!)
        moviePlayer!.play()

    }
    
    /* Credit to http://stackoverflow.com/questions/26650173/playing-a-movie-with-mpmovieplayercontroller-and-swift */
    func moviePlayerDidFinishPlaying(notification: NSNotification) {
        moviePlayer?.view.removeFromSuperview()
        myLabel!.removeFromSuperview()
    }
    
    func didLoadFromCCB() {
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
        
        showOffer()
    }
    
    private func acceptBid(num : Float) -> Bool {
        if (num > Float(percentSuccess)) {
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
                oldCS.visible = false
            }
            if let newCS = getChildByName(newCoinStack, recursively: false) as? CCSprite {
                newCS.visible = true
            }
        }
        
    }
    
    func makeOfferTapped() {
        if !gameOver || bargainGame.curGold < 1 {
            if let slider = offerObjects?.getChildByName("slider", recursively: false) as? CCSlider {
                processBid(slider.sliderValue, isCounter: false)
            }
            attemptCounterOffer()
            prepareSound("lossOfCoins")
            self.scheduleOnce(Selector("displayCoinStack"), delay: 1.0)
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
            prepareSound("coinNoises")
            gameOver = true
            earnings = Int(bargainGame.curGold) - Int(bid * Float(bargainGame.curGold))
            if let earningsLabel = completeDeal?.getChildByName("earningsLabel", recursively: false) as? CCLabelTTF {
                earningsLabel.string = "You Earned $" + earnings.description
            }
            completeDeal?.visible = true
            
            playVideo("pieStand")
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
        slider!.sliderValue = 0.5
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
        homeButton?.visible = true
    }
    
    /** Counteroffer as a percentage, given as +/- 2 **/
    //-> Int
    func counterOfferValue()  {
        aiCounterOffer = Int((1.0 / (1.0 + reductionPerRound)) * 100) + Int(arc4random_uniform(4)) - 2
        
        //return aiCounterOffer +
    }
    
    //Sets up Austin's timer to 5 seconds
    func setupAustinTimer() {
        austinTime = 5
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
        if (austinTime == 0) {
            austinTimer.invalidate()
            counterOfferValue()
            
            
            if let title = getChildByName("title", recursively: false) as? CCLabelTTF {
                title.string = "Austin wants " + aiCounterOffer.description + "%."
            }
            
            if let labelPerc1 = getChildByName("labelPerc1", recursively: false) as? CCLabelTTF {
                labelPerc1.visible = true
                labelPerc1.string = Int(ceil(Double(aiCounterOffer)/100 * 100)).description + "%"
                
            }
            
            if let labelPerc2 = getChildByName("labelPerc2", recursively: false) as? CCLabelTTF {
                labelPerc2.visible = true
                labelPerc2.string = Int(floor((1 - Double(aiCounterOffer)/100) * 100)).description + "%"
            }
            
            if let numCoinsYou = getChildByName("numCoinsYou", recursively: false) as? CCLabelTTF {
                numCoinsYou.visible = true
                numCoinsYou.string = String(stringInterpolationSegment: Int(bargainGame.curGold) - Int(bargainGame.curGold * Double(aiCounterOffer)/100))
            }
            
            if let numCoinsAustin = getChildByName("numCoinsAustin", recursively: false) as? CCLabelTTF {
                numCoinsAustin.visible = true
                numCoinsAustin.string = String(stringInterpolationSegment: Int(bargainGame.curGold * Double(aiCounterOffer)/100))
            }
            showCounterOffer()
        }
    }
    
    func attemptCounterOffer() {
        if (!gameOver) {
            removeControls()
            setupAustinTimer()
        }
    }
    
    func rejectedCounterOffer() {
        prepareSound("lossOfCoins")
        self.scheduleOnce(Selector("displayCoinStack"), delay: 1.0)
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
        processBid(Float(aiCounterOffer)/100, isCounter: false) //* changed from 0.6 //*
        if (!gameOver) {
            showOffer()
        }
    }
    
    //Credit to http://stackoverflow.com/questions/24393495/playing-a-sound-with-avaudioplayer-swift
    func prepareSound(filename:String) {
        let path = NSBundle.mainBundle().pathForResource(filename, ofType:"aif")
        let fileURL = NSURL(fileURLWithPath: path!)
        player = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
        player.volume = 1.5
        player.prepareToPlay()
        player.play()
    }
    
    override func update(delta: CCTime) {
        if (!gameOver && !counterOfferObjectsVisible ) {
            if let labelPerc1 = getChildByName("labelPerc1", recursively: false) as? CCLabelTTF {
                labelPerc1.string = Int(ceil(slider!.sliderValue * 100)).description + "%"
            }
            
            if let labelPerc2 = getChildByName("labelPerc2", recursively: false) as? CCLabelTTF {
                labelPerc2.string = Int(floor((1 - slider!.sliderValue) * 100)).description + "%"
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
