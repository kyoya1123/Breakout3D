import SceneKit

public class BallNode: SCNNode {
    
    public static var ball: SCNNode?
    
    public init(size: CGFloat, type: BallType, camera: SCNNode) {
        super.init()
        let geometry = type.generateGeometry(size)
        geometry.materials.first?.diffuse.contents = UIImage(named: "ballTexture.jpeg")?.texturelize()
        self.geometry = geometry
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: geometry, options: nil))
        self.physicsBody?.categoryBitMask = NodeType.ball.rawValue
        self.physicsBody?.collisionBitMask = NodeType.wall.rawValue | NodeType.block.rawValue | NodeType.reflector.rawValue
        self.physicsBody?.contactTestBitMask = NodeType.wall.rawValue | NodeType.block.rawValue | NodeType.reflector.rawValue
        self.physicsBody?.friction = 0
        self.physicsBody?.restitution = 1
        self.physicsBody?.damping = 0
        self.physicsBody?.angularDamping = 0
        let transform = camera.transform
        let direction = SCNVector3(-1 * transform.m31, -1 * transform.m32 + 0.1, -1 * transform.m33)
        self.physicsBody?.velocity = direction
        self.position = camera.position
        self.name = "ball"
        BallNode.ball = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
