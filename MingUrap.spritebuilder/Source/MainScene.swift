import Foundation
import MediaPlayer
import AVFoundation
import Parse



class MainScene: CCNode {
    
    static var totalAssets = 100
    
    private var chickenCost = -200
    private var cowCost = -2400
    private var tractorCost = -6000
    private var waterTowerCost = -10000
    private var chickenCounter = 0
    private var cowCounter = 0
    private var tractorCounter = 0
    private var waterTowerCounter = 0
    private var player: AVAudioPlayer! = nil
    
    func didLoadFromCCB() {
        prepareSound("chime")
        /*
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            println("Object has been saved.")
        }
        */
        let totalMoney = PFObject(className:"totalMoney")
        totalMoney["money"] = MainScene.totalAssets
        totalMoney.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
    }
    
    func buyChicken() {
        if (MainScene.totalAssets + chickenCost >= 0) {
            prepareSound("chicken")
            updateTotalAssets(chickenCost)
            chickenCounter++
            if let numChicken = getChildByName("numChicken", recursively: false) as? CCLabelTTF {
                numChicken.string = chickenCounter.description
            }
        }
        
    }
    
    func buyCow() {
        if (MainScene.totalAssets + cowCost >= 0) {
            prepareSound("cowMoo")
            updateTotalAssets(cowCost)
            cowCounter++
            if let numCow = getChildByName("numCow", recursively: false) as? CCLabelTTF {
                numCow.string = cowCounter.description
            }
        }
        
    }
    
    func buyTractor() {
        if (MainScene.totalAssets + tractorCost >= 0) {
            updateTotalAssets(tractorCost)
            tractorCounter++
            if let numTractor = getChildByName("numTractor", recursively: false) as? CCLabelTTF {
                numTractor.string = tractorCounter.description
            }
        }
        
    }
    
    func buyWaterTower() {
        if (MainScene.totalAssets + waterTowerCost >= 0) {
            updateTotalAssets(waterTowerCost)
            waterTowerCounter++
            if let numWaterTower = getChildByName("numWaterTower", recursively: false) as? CCLabelTTF {
                numWaterTower.string = waterTowerCounter.description
            }
        }
    }
    
    func updateTotalAssets(amount: Int) {
        MainScene.totalAssets += amount
        if let totalAssetsLabel = getChildByName("totalAssetsLabel", recursively: false) as? CCLabelTTF {
            totalAssetsLabel.string = "$" + MainScene.totalAssets.description
        }
        
    }
    
    
    //Credit to http://stackoverflow.com/questions/24393495/playing-a-sound-with-avaudioplayer-swift
    func prepareSound(nameOfFile: String) {
        /*
        let path = NSBundle.mainBundle().pathForResource(nameOfFile, ofType:"aif")
        let fileURL = NSURL(fileURLWithPath: path!)
        player = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
        player.prepareToPlay()
        player.play()
        */
        let audio = OALSimpleAudio.sharedInstance()
        audio.playEffect("\(nameOfFile).aif")
    }
    
    
    func quests() {
        var qList = CCBReader.loadAsScene("questList")
        var crossFade:CCTransition = CCTransition(crossFadeWithDuration: 1.0)
        CCDirector.sharedDirector().replaceScene(qList, withTransition: crossFade)
        
    }
    
    
    
    override func update(delta: CCTime) {
        updateTotalAssets(0)
    }
}
