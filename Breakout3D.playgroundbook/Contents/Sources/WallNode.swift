import SceneKit

public class WallNode: SCNNode {
    
    public static var wall: SCNNode!
    public static var roundWalls = [SCNNode]()
    
    public init(size: CGFloat, position: SCNVector3) {
        super.init()
        let geometry = SCNBox(width: size, height: size, length: 0.002, chamferRadius: 0)
        geometry.materials.first?.diffuse.contents = #colorLiteral(red: 0.4201149642, green: 0.8449782729, blue: 0.267064929, alpha: 1)
            //UIColor.green
        self.geometry = geometry
        self.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: geometry, options: nil))
        self.physicsBody?.categoryBitMask = NodeType.wall.rawValue
        self.physicsBody?.collisionBitMask = NodeType.ball.rawValue
        self.physicsBody?.contactTestBitMask = NodeType.ball.rawValue
        self.physicsBody?.friction = 0
        self.physicsBody?.restitution = 1
        self.opacity = 0.5
        self.castsShadow = false
        self.name = "wall"
        self.position = position
        WallNode.wall = self
        WallNode.generateRoundWalls(length: 1.2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func generateRoundWalls(length: CGFloat) {
        for i in 0..<4 {
            let wallGeometry = WallNode.wall.geometry as! SCNBox
            let geometry = SCNBox(width: length, height: wallGeometry.height, length: wallGeometry.length, chamferRadius: 0)
            geometry.materials.first?.diffuse.contents = #colorLiteral(red: 0.4201149642, green: 0.8449782729, blue: 0.267064929, alpha: 1)
            let roundWall = SCNNode(geometry: geometry)
            roundWall.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: geometry, options: nil))
            roundWall.physicsBody?.categoryBitMask = NodeType.wall.rawValue
            roundWall.physicsBody?.collisionBitMask = NodeType.ball.rawValue
            roundWall.physicsBody?.contactTestBitMask = NodeType.ball.rawValue
            roundWall.physicsBody?.friction = 0
            roundWall.physicsBody?.restitution = 1
            roundWall.opacity = 0.5
            roundWall.name = "wall"
            roundWall.castsShadow = false
            let wall = WallNode.wall!
            let baseZ = wall.position.z + Float(wallGeometry.length) / 2 + Float(geometry.width / 2)
            var position: SCNVector3!
            switch i {
            case 0:
                let baseX = wall.position.x - Float(wallGeometry.width) / 2 + Float(geometry.length / 2)
                position = SCNVector3(baseX, wall.position.y, baseZ)
                roundWall.eulerAngles.y = -.pi / 2
            case 1:
                let baseX = wall.position.x + Float(wallGeometry.width) / 2 - Float(geometry.length / 2)
                position = SCNVector3(baseX, wall.position.y, baseZ)
                roundWall.eulerAngles.y = -.pi / 2
            case 2:
                let baseY = wall.position.y - Float(wallGeometry.height) / 2 + Float(geometry.length / 2)
                position = SCNVector3(wall.position.x, baseY, baseZ)
                roundWall.eulerAngles.x = -.pi / 2
                roundWall.eulerAngles.y = -.pi / 2
            case 3:
                let baseY = wall.position.y + Float(wallGeometry.height) / 2 - Float(geometry.length / 2)
                position = SCNVector3(wall.position.x, baseY, baseZ)
                roundWall.eulerAngles.x = -.pi / 2
                roundWall.eulerAngles.y = -.pi / 2
            default:
                break
            }
            roundWall.position = position
            roundWalls.append(roundWall)
        }
    }
    
    public static func changeColor(_ color: UIColor) {
        wall.geometry?.firstMaterial?.diffuse.contents = color
        roundWalls.forEach {
            $0.geometry?.firstMaterial?.diffuse.contents = color
        }
    }
}
