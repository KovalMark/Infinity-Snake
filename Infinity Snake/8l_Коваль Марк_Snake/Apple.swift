import UIKit
import SpriteKit

    class Apple: SKShapeNode {
        
        init(position: CGPoint) {
            super.init()
            
            path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 20, height: 20)).cgPath
            fillColor = UIColor.red
            strokeColor = UIColor.green
            lineWidth = 3
            self.position = position
            
            self.physicsBody = SKPhysicsBody(circleOfRadius: 10.0, center: CGPoint(x: 10, y: 10))
            
            self.physicsBody?.categoryBitMask = CollisionCategories.Apple
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
