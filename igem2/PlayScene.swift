// Gameplay scene

import SpriteKit

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Ground    : UInt32 = 0b1      // 1
    static let Player    : UInt32 = 0b10      // 2
    static let AminoAcidGood : UInt32 = 0b11       // 3
    static let AminoAcidBad : UInt32 = 0b100    //4
    static let AminoAcidMed : UInt32 = 0b101    //5
}

enum GameState {
    case showingLogo
    case playing
    case dead
}

class PlayScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode?
    var player: SKSpriteNode!
    var gamestate = GameState.showingLogo
    var delta = 0.0
    
    let defaults = UserDefaults.standard
    let ButtonTexture = SKTexture(imageNamed: "menu")
    
    var replayButton: SKSpriteNode?
    var replayLabel: SKLabelNode?
    var menuButton:SKSpriteNode?
    var cellBackground:SKSpriteNode?
    var menuLabel:SKLabelNode?
    var gameOver:SKLabelNode?
    var gameStart:SKLabelNode?
    var highScoreLabel: SKLabelNode?
    
    var score = 0 {
        didSet {
            scoreLabel?.text = "SCORE: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.black
        
        createLabel(label: &gameStart, pos: CGPoint(x: frame.midX, y: frame.midY), text: "Tap to Play", color: UIColor.white)
        gameStart?.alpha = 1
        gameStart?.fontSize = 35
        
        createButton(button: &replayButton, pos: CGPoint(x: frame.midX-100 , y: frame.midY-140))
        createButton(button: &menuButton, pos: CGPoint(x: frame.midX+100 , y: frame.midY-140))
        createLabel(label: &scoreLabel, pos: CGPoint(x: frame.maxX - 80, y: frame.maxY - 70), text: "Score: 0", color: UIColor.white)
        scoreLabel?.alpha=1
        createLabel(label: &replayLabel, pos: CGPoint(x: frame.midX-100, y: frame.midY-140), text: "Replay", color: UIColor.white)
        createLabel(label: &menuLabel, pos: CGPoint(x: frame.midX+100, y: frame.midY-140), text: "Menu", color: UIColor.white)
        createLabel(label: &gameOver, pos: CGPoint(x: frame.midX, y: frame.midY), text: "Game Over", color: UIColor.red)
        gameOver?.fontSize = 35
        
        cellBackground = SKSpriteNode(color: UIColor(red: CGFloat(0x73)/255, green: CGFloat(0xcd)/255, blue: CGFloat(0x4b)/255, alpha: 0.80), size: CGSize(width: Double(frame.maxX), height: Double(frame.maxY)))
        cellBackground?.zPosition = -100
        cellBackground?.position = CGPoint(x: frame.midX, y: frame.midY)
        
        createPlayer()
        addChild(cellBackground!)
        createGround()
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -7)
        physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch gamestate {
            
        case .showingLogo:
            gamestate = .playing
            let fadeOut = SKAction.fadeOut(withDuration: 1)
            let remove = SKAction.removeFromParent()
            let activatePlayer = SKAction.run { [unowned self] in self.player.physicsBody!.isDynamic = true
            self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run(self.createAmAcids),SKAction.wait(forDuration: 1.75, withRange: 0.5)])))
            }
            let sequenceForStart = SKAction.sequence([fadeOut, remove, activatePlayer])
            gameStart?.run(sequenceForStart)
            
        case .playing:
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 60))
            
        case .dead:
            for touch in touches{
                let pos = touch.location(in: self)
                
                if (replayButton?.contains(pos))! {
                    if view != nil {
                        let scene:SKScene = PlayScene(size: self.size)
                        self.view?.presentScene(scene, transition: SKTransition.reveal(with: SKTransitionDirection.left, duration: 1))
                    }
                }
                else if (menuButton?.contains(pos))!{
                    if view != nil {
                        let scene:SKScene = MenuScene(size: self.size)
                        self.view?.presentScene(scene, transition: SKTransition.reveal(with: SKTransitionDirection.right, duration: 0.75))
                    }
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard player != nil else { return }
        let value = player.physicsBody!.velocity.dy * 0.001
        let rotate = SKAction.rotate(toAngle: value, duration: 0.1)
        player.run(rotate)
        physicsWorld.gravity = CGVector(dx: 0, dy: -7-delta)
    }
    
    func createButton(button: inout SKSpriteNode?, pos: CGPoint) {
        button = SKSpriteNode(texture: ButtonTexture)
        button?.position = pos
        button?.alpha = 0
        button?.zPosition = 1
        addChild(button!)
    }
    
    func createLabel(label: inout SKLabelNode?, pos: CGPoint, text: String, color: UIColor){
        label = SKLabelNode(fontNamed: "KenVector Future Thin")
        label?.fontSize = 25
        label?.position = pos
        label?.zPosition = 2
        label?.horizontalAlignmentMode = .center
        label?.verticalAlignmentMode = .center
        label?.text = text
        label?.fontColor = color
        label?.alpha = 0
        addChild(label!)
    }
    
    func createPlayer() {
        let playerTexture  = SKTexture(imageNamed: "player-1")
        player = SKSpriteNode(texture:playerTexture)
        player.name = "player"
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        player.zPosition = -1
        
        player.physicsBody = SKPhysicsBody(texture: playerTexture, size: playerTexture.size())
        player.physicsBody!.isDynamic = false
        player.physicsBody!.categoryBitMask = PhysicsCategory.Player
        player.physicsBody!.contactTestBitMask = PhysicsCategory.AminoAcidGood | PhysicsCategory.AminoAcidBad | PhysicsCategory.AminoAcidMed
        player.physicsBody!.collisionBitMask = PhysicsCategory.None
        
        let frame2 = SKTexture(imageNamed: "player-2")
        let frame3 = SKTexture(imageNamed: "player-3")
        let frame4 = SKTexture(imageNamed: "player-4")
        let animation = SKAction.animate(with: [playerTexture, frame2, frame3, frame4, frame3,frame2], timePerFrame: 0.0417)
        let runForever = SKAction.repeatForever(animation)
        
        player.run(runForever)
        self.addChild(player)
    }
    
    func amacid(image: String, category: UInt32, type: String){
        let amacidTexture = SKTexture(imageNamed: image)
        let codon = SKSpriteNode(texture: amacidTexture)
        codon.name = type
        codon.position = CGPoint(x: size.width + codon.size.width/2, y: random(min:2*codon.size.height, max:size.height-2*codon.size.height))
        codon.zPosition = -1

        codon.physicsBody = SKPhysicsBody(circleOfRadius: codon.size.width/2)
        codon.physicsBody!.isDynamic = false
        codon.physicsBody!.contactTestBitMask = PhysicsCategory.Player
        codon.physicsBody!.collisionBitMask = PhysicsCategory.None
        codon.physicsBody!.categoryBitMask = category
        
        let actionMove = SKAction.move(to: CGPoint(x: -codon.size.width/2, y: random(min:2*codon.size.height, max:size.height-2*codon.size.height)), duration: Double(arc4random_uniform(5)))
        codon.run(SKAction.sequence([actionMove, SKAction.removeFromParent()]))
        codon.run(SKAction.repeatForever(SKAction.rotate(toAngle: (CGFloat)((Double(arc4random_uniform(5))-Double(2))*M_PI), duration: 5)))
        self.addChild(codon)
    }
    
    func createAmAcids() {
        switch arc4random_uniform(8){
        case 0:
            amacid(image: "yuck-1", category: PhysicsCategory.AminoAcidBad, type: "badcodon")
            amacid(image: "yum-1", category: PhysicsCategory.AminoAcidGood, type: "goodcodon")
            amacid(image: "meh-1", category: PhysicsCategory.AminoAcidMed, type: "medcodon")
        case 1:
            amacid(image: "yuck-1", category: PhysicsCategory.AminoAcidBad, type: "badcodon")
            amacid(image: "yum-1", category: PhysicsCategory.AminoAcidGood, type: "goodcodon")
            amacid(image: "meh-2", category: PhysicsCategory.AminoAcidMed, type: "medcodon")
        case 2:
            amacid(image: "yuck-1", category: PhysicsCategory.AminoAcidBad, type: "badcodon")
            amacid(image: "yum-2", category: PhysicsCategory.AminoAcidGood, type: "goodcodon")
            amacid(image: "meh-2", category: PhysicsCategory.AminoAcidMed, type: "medcodon")
        case 3:
            amacid(image: "yuck-2", category: PhysicsCategory.AminoAcidBad, type: "badcodon")
            amacid(image: "yum-2", category: PhysicsCategory.AminoAcidGood, type: "goodcodon")
            amacid(image: "meh-2", category: PhysicsCategory.AminoAcidMed, type: "medcodon")
        case 4:
            amacid(image: "yuck-1", category: PhysicsCategory.AminoAcidBad, type: "badcodon")
            amacid(image: "yum-2", category: PhysicsCategory.AminoAcidGood, type: "goodcodon")
            amacid(image: "meh-1", category: PhysicsCategory.AminoAcidMed, type: "medcodon")
        case 5:
            amacid(image: "yuck-2", category: PhysicsCategory.AminoAcidBad, type: "badcodon")
            amacid(image: "yum-1", category: PhysicsCategory.AminoAcidGood, type: "goodcodon")
            amacid(image: "meh-1", category: PhysicsCategory.AminoAcidMed, type: "medcodon")
        case 6:
            amacid(image: "yuck-2", category: PhysicsCategory.AminoAcidBad, type: "badcodon")
            amacid(image: "yum-1", category: PhysicsCategory.AminoAcidGood, type: "goodcodon")
            amacid(image: "meh-2", category: PhysicsCategory.AminoAcidMed, type: "medcodon")
        case 7:
            amacid(image: "yuck-2", category: PhysicsCategory.AminoAcidBad, type: "badcodon")
            amacid(image: "yum-2", category: PhysicsCategory.AminoAcidGood, type: "goodcodon")
            amacid(image: "meh-1", category: PhysicsCategory.AminoAcidMed, type: "medcodon")
        default:
            break
        }
    }
    
    func assignPhysicsTypeAndPos(body: inout SKSpriteNode){
        body.physicsBody = SKPhysicsBody(texture: body.texture!, size: body.size)
        body.physicsBody!.isDynamic = false
        body.physicsBody!.contactTestBitMask = PhysicsCategory.Player
        body.physicsBody!.collisionBitMask = PhysicsCategory.None
        body.position = CGPoint(x: size.width + body.size.width/2, y: random(min:2*body.size.height, max:size.height))
        body.zPosition = -1
        body.name = "ground"
    }
    
    func createGround() {
        
        let groundTexture = SKTexture(imageNamed: "membrane")
        for i in 0 ... 1 {
            var ground = SKSpriteNode(texture: groundTexture)
            ground.zPosition = -10
            var sky = ground.copy() as! SKSpriteNode
            assignPhysicsTypeAndPos(body: &ground)
            assignPhysicsTypeAndPos(body: &sky)
            ground.position = CGPoint(x: (groundTexture.size().width / 2.0 + (groundTexture.size().width * CGFloat(i))), y: 0)
            sky.position = CGPoint(x: (groundTexture.size().width / 2.0 + (groundTexture.size().width * CGFloat(i))), y: size.height)
            sky.zRotation = CGFloat(M_PI);
            ground.physicsBody!.categoryBitMask = PhysicsCategory.Ground
            sky.physicsBody!.categoryBitMask = PhysicsCategory.Ground
            
            let moveLeft = SKAction.moveBy(x: -groundTexture.size().width, y: 0, duration: 3)
            let moveReset = SKAction.moveBy(x: groundTexture.size().width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            ground.run(moveForever)
            sky.run(moveForever)
            
            addChild(ground)
            addChild(sky)
        }
    }
    
    func playerDidCollideWithAmAcid(_ player:SKSpriteNode, amacid:SKSpriteNode, type: UInt32) {
        if amacid.name != "done"{
            amacid.removeFromParent()
            amacid.name = "done"
            switch type {
            case 3:
                score+=5
                speed+=0.001
                delta+=0.005
            case 4:
                score-=9
            case 5:
                score+=2
                speed+=0.001
                delta+=0.005
            default:
                score+=0
            }
        }
    }
    
    func playerDidCollideWithGround(_ player:SKSpriteNode, ground:SKSpriteNode) {
        gameIsOver()
    }
    
    func gameIsOver(){
        speed=0
        gamestate = .dead
        player.physicsBody?.isDynamic = false
        
        let dimPanel = SKSpriteNode(color: UIColor.black, size: self.size)
        dimPanel.zPosition = 0
        dimPanel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(dimPanel)
        dimPanel.alpha = 0.8
        
        gameOver?.alpha = 1
        replayLabel?.alpha=1
        replayButton?.alpha=1
        menuLabel?.alpha=1
        menuButton?.alpha=1
        scoreLabel?.position = CGPoint(x: frame.midX, y: frame.midY-35)
        
        if let currentHighscore:Int = defaults.value(forKey: "highScore") as? Int {
            if(score > currentHighscore){
                defaults.set(score, forKey: "highScore")
            }
        }
        else{
            defaults.set(score, forKey: "highScore")
        }
        createLabel(label: &highScoreLabel, pos: CGPoint(x: frame.midX, y: frame.midY-70), text: "High Score:\(defaults.integer(forKey: "highScore"))", color: UIColor.white)
        highScoreLabel?.alpha=1
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.node?.name == "player" {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        let name = secondBody.node?.name!
        if name != nil{
            if secondBody.categoryBitMask > 2 {
                playerDidCollideWithAmAcid(firstBody.node as! SKSpriteNode, amacid: secondBody.node as! SKSpriteNode, type:secondBody.categoryBitMask as UInt32)
            }
            else if secondBody.categoryBitMask == 1 {
                playerDidCollideWithGround(firstBody.node as! SKSpriteNode, ground: secondBody.node as! SKSpriteNode)
            }
        }
    
    }
}

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}
