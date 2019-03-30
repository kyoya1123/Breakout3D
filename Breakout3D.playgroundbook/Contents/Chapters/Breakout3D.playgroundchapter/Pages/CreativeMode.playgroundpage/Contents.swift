/*:
 # Creative Mode
 
 In **Creative** mode, you can customize the blocks, balls, speed. Create your own stage and enjoy this AR breakout more!
 
 ## Parameters
 This breakout isn't 2D, why don't you try other shape of balls and blocks? Ball bounds unexpectedly, it must be fun!
 */

import UIKit

//Select from .box, .sphere, .cylinder, .cone, .capsule, .torus, .pyramid
let ballShape: BallType = .sphere

let ballSize: CGFloat = 0.05

let ballSpeed: Float = 0.7

//Select from .box, .sphere, .cylinder, .cone, .capsule, .torus
let blockShape: BlockType = .box

let amoutOfBlocks: (Int, Int) = (gridSize: 5, length: 1)

//#-hidden-code
import PlaygroundSupport

let viewController = CreativeViewController(ballShape, ballSize, ballSpeed, blockShape, amoutOfBlocks)

PlaygroundPage.current.liveView = viewController
PlaygroundPage.current.needsIndefiniteExecution = true
//#-end-hidden-code
