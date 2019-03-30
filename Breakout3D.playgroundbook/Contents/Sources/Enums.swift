import SceneKit

public enum BallType {
    case box
    case sphere
    case cylinder
    case cone
    case capsule
    case torus
    case pyramid
}

public enum BlockType {
    case box
    case sphere
    case cylinder
    case cone
    case capsule
    case torus
}

public enum NodeType: Int {
    case wall = 1
    case ball = 2
    case block = 4
    case reflector = 8
    case border = 16
}

extension BallType: RawRepresentable {
    public typealias RawValue = SCNGeometry
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case is SCNBox: self = .box
        case is SCNSphere: self = .sphere
        case is SCNCylinder: self = .cylinder
        case is SCNCone: self = .cone
        case is SCNCapsule: self = .capsule
        case is SCNTorus: self = .torus
        case is SCNPyramid: self = .pyramid
        default: return nil
        }
    }
    
    public var rawValue: RawValue {
        switch self {
        case .box: return SCNBox()
        case .sphere: return SCNSphere()
        case .cylinder: return SCNCylinder()
        case .cone: return SCNCone()
        case .capsule: return SCNCapsule()
        case .torus: return SCNTorus()
        case .pyramid: return SCNPyramid()
        }
    }
    
    public func generateGeometry(_ size: CGFloat) -> SCNGeometry {
        switch self {
        case .box:
            return SCNBox(width: size, height: size, length: size, chamferRadius: 0)
        case .sphere:
            return SCNSphere(radius: size / 2)
        case .cylinder:
            return SCNCylinder(radius: size / 2, height: size)
        case .cone:
            return SCNCone(topRadius: size / 4, bottomRadius: size / 2, height: size)
        case .capsule:
            return SCNCapsule(capRadius: size / 4, height: size)
        case .torus:
            return SCNTorus(ringRadius: size / 2, pipeRadius: size / 4)
        case .pyramid:
            return SCNPyramid(width: size, height: size, length: size)
        }
    }
}

extension BlockType: RawRepresentable {
    public typealias RawValue = SCNGeometry
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case is SCNBox: self = .box
        case is SCNSphere: self = .sphere
        case is SCNCylinder: self = .cylinder
        case is SCNCone: self = .cone
        case is SCNCapsule: self = .capsule
        case is SCNTorus: self = .torus
        default: return nil
        }
    }
    
    public var rawValue: RawValue {
        switch self {
        case .box: return SCNBox()
        case .sphere: return SCNSphere()
        case .cylinder: return SCNCylinder()
        case .cone: return SCNCone()
        case .capsule: return SCNCapsule()
        case .torus: return SCNTorus()
        }
    }
    
    public func generateGeometry(_ size: CGFloat) -> SCNGeometry {
        switch self {
        case .box:
            return SCNBox(width: size, height: size, length: size, chamferRadius: 0)
        case .sphere:
            return SCNSphere(radius: size / 2)
        case .cylinder:
            return SCNCylinder(radius: size / 2, height: size)
        case .cone:
            return SCNCone(topRadius: size / 4, bottomRadius: size / 2, height: size)
        case .capsule:
            return SCNCapsule(capRadius: size / 4, height: size)
        case .torus:
            return SCNTorus(ringRadius: size / 3, pipeRadius: size / 4)
        }
    }
}
