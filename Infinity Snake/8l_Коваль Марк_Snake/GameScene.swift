import SpriteKit
import GameplayKit


    struct CollisionCategories {
        static let Snake: UInt32 = 0x1 << 0 // 0001 1
        static let SnakeHead: UInt32 = 0x1 << 1 // 0010 2
        static let Apple: UInt32 = 0x1 << 2 //0100 4
        static let EdgeBody: UInt32 = 0x1 << 3 //1000 8
    }

    class GameScene: SKScene {
        
        var snake: Snake? // тут хранится наша змейка (опционально, т.к. мы ее еще не поместили на экран)
        
        override func didMove(to view: SKView) {
            backgroundColor = SKColor.black
            self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
            self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
            self.physicsBody?.allowsRotation = false
            view.showsPhysics = true
            
            
            let counterClockWiseButton = SKShapeNode()
            counterClockWiseButton.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 45, height: 45)).cgPath
            counterClockWiseButton.position = CGPoint(x: view.scene!.frame.minX + 30, y: view.scene!.frame.minY + 30)
            counterClockWiseButton.fillColor = .gray
            counterClockWiseButton.strokeColor = .gray
            counterClockWiseButton.lineWidth = 10
            counterClockWiseButton.name = "counterClockWiseButton"
            self.addChild(counterClockWiseButton)
            
            let clockwiseButton = SKShapeNode()
            clockwiseButton.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 45, height: 45)).cgPath
            clockwiseButton.position = CGPoint(x: view.scene!.frame.maxX - 80, y: view.scene!.frame.minY + 30)
            clockwiseButton.fillColor = .gray
            clockwiseButton.strokeColor = .gray
            clockwiseButton.lineWidth = 10
            clockwiseButton.name = "clockwiseButton"
            self.addChild(clockwiseButton)
            
            createApple() // создаем яблоко рандомно на нашей сцене
            
            snake = Snake(atPoint: CGPoint(x: view.scene!.frame.midX, y: view.scene!.frame.midY)) // создаем нашу змейку в центре экрана
            self.addChild(snake!) // добавили на экран и развернули
            
            
            self.physicsWorld.contactDelegate = self // столкновение происходит на самой сцене
            
            
            self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody //края экрана
            self.physicsBody?.collisionBitMask = CollisionCategories.Snake | CollisionCategories.SnakeHead // наша змея
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let touchLocation = touch.location(in: self)
                guard let touchNode = self.atPoint(touchLocation) as? SKShapeNode,
                      touchNode.name == "counterClockWiseButton" || touchNode.name == "clockwiseButton" else {
                          return
                      }
                
                touchNode.fillColor = .green
                
                if touchNode.name == "clockwiseButton" {
                    snake!.moveClockwise()
                } else if touchNode.name == "counterClockWiseButton" {
                    snake!.moveCounterClockwise()
                }
                
            }
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            
            for touch in touches {
                let touchLocation = touch.location(in: self)
                guard let touchNode = self.atPoint(touchLocation) as? SKShapeNode,
                      touchNode.name == "counterClockWiseButton" || touchNode.name == "clockwiseButton" else {
                          return
                      }
                
                touchNode.fillColor = .gray
                
            }
            
        }
        
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
         
        }
        
        override func update(_ currentTime: TimeInterval) {
            // Called before each frame is rendered
            
            snake?.move()
        }
        
        func restart() {
            guard let scene = scene else { return }
            
            snake = Snake(atPoint: CGPoint(x: scene.frame.midX, y: scene.frame.midY)) // создаем нашу змейку в центре экрана
            self.addChild(snake!) // добавили на экран и развернули
            
            createApple() // создаем яблоко рандомно на нашей сцене
            
            // создаем наши кнопки
            let counterClockWiseButton = SKShapeNode()
            counterClockWiseButton.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 45, height: 45)).cgPath
            counterClockWiseButton.position = CGPoint(x: scene.frame.minX + 30, y: scene.frame.minY + 30)
            counterClockWiseButton.fillColor = .gray
            counterClockWiseButton.strokeColor = .gray
            counterClockWiseButton.lineWidth = 10
            counterClockWiseButton.name = "counterClockWiseButton"
            self.addChild(counterClockWiseButton)
            
            let clockwiseButton = SKShapeNode()
            clockwiseButton.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 45, height: 45)).cgPath
            clockwiseButton.position = CGPoint(x: scene.frame.maxX - 80, y: scene.frame.minY + 30)
            clockwiseButton.fillColor = .gray
            clockwiseButton.strokeColor = .gray
            clockwiseButton.lineWidth = 10
            clockwiseButton.name = "clockwiseButton"
            self.addChild(clockwiseButton)
            
        }
        
        func createApple() {
           // let randX = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxX - 5)))
            let randY = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxY - 5)))
            let randX = CGFloat(arc4random_uniform(UInt32(view!.scene!.frame.maxX - 5)))
            
            let apple = Apple(position: CGPoint(x: randX, y: randY))
            self.addChild(apple)
        }
    }


    extension GameScene: SKPhysicsContactDelegate {
        
        func didBegin(_ contact: SKPhysicsContact) {
            let bodyes = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask //6 контакт тела а   и тела б
            let collisonOBject = bodyes - CollisionCategories.SnakeHead //6 - 2 = 4
            
            switch collisonOBject {
            case CollisionCategories.Apple:
                let apple = contact.bodyA.node is Apple ? contact.bodyA.node : contact.bodyB.node // какое из тел, а или б, относится к яблоку
                snake?.addBodyPart() // добавление нового элемента к змеее
                apple?.removeFromParent() // удаляем "яблоко"
                createApple() // снова создаем уже новое яблоко
                
            case CollisionCategories.EdgeBody:
                snake = nil
                self.removeAllChildren()
                restart()
                break
                 
            default:
                break
                
            }
            
        }
    }
