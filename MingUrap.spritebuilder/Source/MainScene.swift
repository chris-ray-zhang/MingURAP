import Foundation
import MediaPlayer
import AVFoundation
import Parse



class MainScene: CCNode {
    
    static var totalAssets = 0
    
    private var chickenCost = -200
    private var cowCost = -2400
    private var tractorCost = -6000
    private var waterTowerCost = -10000
    private var chickenCounter = 1
    private var cowCounter = 1
    private var tractorCounter = 1
    private var waterTowerCounter = 1
    private var player: AVAudioPlayer! = nil
    
    func didLoadFromCCB() {
        prepareSound("chime")
        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            println("Object has been saved.")
        }
    }
    
    func buyChicken() {
        if (MainScene.totalAssets + chickenCost >= 0) {
            prepareSound("chicken")
            updateTotalAssets(chickenCost)
            chickenCounter++
        }
        
    }
    
    func buyCow() {
        if (MainScene.totalAssets + cowCost >= 0) {
            prepareSound("cowMoo")
            updateTotalAssets(cowCost)
            cowCounter++
        }
        
    }
    
    func buyTractor() {
        if (MainScene.totalAssets + tractorCost >= 0) {
            updateTotalAssets(tractorCost)
            tractorCounter++
        }
        
    }
    
    func buyWaterTower() {
        if (MainScene.totalAssets + waterTowerCost >= 0) {
            updateTotalAssets(waterTowerCost)
            waterTowerCounter++
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
        CCDirector.sharedDirector().replaceScene(qList)
        
    }
    
    
    
    override func update(delta: CCTime) {
        
        updateTotalAssets(0)

    }
}
