//
//  GameScene.swift
//  Feed Me
//
//  Created by 20063914 on 09/11/2018.
//  Copyright © 2018 Brian McCarthy. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var crocodile: SKSpriteNode!
    private var prize: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        //setUpPhysics()
        setUpScenery()
        //setUpPrize()
        //setUpVines()
        //setUpCrocodile()
        //setUpAudio()
    }
    
    //MARK: - Level setup
    fileprivate func setUpPhysics() {}
    
    fileprivate func setUpScenery() {
        let background: SKSpriteNode = SKSpriteNode(imageNamed: ImageName.Background)
        background.anchorPoint = CGPoint(x: 0, y: 0)
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = Layer.Background
        background.size = self.size
        addChild(background)
        
        let water: SKSpriteNode = SKSpriteNode(imageNamed: ImageName.Water)
        water.anchorPoint = CGPoint(x: 0, y: 0)
        water.position = CGPoint(x: 0, y: 0)
        water.zPosition = Layer.Water
        water.size = CGSize(width: self.size.width, height: (self.size.height * 0.2139))
        addChild(water)
        
    }
    fileprivate func setUpPrize() {}
    
    //MARK: - View methods
    fileprivate func setUpVines() {}
    
    //MARK: - Croc methods
    fileprivate func setUpCrocodile() {
        let crocodile = SKSpriteNode(imageNamed: ImageName.CrocMouthClosed)
        crocodile.physicsBody = SKPhysicsBody(rectangleOf: (crocodile.texture?.size())!)
        crocodile.position = CGPoint(x: self.size.width * 0.75, y: self.size.height * 0.312)
        crocodile.zPosition = Layer.Crocodile
    }
    
    fileprivate func animateCrocodile() { }
    fileprivate func runNomNomAnimationWithDelay(_ delay: TimeInterval) { }
    
    //MARK: - Touch handling
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { }
    fileprivate func showMoveParticles(touchPosition: CGPoint) { }
    
    //MARK: - Game logic
    
    override func update(_ currentTime: TimeInterval) { }
    func didBegin(_ contact: SKPhysicsContact) { }
    fileprivate func checkIfVineCutWithBody(_ body: SKPhysicsBody) { }
    fileprivate func switchToNewGameWithTransition(_ transition: SKTransition) { }
    
    //MARK: - Audio
    
    fileprivate func setUpAudio() { }
    
}
