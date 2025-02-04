import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    // Переменные для объектов
    var background: SKSpriteNode!
    var knight: SKSpriteNode!
    
    var map: SKSpriteNode!
    var damage: SKSpriteNode!
    var health: SKSpriteNode!
    var loot: SKSpriteNode!
    var mapBox: SKSpriteNode!
    var shopBox: SKSpriteNode!
    var barHealth: SKSpriteNode!
    
    var coinCount: Int = 0
    var coinLabel: SKLabelNode!
    var backgroundMusic: SKAudioNode?

    override func didMove(to view: SKView) {
        // Добавление музыки
        if let musicURL = Bundle.main.url(forResource: "mainMelody", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: musicURL)
            if let backgroundMusic = backgroundMusic {
                addChild(backgroundMusic)
                backgroundMusic.autoplayLooped = true // Музыка будет зацикливаться
            }
        }
        

        if let bgNode = self.childNode(withName: "background") as? SKSpriteNode {
            background = bgNode
            background.position = CGPoint(x: frame.midX, y: frame.midY)
        }


        if let knightNode = self.childNode(withName: "knight") as? SKSpriteNode {
            knight = knightNode
            
            // Размещение рыцаря по центру экрана
            knight.position = CGPoint(x: Constants.knightPosition_X, y: frame.midY)
            knight.size = CGSize(width: Constants.khightWidth, height: Constants.khightHeight)
        }
        if let labelNode = self.childNode(withName: "coinLabel") as? SKLabelNode {
            coinLabel = labelNode
            coinCount = UserDefaults.standard.integer(forKey: "coinCount")
            coinLabel.text = "\(coinCount)"
            coinLabel.position = CGPoint(x: -260, y: 64)
            coinLabel.fontName = "Arial-BoldMT"
            coinLabel.fontSize = 16
            coinLabel.fontColor = SKColor(red: 0.96, green: 0.96, blue: 0.86, alpha: 1.0)
        }
        
        if let mapBoxNode = self.childNode(withName: "mapBox") as? SKSpriteNode {
            mapBox = mapBoxNode
        }
        
        if let shopBoxNode = self.childNode(withName: "shopBox") as? SKSpriteNode {
            shopBox = shopBoxNode
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            // Проверка нажатия на рыцаря
            if knight.contains(location) {
                coinCount += 1
                print("Количество монет: \(coinCount)")
                
                // Обновление текста метки
                coinLabel.text = "\(coinCount)"
                
                // Сохранение значения монет
                UserDefaults.standard.set(coinCount, forKey: "coinCount")
                
                knight.size = CGSize(width: Constants.khightWidth, height: Constants.khightHeight)
                // Уменьшение рыцаря до 80% от начального размера
                knight.run(SKAction.scale(to: 0.8, duration: 0.1))
                
                // Воспроизводим звук
                let soundAction = SKAction.playSoundFileNamed("sound.mp3", waitForCompletion: false)
                knight.run(soundAction)
            }
            
            if mapBox.contains(location) {
               let transition = SKTransition.flipHorizontal(withDuration: 0.5)
               if let mapScene = MapScene(fileNamed: "MapScene") {
                   mapScene.scaleMode = .aspectFill
                   print("Maaaaap")
                   self.view?.presentScene(mapScene, transition: transition)
               }
            }
            
            if shopBox.contains(location) {
                print("Нажали на магазин")
                
                if let shopScene = ShopScene(fileNamed: "ShopScene") {
                    shopScene.scaleMode = .aspectFill
                    shopScene.position = CGPoint(x: 0, y: self.size.height)
                    shopScene.zPosition = 100
                    if shopScene.physicsBody != nil {
                        shopScene.physicsBody = nil
                    }

                    // Удаляем старую сцену с именем "ShopScene", если она существует
                    if let existingShopScene = self.childNode(withName: "ShopScene") {
                        existingShopScene.removeFromParent()
                    }
                    
                    print("Подготовка к добавлению сцены магазина")
                    // Добавляем новую сцену как дочерний узел
                    self.addChild(shopScene)
                    
 
                    shopScene.name = "ShopScene"
                    
                    // Анимация появления магазина сверху
                    shopScene.run(SKAction.moveTo(y: 0, duration: 0.5))
                } else {
                    print("Не удалось загрузить сцену магазина")
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            // Проверка, если рыцарь был отпущен
            if knight.contains(location) {
                // Возврат рыцаря к исходным размерам
                knight.run(SKAction.scale(to: 1.0, duration: 0.1)) // Возвращаем к исходному размеру (100%)
            }
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Если касание было прервано
        knight.run(SKAction.scale(to: 1.0, duration: 0.1)) 
    }
}

