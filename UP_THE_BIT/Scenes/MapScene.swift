import SpriteKit

class MapScene: SKScene {
    var backButton: SKSpriteNode!
    var background: SKSpriteNode!
    var first: SKSpriteNode!
    var second: SKSpriteNode!
    var third: SKSpriteNode!
    var firstBox: SKSpriteNode!
    var secondBox: SKSpriteNode!
    var thirdBox: SKSpriteNode!
    override func didMove(to view: SKView) {
        
        if let bgNode = self.childNode(withName: "MapBG") as? SKSpriteNode {
            background = bgNode
            background.position = CGPoint(x: frame.midX, y: frame.midY)
        }
        
        if let quitNode = self.childNode(withName: "quit") as? SKSpriteNode {
            backButton = quitNode
        }
        
        if let firstBoxNode = self.childNode(withName: "firstBox") as? SKSpriteNode {
            firstBox = firstBoxNode
        }
        
    }
    
    // Обрабатываем нажатие на экран (например, кнопку "Назад")
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            // Если нажали на кнопку "Назад"
            if backButton.contains(location) {
                print("Переходим на главную сцену")
                
                // Создаем переход на главную сцену
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                if let gameScene = GameScene(fileNamed: "GameScene") {
                    gameScene.scaleMode = .aspectFill
                    self.view?.presentScene(gameScene, transition: transition)
                }
            }
            
            if firstBox.contains(location) {
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                if let firstLvlScene = FirstLvl(fileNamed: "FirstLvl") {
                    firstLvlScene.scaleMode = .aspectFill
                    print("FirstLvl")
                    self.view?.presentScene(firstLvlScene, transition: transition)
                }
            }
        }
    }
}
