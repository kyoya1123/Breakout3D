import SceneKit

public class ReflectorNode: SCNNode {
    
    public static var reflector: SCNNode!
    
    public init(width: CGFloat, height: CGFloat) {
        super.init()
        let geometry = SCNBox(width: width, height: height, length: 0.001, chamferRadius: 0)
        self.geometry = geometry
        self.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: geometry, options: nil))
        self.physicsBody?.categoryBitMask = NodeType.reflector.rawValue
        self.physicsBody?.collisionBitMask = NodeType.ball.rawValue
        self.physicsBody?.contactTestBitMask = NodeType.ball.rawValue
        self.physicsBody?.friction = 0
        self.physicsBody?.restitution = 1
        self.opacity = 0
        self.castsShadow = false
        self.name = "reflector"
        ReflectorNode.reflector = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
