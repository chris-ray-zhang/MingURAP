import Foundation

class MainScene: CCNode {
    var counter = 0
    var cornBar = false
    
    func didLoadFromCCB() {
        
    }
    
    
    func quests() {
        let bargainScene = CCBReader.loadAsScene("bargainGame")
        CCDirector.sharedDirector().presentScene(bargainScene)
    }
    
    func cornFieldBar() {
        
    }
    
    override func update(delta: CCTime) {
        if (counter < 100) {
            if let coinsTester = getChildByName("coinTester", recursively: false) as? CCSprite {
                coinsTester.scaleX = Float(counter)/100
            }
            counter++
        }

        
        
        
        
    }
}
