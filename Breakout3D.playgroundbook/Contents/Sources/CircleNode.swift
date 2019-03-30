import SceneKit

public class CircleNode: SCNNode {
    
    public static var circles = [SCNNode]()
    
    public init(position: SCNVector3, wall: SCNNode) {
        super.init()
        let geometry = SCNCone(topRadius: 0.02, bottomRadius: 0.02, height: 0.001)
        geometry.firstMaterial?.diffuse.contents = UIColor.white
        self.geometry = geometry
        self.eulerAngles = wall.eulerAngles
        self.position = position
        self.castsShadow = false
        switch WallNode.roundWalls.index(of: wall) {
        case 0: self.position.x += 0.003
        self.eulerAngles.x = -.pi / 2
        case 1: self.position.x -= 0.003
        self.eulerAngles.x = -.pi / 2
        case 2: self.position.y -= 0.003
        self.eulerAngles.z = -.pi / 2
        case 3: self.position.y += 0.003
        self.eulerAngles.z = -.pi / 2
        default:
            self.position.y += 0.003
            self.eulerAngles.x = -.pi / 2
        }
        self.runAction(SCNAction.sequence([
            SCNAction.scale(to: 0, duration: 0.5),
            SCNAction.removeFromParentNode()
            ])) {
                CircleNode.circles.removeFirst()
        }
        CircleNode.circles.append(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
