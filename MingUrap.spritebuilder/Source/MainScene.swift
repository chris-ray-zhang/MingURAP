import Foundation
import MediaPlayer



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
    
    
    
    func buyChicken() {
        if (MainScene.totalAssets + chickenCost >= 0) {
            chickenCounter++
        }
        
    }
    
    func buyCow() {
        if (MainScene.totalAssets + cowCost >= 0) {
            cowCounter++
        }
        
    }
    
    func buyTractor() {
        if (MainScene.totalAssets + tractorCost >= 0) {
            tractorCounter++
        }
        
    }
    
    func buyWaterTower() {
        if (MainScene.totalAssets + waterTowerCost >= 0) {
            waterTowerCounter++
        }
    }
    
    func updateTotalAssets(amount: Int) {
        MainScene.totalAssets += amount
        
        if let totalAssetsLabel = getChildByName("totalAssetsLabel", recursively: false) as? CCLabelTTF {
            totalAssetsLabel.string = "$" + MainScene.totalAssets.description
        }
        
    }
    
    func quests() {
        let questList = CCBReader.loadAsScene("questList")
        CCDirector.sharedDirector().pushScene(questList)
        
    }
    
    
    override func update(delta: CCTime) {
        updateTotalAssets(0)
    }
}
