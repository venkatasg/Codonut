// Help Scene

import SpriteKit

class HelpScene: SKScene {
    var menuButton: SKSpriteNode!
    var menuLabel: SKLabelNode!
    var help: SKSpriteNode!
    let ButtonTexture = SKTexture(imageNamed: "menu")
    let helpTexture = SKTexture(imageNamed: "help")
    
    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.black
        
        help = SKSpriteNode(texture: helpTexture)
        help.position = CGPoint(x: frame.midX, y: frame.midY+30)
        help.zPosition = -1
        addChild(help)
        
        menuButton = SKSpriteNode(texture:ButtonTexture)
        menuButton.position = CGPoint(x: frame.midX, y: 30)
        addChild(menuButton)
        
        menuLabel = SKLabelNode(fontNamed: "KenVector Future Thin")
        menuLabel.fontSize = 25
        menuLabel.position = CGPoint(x: frame.midX, y: 30)
        menuLabel.zPosition = 1
        menuLabel.horizontalAlignmentMode = .center
        menuLabel.verticalAlignmentMode = .center
        menuLabel.text = "Menu"
        menuLabel.fontColor = UIColor.white
        addChild(menuLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let pos = touch.location(in: self)
            
            if menuButton.contains(pos) {
                menuLabel.removeFromParent()
                menuButton.removeFromParent()
                if view != nil {
                    let scene:SKScene = MenuScene(size: self.size)
                    self.view?.presentScene(scene, transition: SKTransition.reveal(with: SKTransitionDirection.down, duration: 0.75))
                }
            }
        }
    }
    
}
