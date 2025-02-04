import SpriteKit
import GameplayKit

class FirstLvl: SKScene, SKPhysicsContactDelegate {
    var backButton: SKSpriteNode!
    var background: SKSpriteNode!
    var warrior: SKSpriteNode!
    var rightMove: SKSpriteNode!
    var leftMove: SKSpriteNode!
    var jump: SKSpriteNode!
    var ground1: SKSpriteNode!
    var ground2: SKSpriteNode!
    var ground3: SKSpriteNode!
    var ground: SKSpriteNode!
    var isMovingRight = false
    var isMovingLeft = false
    var isJumping = false
    override func didMove(to view: SKView) {
        self.view?.showsPhysics = true
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -2)
        self.physicsWorld.contactDelegate = self
        
        if let rightMoveNode = self.childNode(withName: "rightMove") as? SKSpriteNode {
            rightMove = rightMoveNode
        }
        
        if let jumpNode = self.childNode(withName: "jump") as? SKSpriteNode {
            jump = jumpNode
        }
        
        if let leftMoveNode = self.childNode(withName: "leftMove") as? SKSpriteNode {
            leftMove = leftMoveNode
        }
        
        if let bgNode = self.childNode(withName: "FirstBG") as? SKSpriteNode {
            background = bgNode
            background.position = CGPoint(x: frame.midX, y: frame.midY)
        }
        
        if let quitNode = self.childNode(withName: "quitFirst") as? SKSpriteNode {
            backButton = quitNode
        }
        
        if let warriorNode = self.childNode(withName: "warrior") as? SKSpriteNode {
            warrior = warriorNode
            warrior.position = CGPoint(x: 10, y: 0)
            warrior.size = CGSize(width: 118, height: 115)
            // Добавляем физическое тело
            warrior.physicsBody = SKPhysicsBody(texture: warrior.texture!, size: warrior.size)

            
            // Включаем влияние гравитации
            warrior.physicsBody?.affectedByGravity = true
            
            // Разрешаем взаимодействие с другими объектами
            warrior.physicsBody?.isDynamic = true
            
            warrior.physicsBody?.allowsRotation = false
            // Добавляем столкновения с землёй
            warrior.physicsBody?.categoryBitMask = 0x1 << 0
            warrior.physicsBody?.collisionBitMask = 0x1 << 1
            
        }

        
        if let groundNode = self.childNode(withName: "ground") as? SKSpriteNode {
            ground = groundNode
            ground.size = CGSize(width: 853, height: 77)
            ground.position = CGPoint(x: 0, y: -160)
            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
            ground.physicsBody?.isDynamic = false 
            ground.physicsBody?.categoryBitMask = 0x1 << 1
          
        }

        if let ground1Node = self.childNode(withName: "ground1") as? SKSpriteNode {
           ground1 = ground1Node
           ground1.physicsBody = SKPhysicsBody(texture: ground1.texture!, size: ground1.size)
           ground1.physicsBody?.isDynamic = false
           ground1.physicsBody?.categoryBitMask = 0x1 << 1

        }

        if let ground2Node = self.childNode(withName: "ground2") as? SKSpriteNode {
            ground2 = ground2Node
            ground2.physicsBody = SKPhysicsBody(texture: ground2.texture!, size: ground2.size)
            ground2.physicsBody?.isDynamic = false
            ground2.physicsBody?.categoryBitMask = 0x1 << 1

        }

        if let ground3Node = self.childNode(withName: "ground3") as? SKSpriteNode {
            ground3 = ground3Node
            ground3.physicsBody = SKPhysicsBody(texture: ground3.texture!, size: ground3.size)
            ground3.physicsBody?.isDynamic = false
            ground3.physicsBody?.categoryBitMask = 0x1 << 1

        }

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            // Проверка нажатия на кнопку возврата
            if backButton.contains(location) {
                print("Переходим на сцену с картой")
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                if let gameScene = MapScene(fileNamed: "MapScene") {
                    gameScene.scaleMode = .aspectFill
                    self.view?.presentScene(gameScene, transition: transition)
                }
            }
            
            if rightMove.contains(location) {
                isMovingRight = true
                print("goright")
            }
            
            if leftMove.contains(location) {
                isMovingLeft = true
                print("goleft")
            }
            
            if jump.contains(location) {
                startJumping()
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if rightMove.contains(location) {
                isMovingRight = false
            }
            if leftMove.contains(location) {
                isMovingLeft = false
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        if isMovingRight {
            warrior.position.x += 5
            warrior.xScale = abs(warrior.xScale)
        }
        
        if isMovingLeft {
            warrior.position.x -= 5
            warrior.xScale = -abs(warrior.xScale)
        }
        
        // Ограничиваем движение рыцаря в пределах экрана
        let halfWidth = warrior.size.width / 2
        if warrior.position.x < frame.minX + halfWidth {
            warrior.position.x = frame.minX + halfWidth
        } else if warrior.position.x > frame.maxX - halfWidth {
            warrior.position.x = frame.maxX - halfWidth
        }
    }

    func startJumping() {
        print("Рыцарь прыгает")
        isJumping = true
        
        // Действие для прыжка (вверх, затем вниз)
        let jumpUp = SKAction.moveBy(x: 0, y: 150, duration: 0.3) // Прыжок вверх на 150 пикселей
        let jumpDown = SKAction.moveBy(x: 0, y: -150, duration: 0.3) // Возвращение вниз
        let endJump = SKAction.run { [weak self] in
            self?.isJumping = false
        }
        
        // Последовательность действий
        let jumpSequence = SKAction.sequence([jumpUp, jumpDown, endJump])
        warrior.run(jumpSequence)
    
    }
}
