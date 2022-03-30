import UIKit
import SpriteKit

    class SnakeBodyPart: SKShapeNode {
        
        init(atPoint point: CGPoint) {
            super.init()
            
            path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 10, height: 10)).cgPath
            fillColor = .green
            strokeColor = .blue
            lineWidth = 5
            
            self.position = point
            
            self.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(6), center: CGPoint(x: 5, y: 5))
            self.physicsBody?.isDynamic = true
            self.physicsBody?.categoryBitMask = CollisionCategories.Snake
            self.physicsBody?.contactTestBitMask = CollisionCategories.EdgeBody | CollisionCategories.Apple
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
