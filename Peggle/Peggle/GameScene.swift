//
//  GameScene.swift
//  Peggle
//
//  Created by 20063914 on 17/10/2018.
//  Copyright © 2018 Brian McCarthy. All rights reserved.
//
import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var editLabel: SKLabelNode!
    var ballsLabel: SKLabelNode!
    var maxBalls: Int = 5 {
        didSet {
            ballsLabel.text = "Balls: \(maxBalls)"
        }
    }
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        ballsLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballsLabel.text = "Balls: \(maxBalls)"
        ballsLabel.horizontalAlignmentMode = .right
        ballsLabel.position = CGPoint(x: 980, y: 650)
        addChild(ballsLabel)
        
        for x in 1...9 {
            for _ in 0...1 {
                // makeBox(at: CGPoint(x: RandomCGFloat(min: Float(100 * x), max: Float((100*x)+100)), y: RandomCGFloat(min: Float(300), max: Float(500))))
            }
        }
        
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(resize), SKAction.wait(forDuration: 3.0)])))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print(maxBalls)
        if let touch = touches.first {
            let location = touch.location(in: self)
            let objects = nodes(at: location)

            if objects.contains(editLabel) {
                editingMode = !editingMode
            } else {
                if editingMode {

                    for object in objects {
                        if object.name == "box" {
                            object.removeFromParent()
                        }
                    }
                    makeBox(at: location)
                    
                } else {
                    if maxBalls > 0 {
                       maxBalls -= 1
                        let r = RandomInt(min: 0, max: 7)
                        var ball: SKSpriteNode
                        
                        switch (r) {
                        case 0:
                            ball = SKSpriteNode(imageNamed: "ballBlue")
                        case 1:
                            ball = SKSpriteNode(imageNamed: "ballCyan")
                        case 2:
                            ball = SKSpriteNode(imageNamed: "ballGreen")
                        case 3:
                            ball = SKSpriteNode(imageNamed: "ballGrey")
                        case 4:
                            ball = SKSpriteNode(imageNamed: "ballPurple")
                        case 5:
                            ball = SKSpriteNode(imageNamed: "ballRed")
                        default:
                            ball = SKSpriteNode(imageNamed: "ballYellow")
                        }
                        
                        
                        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                        ball.physicsBody?.restitution = 0.4
                        ball.position = CGPoint(x: location.x, y: RandomCGFloat(min: 618, max: 768))
                        ball.name = "ball"
                        ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                        ball.userData = NSMutableDictionary()
                        ball.userData?.setValue(0, forKey: "pinCollisions")
                        ball.userData?.setValue(0, forKey: "bouncerCollisions")
                        ball.userData?.setValue(ball.position, forKey: "originalPos")
                        addChild(ball)
                    } else {
                        //print("Sorry No more balls")
                    }
                }
            }
        }
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        bouncer.name = "bouncer"
        //bouncer.s
        addChild(bouncer)
    }
    
    func resize() {
        let bouncers = children.filter { $0.name == "bouncer" }
        for bouncer in bouncers {
            let b = bouncer as! SKSpriteNode
            var action: SKAction!
            if b.size.width > 191 {
                action = SKAction.resize(toWidth: CGFloat(128.0), height: CGFloat(128.0), duration: 2)
            } else {
                action = SKAction.resize(toWidth: CGFloat(192.0), height: CGFloat(192.0), duration: 2)
            }
            b.run(action)
        }
    }
    
    func makeBox(at position: CGPoint) {
        let size = CGSize(width: GKRandomDistribution(lowestValue: 16, highestValue: 128).nextInt(), height: 16)
        let box = SKSpriteNode(color: RandomColor(), size: size)
        box.zRotation = RandomCGFloat(min: 0, max: 3)
        box.position = position
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.isDynamic = false
        box.name = "box"
        addChild(box)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        slotBase.userData = NSMutableDictionary()
        slotBase.userData?.setValue(slotGlow, forKey: "slotGlow")
        addChild(slotBase)
        addChild(slotGlow)
    }
    
    override func update(_ currentTime: TimeInterval) {
        var slots = children.filter { $0.name == "bad" }
        if slots.count == 4 {
            let i = RandomInt(min: 0, max: 3)
            makeSlot(at: slots[i].position, isGood: true)
            destroy(ball: slots[i])
        }
        
        let balls = children.filter { $0.name == "ball" }
        print(balls.count)
        
    }
    
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            if ball.userData?["pinCollisions"] as! Int >= 2 {
                score += 1
                maxBalls += 1
            }
            
            makeSlot(at: object.position, isGood: false)
            destroy(ball: object.userData?["slotGlow"] as! SKNode)
            destroy(ball: object)
        } else if object.name == "bad" {
            destroy(ball: ball)
            makeSlot(at: object.position, isGood: true)
            destroy(ball: object.userData?["slotGlow"] as! SKNode)
            destroy(ball: object)
            score -= 1
        } else if object.name == "box" {
            ball.userData?.setValue(ball.userData?["pinCollisions"] as! Int + 1, forKey: "pinCollisions")
            destroy(ball: object)
        } else if object.name == "bouncer" {
            ball.userData?.setValue(ball.userData?["bouncerCollisions"] as! Int + 1, forKey: "bouncerCollisions")
            if ball.userData?["bouncerCollisions"] as! Int == 2 {
                //ball.userData?.setValue(0, forKey: "bouncerCollisions")
                let bphysics: SKPhysicsBody = ball.physicsBody!
                ball.physicsBody = nil
                ball.position = ball.userData?["originalPos"] as! CGPoint
                ball.physicsBody = bphysics
            }
        }
    }

    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
    
}
