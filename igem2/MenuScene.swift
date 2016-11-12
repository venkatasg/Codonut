//Menu Scene

import SpriteKit

class MenuScene: SKScene {
    
    var playLabel: SKLabelNode!
    var howToLabel: SKLabelNode!
    var wikiLink: SKLabelNode!
    var highScoreLabel: SKLabelNode!
    
    var wikiButton: SKSpriteNode!
    var ribosome: SKSpriteNode!
    var aminoacids: SKSpriteNode!
    var playButton: SKSpriteNode!
    var howToButton: SKSpriteNode!
    
    let defaults = UserDefaults.standard
    
    let LogoTexture = SKTexture(imageNamed: "logo")
    let ButtonTexture = SKTexture(imageNamed: "menu")
    let wikiUrl = URL(string: "http://2016.igem.org/Team:IIT-Madras/codonut")
    let ribosomeTexture = SKTexture(imageNamed: "ribosomemenu")
    let aminoTexture = SKTexture(imageNamed: "menuamino")
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = UIColor.black
    
        ribosome = SKSpriteNode(texture: ribosomeTexture)
        ribosome.position = CGPoint(x: frame.midX - 250 , y: frame.midY)

        aminoacids = SKSpriteNode(texture: aminoTexture)
        aminoacids.position = CGPoint(x: frame.midX + 250 , y: frame.midY)
        
        playButton = SKSpriteNode(texture: ButtonTexture)
        playButton.position = CGPoint(x: frame.midX , y: frame.midY+70)
        playButton.zPosition = -1
        
        playLabel = SKLabelNode(fontNamed: "KenVector Future Thin")
        playLabel.fontSize = 25
        playLabel.position = CGPoint(x: frame.midX, y: frame.midY+70)
        playLabel.horizontalAlignmentMode = .center
        playLabel.verticalAlignmentMode = .center
        playLabel.text = "Play"
        playLabel.fontColor = UIColor.white
        
        howToButton = SKSpriteNode(texture: ButtonTexture)
        howToButton.position = CGPoint(x: frame.midX, y: frame.midY)
        howToButton.zPosition = -1
        
        howToLabel = SKLabelNode(fontNamed: "KenVector Future Thin")
        howToLabel.fontSize = 25
        howToLabel.position = CGPoint(x: frame.midX, y: frame.midY )
        howToLabel.horizontalAlignmentMode = .center
        howToLabel.verticalAlignmentMode = .center
        howToLabel.text = "Help"
        howToLabel.fontColor = UIColor.white
        
        wikiButton = SKSpriteNode(texture: ButtonTexture)
        wikiButton.position = CGPoint(x: frame.midX , y: frame.midY-70)
        wikiButton.zPosition = -1
        
        wikiLink = SKLabelNode(fontNamed: "KenVector Future Thin")
        wikiLink.fontSize = 25
        wikiLink.position = CGPoint(x: frame.midX, y: frame.midY-70)
        wikiLink.horizontalAlignmentMode = .center
        wikiLink.verticalAlignmentMode = .center
        wikiLink.text = "Our Wiki"
        wikiLink.fontColor = UIColor.white
        
        let defaults = UserDefaults.standard
        let score = defaults.integer(forKey: "highScore")
        highScoreLabel = SKLabelNode(fontNamed: "KenVector Future Thin")
        highScoreLabel.fontSize = 25
        highScoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 30)
        highScoreLabel.horizontalAlignmentMode = .center
        highScoreLabel.verticalAlignmentMode = .center
        highScoreLabel.text = "High Score: \(score)"
        highScoreLabel.fontColor = UIColor.white
        
        addChild(playButton)
        addChild(playLabel)
        addChild(howToButton)
        addChild(howToLabel)
        addChild(aminoacids)
        addChild(ribosome)
        addChild(highScoreLabel)
        addChild(wikiButton)
        addChild(wikiLink)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let pos = touch.location(in: self)
            if playButton.contains(pos) {
                if view != nil {
                    let scene:SKScene = PlayScene(size: self.size)
                    self.view?.presentScene(scene, transition: SKTransition.doorsOpenHorizontal(withDuration: 1))
                }
            }
            
            else if howToButton.contains(pos) {
                if view != nil {
                    let scene:SKScene = HelpScene(size: self.size)
                    self.view?.presentScene(scene, transition: SKTransition.reveal(with: SKTransitionDirection.up, duration: 0.75))
                }
            }
            
            else if wikiButton.contains(pos) {
                UIApplication.shared.open(wikiUrl!)
            }
        }
    }
}
