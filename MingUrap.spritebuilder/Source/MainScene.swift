import Foundation
import MediaPlayer
import AVFoundation
import Parse



class MainScene: CCNode {
    
    static var totalAssets = 20000
    
    private var chickenCost = -200
    private var cowCost = -2400
    private var tractorCost = -6000
    private var waterTowerCost = -10000
    private static var boughtCow = false
    private static var boughtChicken = false
    private static var boughtTower = false
    private static var boughtTractor = false
    private var player: AVAudioPlayer! = nil
    
    
    
    func didLoadFromCCB() {
        if (walkThrough.numWalkThroughs == 0) {
            userInteractionEnabled = false
            if let questButton = getChildByName("questButton", recursively: false) as? CCSprite {
                questButton.visible = false
            }
            if let quests = getChildByName("quests", recursively: false) as? CCButton {
                quests.visible = false
            }
        }
        nullifyButtons()
        updateImages()
        prepareSound("chime")
        updateTotalAssets(0)
        self.scheduleOnce(Selector("updateZeroAssets"), delay: 1.0)
        self.scheduleOnce(Selector("returnNormalFontSize"), delay: 1.5)
        
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
    
    func nullifyButtons() {
        if let buyCow = getChildByName("buyCow", recursively: false) as? CCButton {
            buyCow.userInteractionEnabled = false
        }
        if let buyChicken = getChildByName("buyChicken", recursively: false) as? CCButton {
            buyChicken.userInteractionEnabled = false
        }
        if let buyTractor = getChildByName("buyTractor", recursively: false) as? CCButton {
            buyTractor.userInteractionEnabled = false
        }
        if let buyTower = getChildByName("buyTower", recursively: false) as? CCButton {
            buyTower.userInteractionEnabled = false
        }
    }
    
    func establishButtons() {
        if let buyCow = getChildByName("buyCow", recursively: false) as? CCButton {
            buyCow.userInteractionEnabled = true
        }
        if let buyChicken = getChildByName("buyChicken", recursively: false) as? CCButton {
            buyChicken.userInteractionEnabled = true
        }
        if let buyTractor = getChildByName("buyTractor", recursively: false) as? CCButton {
            buyTractor.userInteractionEnabled = true
        }
        if let buyTower = getChildByName("buyTower", recursively: false) as? CCButton {
            buyTower.userInteractionEnabled = true
        }
    }
    
    func updateImages() {
        if MainScene.boughtCow {
            if let beefBaron = getChildByName("beefBaron", recursively: false) as? CCSprite {
                beefBaron.visible = true
            }
            if let buyCowSprite = getChildByName("buyCowSprite", recursively: false) as? CCSprite {
                buyCowSprite.visible = false
            }
            if let buyCow = getChildByName("buyCow", recursively: false) as? CCButton {
                buyCow.userInteractionEnabled = false
            }
        }
        if MainScene.boughtChicken {
            if let roosterDuke = getChildByName("roosterDuke", recursively: false) as? CCSprite {
                roosterDuke.visible = true
            }
            if let buyChickenSprite = getChildByName("buyChickenSprite", recursively: false) as? CCSprite {
                buyChickenSprite.visible = false
            }
            if let buyChicken = getChildByName("buyChicken", recursively: false) as? CCButton {
                buyChicken.userInteractionEnabled = false
            }

        }
        if MainScene.boughtTractor {
            if let tractorMaster = getChildByName("tractorMaster", recursively: false) as? CCSprite {
                tractorMaster.visible = true
            }
            if let buyTractorSprite = getChildByName("buyTractorSprite", recursively: false) as? CCSprite {
                buyTractorSprite.visible = false
            }
            if let buyTractor = getChildByName("buyTractor", recursively: false) as? CCButton {
                buyTractor.userInteractionEnabled = false
            }
        }
        if MainScene.boughtTower {
            if let towerTitan = getChildByName("towerTitan", recursively: false) as? CCSprite {
                towerTitan.visible = true
            }
            if let buyTowerSprite = getChildByName("buyTowerSprite", recursively: false) as? CCSprite {
                buyTowerSprite.visible = false
            }
            if let buyTower = getChildByName("buyTower", recursively: false) as? CCButton {
                buyTower.userInteractionEnabled = false
            }
        }
        
        
    }
    
    func returnNormalFontSize() {
        if let totalAssetsLabel = getChildByName("totalAssetsLabel", recursively: false) as? CCLabelTTF {
            totalAssetsLabel.fontSize = 25.0
        }
    }
    
    func updateZeroAssets() {
        if let totalAssetsLabel = getChildByName("totalAssetsLabel", recursively: false) as? CCLabelTTF {
            totalAssetsLabel.fontSize = 35.0
        }
        updateTotalAssets(0)
    }
    
    func buyChicken() {
        print("buying chicken")
        if (MainScene.totalAssets + chickenCost >= 0) {
            MainScene.boughtChicken = true
            prepareSound("chicken")
            updateTotalAssets(chickenCost)
            updateImages()
            
        }
        
    }
    
    func buyCow() {
        if (MainScene.totalAssets + cowCost >= 0) {
            MainScene.boughtCow = true
            prepareSound("cowMoo")
            updateTotalAssets(cowCost)
            updateImages()
        }
        
    }
    
    func buyTractor() {
        if (MainScene.totalAssets + tractorCost >= 0) {
            MainScene.boughtTractor = true
            updateTotalAssets(tractorCost)
            updateImages()
        }
        
    }
    
    func buyWaterTower() {
        if (MainScene.totalAssets + waterTowerCost >= 0) {
            MainScene.boughtTower = true
            updateTotalAssets(waterTowerCost)
            updateImages()
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
        audio.effectsMuted = false
        audio.playEffect("\(nameOfFile).aif")
    }
    
    
    func quests() {
        let qList = CCBReader.loadAsScene("questList")
        let crossFade:CCTransition = CCTransition(crossFadeWithDuration: 1.0)
        CCDirector.sharedDirector().replaceScene(qList, withTransition: crossFade)
        
    }
    
    
    
    override func update(delta: CCTime) {
        if (walkThrough.complete) {
            if let questButton = getChildByName("questButton", recursively: false) as? CCSprite {
                questButton.visible = true
            }
            if let quests = getChildByName("quests", recursively: false) as? CCButton {
                quests.visible = true
                quests.userInteractionEnabled = true
            }
            establishButtons()
            walkThrough.complete = false
            
        }
        if (walkThrough.hasBoughtChicken) {
            updateTotalAssets(0)
            //walkThrough.hasBoughtChicken = false
        }
        
        
    }
    
}
