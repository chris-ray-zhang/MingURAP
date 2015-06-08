import Foundation

class MainScene: CCNode {
    var counter = 0
    var cornBar = false
    var bar: CCSprite? = nil
    var progressBar: CCProgressNode? = nil
    
    func didLoadFromCCB() {
        bar = getChildByName("bar", recursively: false) as? CCSprite
        progressBar = CCProgressNode.progressWithSprite(bar)
        progressBar!.type = CCProgressNodeType.Bar
        progressBar!.percentage = 0.0
        progressBar!.midpoint = ccp(0, 1)
        progressBar!.barChangeRate = ccp(1.0, 0.0)
        progressBar!.position = ccp(100, 100)
        addChild(progressBar)

    }
    
    
    func quests() {
        let bargainScene = CCBReader.loadAsScene("bargainGame")
        CCDirector.sharedDirector().presentScene(bargainScene)
    }
    
    func cornFieldBar() {
        progressBar?.percentage += 10.0
        
    }
    
    override func update(delta: CCTime) {
        /*
        if (counter < 100) {
            
            progressBar?.percentage += 1.0

            counter++
        }
        */
        /*
        if (counter < 100) {
            if let coinsTester = getChildByName("coinTester", recursively: false) as? CCSprite {
                coinsTester.scaleX = Float(counter)/100
            }
            counter++
        }
        */
    }
}
