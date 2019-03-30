import SceneKit

public class BlockNode: SCNNode {
    
    public static var blocks = [SCNNode]()
    
    public static func generate(type:
        BlockType, gridSize: Int, lengh: Int) {
        let wallGeometry = WallNode.wall.geometry as! SCNBox
        let wallSize = wallGeometry.width
        let wallLengh = wallGeometry.length
        let blockSize = wallSize / CGFloat(gridSize)
        let geometry = type.generateGeometry(blockSize)
        geometry.materials.first?.diffuse.contents = UIImage(named: "blockTexture.jpg")?.texturelize()
        let baseX = WallNode.wall.position.x - Float(wallSize) / 2 + Float(blockSize / 2)
        let baseY = WallNode.wall.position.y - Float(wallSize) / 2 + Float(blockSize / 2)
        let baseZ = WallNode.wall.position.z + Float(wallLengh) / 2 + Float(blockSize / 2)
        for length in 0..<lengh {
            for column in 0..<gridSize {
                for row in 0..<gridSize {
                    let block = SCNNode(geometry: geometry)
                    block.name = "block"
                    block.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: geometry, options: nil))
                    block.physicsBody?.categoryBitMask = NodeType.block.rawValue
                    block.physicsBody?.collisionBitMask = NodeType.ball.rawValue
                    block.physicsBody?.contactTestBitMask = NodeType.ball.rawValue
                    block.physicsBody?.friction = 0
                    block.physicsBody?.restitution = 1
                    block.physicsBody?.contactTestBitMask = 2
                    let position = SCNVector3(x: baseX + Float(blockSize) * Float(column), y: baseY + Float(blockSize) * Float(row), z: baseZ + Float(blockSize) * Float(length))
                    block.position = position
                    blocks.append(block)
                }
            }
        }
    }
}
