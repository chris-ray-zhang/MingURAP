import Foundation
import MediaPlayer

class MainScene: CCNode {
    
    var totalAssets = 0
    var hayTime = 0
    var hayTimer = NSTimer()
    var cowTime = 0
    var cowTimer = NSTimer()
    var cornfieldTime = 0
    var cornfieldTimer = NSTimer()
    
    private var hayCost = -10
    private var cowCost = -50
    private var cornfieldCost = -100
    private var hayValue = 1
    private var cowValue = 10
    private var cornfieldValue = 20
    private var hayCounter = 1
    private var cowCounter = 1
    private var cornfieldCounter = 1
    
    
    
    func setupHayTimer() {
        hayTime = 5
        if let hayTimeLeft = getChildByName("hayTimeLeft", recursively: false) as? CCLabelTTF {
            hayTimeLeft.string = "Sell Again In: \(hayTime)"
        }
        hayTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractHayTime"), userInfo: nil, repeats: true)
    }
    
    func subtractHayTime() {
        hayTime--
        if let hayTimeLeft = getChildByName("hayTimeLeft", recursively: false) as? CCLabelTTF {
            hayTimeLeft.string = "Sell Again In: \(hayTime)"
        }
        if (hayTime == 0) {
            hayTimer.invalidate()
        }
    }
    
    func setupCowTimer() {
        cowTime = 10
        if let cowTimeLeft = getChildByName("cowTimeLeft", recursively: false) as? CCLabelTTF {
            cowTimeLeft.string = "Sell Again In: \(cowTime)"
        }
        cowTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractCowTime"), userInfo: nil, repeats: true)
    }
    
    func subtractCowTime() {
        cowTime--
        if let cowTimeLeft = getChildByName("cowTimeLeft", recursively: false) as? CCLabelTTF {
            cowTimeLeft.string = "Sell Again In: \(cowTime)"
        }
        if (cowTime == 0) {
            cowTimer.invalidate()
        }
    }
    
    func setupCornfieldTimer() {
        cornfieldTime = 25
        if let cornfieldTimeLeft = getChildByName("cornfieldTimeLeft", recursively: false) as? CCLabelTTF {
            cornfieldTimeLeft.string = "Sell Again In: \(cornfieldTime)"
        }
        cornfieldTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractCornfieldTime"), userInfo: nil, repeats: true)
    }
    
    func subtractCornfieldTime() {
        cornfieldTime--
        if let cornfieldTimeLeft = getChildByName("cornfieldTimeLeft", recursively: false) as? CCLabelTTF {
            cornfieldTimeLeft.string = "Sell Again In: \(cornfieldTime)"
        }
        if (cornfieldTime == 0) {
            cornfieldTimer.invalidate()
        }
    }
    
    func sellHay() {
        if (!hayTimer.valid) {
            setupHayTimer()
            updateTotalAssets(hayValue * hayCounter)
        }
        
    }
    
    func sellCow() {
        if (!cowTimer.valid) {
            setupCowTimer()
            updateTotalAssets(cowValue * cowCounter)
        }
        
    }
    
    func sellCornfield() {
        if (!cornfieldTimer.valid) {
            setupCornfieldTimer()
            updateTotalAssets(cornfieldValue * cornfieldCounter)
        }
        
    }
    
    func buyHay() {
        if (totalAssets + hayCost >= 0) {
            hayCounter++
            updateTotalAssets(hayCost)
            if let hayCounterLabel = getChildByName("hayCounter", recursively: false) as? CCLabelTTF {
                hayCounterLabel.string = hayCounter.description
            }
            if let sellHayLabel = getChildByName("sellHay", recursively: false) as? CCButton {
                sellHayLabel.title = "Sell Hay: $" + (hayValue * hayCounter).description
            }
        }
        
    }
    
    func buyCow() {
        if (totalAssets + cowCost >= 0) {
            cowCounter++
            updateTotalAssets(cowCost)
            if let cowCounterLabel = getChildByName("cowCounter", recursively: false) as? CCLabelTTF {
                cowCounterLabel.string = cowCounter.description
            }
            if let sellMilkLabel = getChildByName("sellMilk", recursively: false) as? CCButton {
                sellMilkLabel.title = "Sell Milk: $" + (cowValue * cowCounter).description
            }
        }
        
    }
    
    func buyCornfield() {
        if (totalAssets + cornfieldCost >= 0) {
            cornfieldCounter++
            updateTotalAssets(cornfieldCost)
            if let cornfieldCounterLabel = getChildByName("cornfieldCounter", recursively: false) as? CCLabelTTF {
                cornfieldCounterLabel.string = cornfieldCounter.description
            }
            if let sellCornLabel = getChildByName("sellCorn", recursively: false) as? CCButton {
                sellCornLabel.title = "Sell Corn: $" + (cornfieldValue * cornfieldCounter).description
            }
        }
        
    }
    
    func updateTotalAssets(amount: Int) {
        totalAssets += amount
        if let totalAssetsLabel = getChildByName("totalAssetsLabel", recursively: false) as? CCLabelTTF {
            totalAssetsLabel.string = "$" + totalAssets.description
        }
    }
    
    func quests() {
        /*
        let bargainScene = CCBReader.loadAsScene("bargainGame")
        CCDirector.sharedDirector().presentScene(bargainScene)
        */
        let bargainScene = CCBReader.loadAsScene("bargainGame")
        CCDirector.sharedDirector().pushScene(bargainScene)

    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func didLoadFromCCB() {
        
        /*
        bar = getChildByName("bar", recursively: false) as? CCSprite
        progressBar = CCProgressNode.progressWithSprite(bar)
        progressBar!.type = CCProgressNodeType.Bar
        progressBar!.percentage = 0.0
        progressBar!.midpoint = ccp(0, 1)
        progressBar!.barChangeRate = ccp(1.0, 0.0)
        progressBar!.position = ccp(100, 100)
        addChild(progressBar)
        */
    }
    
    
    
    
    
    
    func cornFieldBar() {
        /*
        progressBar?.percentage += 10.0
        */
        
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
