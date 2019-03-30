import UIKit
import SceneKit
import ARKit
import AVFoundation
import AudioToolbox
import PlaygroundSupport

public class ClassicViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate, PlaygroundLiveViewSafeAreaContainer {
    
    var sceneView: ARSCNView = ARSCNView()
    var messageLabel = UILabel()
    var blurView = UIVisualEffectView()
    var remainingBallsLabel = UILabel()
    var borderCoordinate = [Float]()
    var balls = 3
    var soundEffectPlayers: [String : AVAudioPlayer] = [:]
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view = sceneView
        
        sceneView.clipsToBounds = true
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sceneView.leadingAnchor.constraint(equalTo: self.liveViewSafeAreaGuide.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: self.liveViewSafeAreaGuide.trailingAnchor),
            sceneView.topAnchor.constraint(equalTo: self.liveViewSafeAreaGuide.topAnchor),
            sceneView.bottomAnchor.constraint(equalTo: self.liveViewSafeAreaGuide.bottomAnchor)
            ])
        sceneView.delegate = self
        sceneView.scene.physicsWorld.contactDelegate = self
        sceneView.scene.physicsWorld.gravity = SCNVector3(0,0,0)
        setupLabel()
        startGuide()
        setupLights()
        setupAudio()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.run(ARWorldTrackingConfiguration())
    }
    
    func setupLabel() {
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.font = UIFont.systemFont(ofSize: 35.0, weight: .bold)
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 2
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurView)
        view.addSubview(messageLabel)
        let messageLabelleftMarginConstraint = NSLayoutConstraint(item: messageLabel, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let messageLabelrightMarginConstraint = NSLayoutConstraint(item: messageLabel, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        let messageLabelcenterXConstraint = NSLayoutConstraint(item: messageLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let messageLabelcenterYConstraint = NSLayoutConstraint(item: messageLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        let messageLabelheightConstraint = NSLayoutConstraint(item: messageLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 200)
        view.addConstraints([messageLabelleftMarginConstraint, messageLabelrightMarginConstraint, messageLabelcenterXConstraint, messageLabelcenterYConstraint, messageLabelheightConstraint])
        let blurViewleftMarginConstraint = NSLayoutConstraint(item: blurView, attribute: .left, relatedBy: .equal, toItem: messageLabel, attribute: .left, multiplier: 1, constant: 0)
        let blurViewrightMarginConstraint = NSLayoutConstraint(item: blurView, attribute: .right, relatedBy: .equal, toItem: messageLabel, attribute: .right, multiplier: 1, constant: 0)
        let blurViewtopMarginConstraint = NSLayoutConstraint(item: blurView, attribute: .top, relatedBy: .equal, toItem: messageLabel, attribute: .top, multiplier: 1, constant: 0)
        let blurViewbottomMarginConstraint = NSLayoutConstraint(item: blurView, attribute: .bottom, relatedBy: .equal, toItem: messageLabel, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraints([blurViewleftMarginConstraint, blurViewrightMarginConstraint, blurViewtopMarginConstraint, blurViewbottomMarginConstraint])
    }
    
    func setupLights() {
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.intensity = 200
        sceneView.scene.rootNode.light = ambientLight
        
        let LightNode = SCNNode()
        let light = SCNLight()
        light.type = .omni
        LightNode.light = light
        LightNode.position = SCNVector3(0,0,0.3)
        sceneView.scene.rootNode.addChildNode(LightNode)
    }
    
    func setupAudio() {
        let names = ["hitWall", "breakBlock", "missed", "start", "clear", "gameover"]
        names.forEach {
            let soundURL = URL(fileURLWithPath: Bundle.main.path(forResource: $0, ofType: "mp3")!)
            let soundPlayer = try! AVAudioPlayer(contentsOf: soundURL)
            soundPlayer.prepareToPlay()
            soundEffectPlayers[$0] = soundPlayer
        }
    }
    
    func startGuide() {
        messageLabel.text = "Look forward!"
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            self.placeNodes()
            self.messageLabel.text = "Tap to start!"
            self.sceneView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didtapScreen)))
        }
    }
    
    @objc func didtapScreen() {
        messageLabel.isHidden = true
        blurView.removeFromSuperview()
        launchBall()
    }
    
    func launchBall() {
        if let ball = BallNode.ball {
            if sceneView.scene.rootNode.childNodes.contains(ball) {
                return
            }
        }
        sceneView.scene.rootNode.addChildNode(BallNode(size: 0.05, type: .sphere, camera: sceneView.pointOfView!))
    }
    
    func generateWall() {
        var position = sceneView.pointOfView!.position
        position.z -= 0.8
        sceneView.scene.rootNode.addChildNode(WallNode(size: 0.5, position: position))
        WallNode.roundWalls.forEach {
            sceneView.scene.rootNode.addChildNode($0)
        }
    }
    
    func setBorder() {
        let roundWallGeometry = WallNode.roundWalls[0].geometry as! SCNBox
        borderCoordinate = [WallNode.roundWalls[0].position.x, WallNode.roundWalls[1].position.x, WallNode.roundWalls[2].position.y, WallNode.roundWalls[3].position.y, WallNode.wall.position.z, WallNode.wall.position.z + Float(roundWallGeometry.width)]
    }
    
    var timer = Timer()
    func placeNodes() {
        generateWall()
        BlockNode.generate(type: .box, gridSize: 5, lengh: 1)
        setBorder()
        print(borderCoordinate)
        playSound("start")
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(placeBlock), userInfo: nil, repeats: true)
    }
    
    var index = 0
    @objc func placeBlock() {
        if BlockNode.blocks.count == index {
            timer.invalidate()
            return
        }
        sceneView.scene.rootNode.addChildNode(BlockNode.blocks[index])
        index += 1
    }
    
    func wentOut() {
        BallNode.ball!.removeFromParentNode()
        BallNode.ball = nil
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        balls -= 1
        if balls == 0 {
            gameover()
            return
        }
        DispatchQueue.main.async {
            self.messageLabel.isHidden.toggle()
            self.messageLabel.text = "\(self.balls) balls remaining"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.messageLabel.isHidden.toggle()
            }
        }
        playSound("missed")
        WallNode.changeColor(.red)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            WallNode.changeColor(#colorLiteral(red: 0.4201149642, green: 0.8449782729, blue: 0.267064929, alpha: 1))
        }
    }
    
    func playSound(_ name: String) {
        soundEffectPlayers[name]!.currentTime = 0
        soundEffectPlayers[name]!.play()
    }
    
    func gameover() {
        playSound("gameover")
        DispatchQueue.main.async {
            self.messageLabel.isHidden.toggle()
            self.messageLabel.text = "GAMEOVER"
            self.sceneView.gestureRecognizers = nil
        }
        WallNode.changeColor(.red)
        PlaygroundPage.current.assessmentStatus = .pass(message: "Woops! You've lost all of the balls…😢 You can play this mode again or go to the [**Next Page**](@next).")
    }
    
    func clear() {
        BallNode.ball!.removeFromParentNode()
        BallNode.ball = nil
        playSound("clear")
        WallNode.changeColor(.yellow)
        PlaygroundPage.current.assessmentStatus = .pass(message: "**Good Job! 🎉** You've cleared Classic mode! Now let's go to the [**Next Page**](@next) and try to make your original stage.")
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if let ball = BallNode.ball {
            ball.physicsBody?.velocity = ball.physicsBody!.velocity.normalized() * 0.7
            if !borderCoordinate.isEmpty {
                let position = ball.presentation.position
                if  position.x < borderCoordinate[0] ||
                    position.x > borderCoordinate[1] ||
                    position.y < borderCoordinate[2] ||
                    position.y > borderCoordinate[3] ||
                    position.z < borderCoordinate[4] ||
                    position.z > borderCoordinate[5] {
                    wentOut()
                }
            }
        }
        
        if let reflector = ReflectorNode.reflector {
            reflector.position = sceneView.pointOfView!.position
            reflector.position.z += 0.01
            reflector.eulerAngles = sceneView.pointOfView!.eulerAngles
        } else {
            sceneView.scene.rootNode.addChildNode(ReflectorNode(width: 0.2, height: 0.2))
        }
    }

    public func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let touchedObject = contact.nodeA
        switch touchedObject.name {
        case "block":
            playSound("breakBlock")
            touchedObject.removeFromParentNode()
            sceneView.scene.rootNode.addChildNode(ParticleNode(position: touchedObject.position))
            BlockNode.blocks.remove(at: BlockNode.blocks.index(of: touchedObject)!)
            if BlockNode.blocks.isEmpty {
                clear()
            }
        case "wall":
            if CircleNode.circles.count > 3 {
                return
            }
            sceneView.scene.rootNode.addChildNode(CircleNode(position: contact.contactPoint, wall: touchedObject))
            playSound("hitWall")
        default:
            break
        }
    }
}
